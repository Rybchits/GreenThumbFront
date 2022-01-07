class User {
    int id = 0;
    String name = "";
    String email = "";
    String? urlAvatar = "";

    User({int? idUser, String? nameUser, String? emailUser, String? urlAvatarUser}){
        id = idUser ?? 0;
        name = nameUser ?? "";
        email = emailUser ?? "";
        urlAvatar = urlAvatarUser;
    }

    factory User.fromApi(Map<String, dynamic> json) {
        return User(
            idUser: json['id'],
            nameUser: json['name'],
            emailUser: json['email'],
            urlAvatarUser: json['imageUrl'] );
    }
}