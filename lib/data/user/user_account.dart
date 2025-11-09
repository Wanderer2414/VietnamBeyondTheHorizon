class UserAccount {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;

  final DateTime createdAt;
  final DateTime lastLogin;

  UserAccount({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.createdAt,
    required this.lastLogin,
  });
}
