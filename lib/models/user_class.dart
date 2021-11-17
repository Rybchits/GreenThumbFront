class User {
    int _id = 0;
    String? _name = "";
    String? _email = "";
    String? _urlAvatar = "";

    User(this._id, this._name, this._email, this._urlAvatar);

    int get id => _id;
    String? get name => _name;
    String? get email => _email;
    String? get urlAvatar => _urlAvatar;

    factory User.fromJson(Map<String, dynamic> json) {
        return User( json['id'], json['name'], json['email'], json['imageUrl'] );
    }
}