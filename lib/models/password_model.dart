class PasswordModel {
  int? id;
  String account;
  String username;
  String password;

  PasswordModel({
    this.id,
    required this.account,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'account': account,
      'username': username,
      'password': password,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      id: map['id'],
      account: map['account'],
      username: map['username'],
      password: map['password'],
    );
  }
}
