class Utilisateur {
  Utilisateur(
      {
        required this.uid,
        required this.name,
      required this.password,
      required this.email,
      required this.tel,
       this.avatar});
late String uid;
  late String name;
  late String email;
  late String password;
  late String? avatar = "";
  late int tel;

  Map<String, dynamic> toMap() {
    return {
      'uid':uid,
      'name': name,
      'email': email,
      'tel': tel,
      'avatar':avatar
    };
  }
}
