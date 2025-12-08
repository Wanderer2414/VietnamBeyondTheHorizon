part of proxy;

class _ServerProxy extends Proxy {
  final Future<void> Function() onTokenExpired;
  DioService _service;

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
  Future<bool> clear() async {
    return true;
  }

  @override
  Future<bool> updateAccount(String name, int age, String city) async {
    try {
      final response = await _service.dio.patch(
        "/user/profile",
        data: {"name": name, "age": age, "city": city},
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

  Future<List<({int id, List<String> url})>?> _getVisit() async {
    final response = await _service.dio.get("/mission/visit");
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      final List data = response.data['data'];
      final result = data.map((element) {
        ({int id, List<String> url}) res = (
          url: (element['images'] as List<dynamic>)
              .map((e) => e['url'] as String)
              .toList(),
          id: element["missionID"] as int,
        );
        return res;
      }).toList();
      return result;
    }
    return null;
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
    final quest = Quests(locations: dataLocation, missions: dataMissions);
    (await _getVisit())?.forEach((e) {
      quest.missions[e.id]!.isCompleted = true;
      quest.missions[e.id]!.illustrationURL = e.url[0];
    });
    return quest;
  }

  @override
  Future<String?> fetchMission(int id) async {
    return null;
    // if (id >= _missionPhotos.length || _missionPhotos[id] == null) return null;
    // final dir = await getApplicationDocumentsDirectory();
    // final source = "${dir.path}/$id";
    // if (!(await File(source).exists())) {
    //   final response = await http.get(Uri.parse(_missionPhotos[id]!));
    //   if (response.statusCode != 200) {
    //     throw Exception("Error fetch image id ${_missionPhotos[id]}");
    //   }
    //   final file = File(source);
    //   file.writeAsBytes(response.bodyBytes);
    // }
    // return source;
  }

  Future<UserAccountCore> _getAccount() async {
    final response = await _service.dio.get("/user/info");

    if (response.data['status'] == "success") {
      final userJson = response.data['data'];
      if (userJson != null) {
        final user = UserAccountCore.fromJson(userJson);
        (await _getVisit())?.forEach((element) {
          user.missionCompleted.push(id: element.id, url: element.url);
        });
        user.videos = (await _fetchVideoUrls());

        return user;
      }
    }
    throw Exception("Fetch user data failed");
  }

  @override
  Future<UserAccountCore?> login(String email, String password) async {
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
        final account = await _getAccount();
        account.token = token;
        return account;
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
  Future<UserAccountCore?> signup(String email, String password) async {
    try {
      final response = await _service.dio.post(
        "/auth/signup",
        data: {"email": email, "password": password},
      );

      if (response.data['status'] == "success") {
        final token = response.data['data']['access_token'];
        _service.token = token;
        final account = await _getAccount();
        account.token = token;
        return account;
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

      print("Start posting image.....");
      print("TOKEN WHEN POSTING IMAGE: ${_service.token}");
      final response = await _service.dio.post(
        "/mission/image",
        data: formData,
      );
      print("Get response!");

      print("response.status = ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Response data success: $response");
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          print(responseData["data"]);
          return responseData["data"];
        }
      }
    } catch (e) {
      if (e is DioException) {
        print("Lỗi server trả về: ${e.response?.data}");
        print("Response status code: ${e.response?.statusCode}");
        print("Response: ${e.response}");
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
        final responseData = response.data;
        print(response.toString());
        if (responseData is Map && responseData['status'] == 'success') {
          return responseData["url"];
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

  @override
  Future<UserAccountCore?> isLogged(String? token) async {
    if (token != null)
      _service.token = token;
    else if (_service.token == null)
      return null;
    final response = (await _service.dio.get("/user/security"));
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == "success") return await _getAccount();
    }
    return null;
  }

  @override
  Future<bool> completeRoute(GameRoute route) async {
    return true;
  }

  Future<List<String>> _fetchVideoUrls() async {
    try {
      final response = await _service.dio.get("/video/videos");

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final listData = response.data['data'];
        if (listData is List) {
          return listData
              .map((e) {
                if (e is Map) {
                  return e['url']?.toString() ?? "";
                }
                return "";
              })
              .where((url) => url.isNotEmpty)
              .toList();
        }
      }
    } catch (e) {
      print("Error fetch video: $e");
    }
    return [];
  }

  @override
  Future<String?> updateAvatar(String src) async {
    try {
      final fileName = src.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          src,
          filename: fileName,
          contentType: DioMediaType("image", "jpeg"),
        ),
      });

      final response = await _service.dio.patch("/user/avatar", data: formData);

      print("response.status = ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Response data success: $response");
        final responseData = response.data;
        if (responseData['status'] == 'success') {
          print(responseData["data"]);
          if (responseData["data"] != null) {
            return responseData["data"];
          }
        }
      }
    } on DioException catch (e) {
      print("Lỗi server trả về: ${e.response?.data}");
    }
    return null;
  }
}
