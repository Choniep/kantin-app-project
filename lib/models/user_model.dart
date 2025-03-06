class UserModel {
  final String uid;
  final String username;
  final String role;

  UserModel({
    required this.uid,
    required this.username,
    required this.role,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      username: data['username'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'role': role,
    };
  }
}
