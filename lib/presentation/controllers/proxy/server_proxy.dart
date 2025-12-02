part of proxy;

class _ServerProxy extends Proxy {
  final Future<void> Function() onTokenExpired;
  DioService _service;
  List<String?> _missionPhotos = [];

  _ServerProxy(String host, {required this.onTokenExpired})
    : _service = DioService(onTokenExpired: onTokenExpired) {}

  @override
  Future<void> init() async {
    print("Connecting server...");
    String response = "";
    while (response != "success") {
      final get = await _service.dio.get("");
      response = get.data["status"];
    }
    print("Connected!");
  }

  @override
  Future<String?> getToken() async {
    await onTokenExpired();
    return null;
  }

  @override
  Future<bool> setToken(String token) async {
    _service.token = token;
    final response = (await _service.dio.get("/user/security")).data;
    if (response['status'] == "success") return true;
    return false;
  }

  @override
  Future<bool> clear() async {
    return true;
  }

  @override
  Future<bool> setAccount(UserAccountCore user) async {
    try {
      final response = await _service.dio.patch(
        "/user/profile",
        data: {"name": user.username, "age": user.age, "city": user.city},
      );
      if (response.data['status'] == "success") {
        return true;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response!.data['error']['message'];

        if (msg is List) {
          throw Exception(msg.join(", "));
        } else {
          throw Exception(msg.toString());
        }
      } else {
        throw Exception(1);
      }
    }
    return false;
  }

  @override
  Future<bool> setQuests(Quests quest) async {
    return true;
  }

  @override
  Future<Quests> getQuests() async {
    final response = await _service.dio.get("/location/locations");
    final jsonBody = response.data;
    late final List<LocationModel> dataLocation;
    if (jsonBody['status'] == 'success') {
      final List<dynamic> data = jsonBody['data'];
      dataLocation = data.map((e) => LocationModel.fromJson(e)).toList();
    } else
      throw Exception(1);
    late final List<MissionModel> dataMissions;
    {
      final response = await _service.dio.get("/mission/missions");
      final jsonBody = response.data;

      if (jsonBody['status'] == 'success') {
        final List<dynamic> data = jsonBody['data'];
        dataMissions = data.map((e) => MissionModel.fromJson(e)).toList();
      } else
        throw Exception(1);
    }
    {
      final response = await _service.dio.get("/mission/visit");
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List data = response.data['data'];
        data.forEach((element) {
          final id = element["missionID"] as int;
          final tmp = element['images'][0];
          final url = tmp['url'];
          dataMissions[id].isCompleted = true;
          if (id >= _missionPhotos.length) _missionPhotos.length = id + 1;
          _missionPhotos[id] = url;
        });
      }
    }

    return Quests(locations: dataLocation, missions: dataMissions);
  }

  @override
  Future<String?> fetchMission(int id) async {
    if (id >= _missionPhotos.length || _missionPhotos[id] == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final source = "${dir.path}/$id";
    if (!(await File(source).exists())) {
      final response = await http.get(Uri.parse(_missionPhotos[id]!));
      if (response.statusCode != 200) {
        throw Exception("Error fetch image id ${_missionPhotos[id]}");
      }
      final file = File(source);
      file.writeAsBytes(response.bodyBytes);
    }
    return source;
  }

  @override
  Future<UserAccountCore> getAccount() async {
    final response = await _service.dio.get("/user/info");

    if (response.data['status'] == "success") {
      final userJson = response.data['data'];

      if (userJson != null) {
        final user = UserAccountCore.fromJson(userJson);
        return user;
      }
    }
    throw Exception("Fetch user data failed");
  }

  @override
  Future<String?> login(String email, String password) async {
    try {
      print("Email $email");
      print("Password: $password");
      final response = await _service.dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      if (response.data["status"] == "success") {
        final token = response.data['data']['access_token'];
        _service.token = token;
        return token;
      }

      // throw Exception("Unexpected server format.");
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response!.data['error']['message'];

        if (msg is List) {
          throw Exception(msg.join(", "));
        } else {
          throw Exception(msg.toString());
        }
      } else {
        throw Exception("Network error: ${e.message}");
      }
    }
  }

  @override
  Future<String?> signup(String email, String password) async {
    try {
      final response = await _service.dio.post(
        "/auth/signup",
        data: {"email": email, "password": password},
      );

      if (response.data['status'] == "success") {
        final token = response.data['data']['access_token'];
        _service.token = token;
        return token;
      } else {
        return null;
        // throw Exception("Sign up error: ${response.data['error']['message']}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response!.data['error']['message'];

        if (msg is List) {
          throw Exception(msg.join(", "));
        } else {
          throw Exception(msg.toString());
        }
      } else {
        throw Exception(1);
      }
    }
  }

  @override
  Future<String?> postMission(int id, String src) async {
    try {
      final fileName = src.split('/').last;

      FormData formData = FormData.fromMap({
        "files": await MultipartFile.fromFile(
          src,
          filename: fileName,
          contentType: DioMediaType("image", "jpeg"),
        ),
        'missionID': id,
      });
      final response = await _service.dio.post(
        "/mission/image",
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Response data success: $response");
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          final dir = await getApplicationDocumentsDirectory();
          final source = "${dir.path}/$id";
          if (src != source) {
            File file = File(src);
            await file.copySync(source);
          }
          return source;
        }
      }
    } catch (e) {
      if (e is DioException) {
        print("Lỗi server trả về: ${e.response?.data}");
      }
    }
    return null;
  }

  @override
  Future<String?> postAIMission(int id, String src) async {
    try {
      final fileName = src.split('/').last;

      FormData formData = FormData.fromMap({
        "files": await MultipartFile.fromFile(
          src,
          filename: fileName,
          contentType: DioMediaType("image", "jpeg"),
        ),
        'missionID': id,
      });
      final response = await _service.dio.post(
        "/mission/image",
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Response data success: $response");
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          final dir = await getApplicationDocumentsDirectory();
          final source = "${dir.path}/$id";
          if (src != source) {
            File file = File(src);
            await file.rename(source);
          }
          return source;
        }
      }
    } catch (e) {
      if (e is DioException) {
        print("Lỗi server trả về: ${e.response?.data}");
      }
    }
    return null;
  }

  @override
  Future<String?> createVideo(List<String> urls, List<int> id) async {
    try {
      print("Calling API creating video...");

      final Map<String, dynamic> body = {
        "urls": urls,
        "frame_index_list": id,
        "group_num_list": List.filled(urls.length, "1"),
      };

      final response = await _service.dio.post(
        "/video/generation",
        data: body,
        options: Options(
          sendTimeout: const Duration(minutes: 1),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      // Check status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          final videoUrl = responseData['data'];
          print("Video URL: ${videoUrl}");
          if (videoUrl != null && videoUrl.toString().isNotEmpty) {
            return videoUrl.toString();
          }
        }
      }
    } catch (e) {
      print("Error API Video: $e");
      if (e is DioException) {
        print("Error Server: ${e.response?.data}");
      }
    }
    return null;
  }

  Future<bool> isLogged() async {
    return _service.isLogged;
  }

  @override
  Future<bool> completeRoute(GameRoute route) async {
    return true;
  }
}
