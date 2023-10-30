class LoginResponse {
  bool status;
  UserData userData;
  String message;

  LoginResponse({
    this.status = false,
    required this.userData,
    this.message = "",
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] is bool ? json['status'] : false,
      userData: json['data'] is Map ? UserData.fromJson(json['data']) : UserData(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': userData.toJson(),
      'message': message,
    };
  }
}

class UserData {
  int id;
  String firstName;
  String lastName;
  String userName;
  String address;
  String mobile;
  String email;
  List<String> userRole;
  String apiToken;
  String profileImage;
  String loginType;
  String playerId;
  bool isSocialLogin;

  UserData({
    this.id = -1,
    this.firstName = "",
    this.lastName = "",
    this.userName = "",
    this.address = "",
    this.mobile = "",
    this.email = "",
    this.userRole = const <String>[],
    this.apiToken = "",
    this.profileImage = "",
    this.loginType = "",
    this.playerId = "",
    this.isSocialLogin = false,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] is int ? json['id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      userName: json['user_name'] is String ? json['user_name'] : "${json['first_name']} ${json['last_name']}",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      address: json['address'] is String ? json['address'] : "",
      email: json['email'] is String ? json['email'] : "",
      userRole: json['user_role'] is List ? List<String>.from(json['user_role'].map((x) => x)) : [],
      apiToken: json['api_token'] is String ? json['api_token'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      loginType: json['login_type'] is String ? json['login_type'] : "",
      playerId: json['player_id'] is String ? json['player_id'] : "",
      isSocialLogin: json['is_social_login'] is bool ? json['is_social_login'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'mobile': mobile,
      'address': address,
      'email': email,
      'user_role': userRole.map((e) => e).toList(),
      'api_token': apiToken,
      'profile_image': profileImage,
      'login_type': loginType,
      'player_id': playerId,
      'is_social_login': isSocialLogin,
    };
  }
}
