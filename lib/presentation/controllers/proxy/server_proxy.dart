part of proxy;

class ServerProxy extends Proxy {
  final Function() onTokenExpired;
  DioService _service;

  ServerProxy(String host, {required this.onTokenExpired, super.subProxy})
    : _service = DioService(onTokenExpired: onTokenExpired) {}

  @override
  Future<void> _init() async {
    print("Connecting server...");
    String response = "";
    while (response != "success") {
      final get = await _service.dio.get("");
      response = get.data["status"];
    }
    print("Connected!");
  }

  @override
  Future<String?> _getToken() async {
    onTokenExpired();
    return null;
  }

  @override
  Future<bool> _setToken(String token) async {
    _service.token = token;
    final response = (await _service.dio.get("/user/security")).data;
    if (response['status'] == "success") return true;
    return false;
  }

  @override
  Future<bool> _clear() async {
    return true;
  }

  @override
  Future<bool> _setAccount(UserAccountCore user) async {
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
  Future<bool> _setQuests(Quests quest) async {
    return true;
  }

  @override
  Future<Quests> _getQuests() async {
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
    print(
      "Load ${dataLocation.length} locations, ${dataMissions.length} missions!",
    );
    return Quests(locations: dataLocation, missions: dataMissions);
  }

  @override
  Future<UserAccountCore> _getAccount() async {
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
  Future<String?> _signin(String email, String password) async {
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
  Future<String?> _signup(String email, String password) async {
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
  Future<bool> _postMission(int id, String src) async {
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
      await _service.dio.post("/mission/similarity", data: formData);
    } catch (e) {
      if (e is DioException) {
        print("Lỗi server trả về: ${e.response?.data}");
      }
    }
    return true;
  }

  Future<bool> isLogged() async {
    return _service.isLogged;
  }
}
