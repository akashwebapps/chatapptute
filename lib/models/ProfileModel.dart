class ProfileModel {
  String? imageLink;
  String name;
  String? email;
  String? uid;

  String aboutYou;
  String gender;

  ProfileModel({
    this.imageLink = "",
    this.name = "",
    required this.email,
    required this.uid,
    this.aboutYou = "",
    this.gender = "",
  });

  ProfileModel.updateDate({
    required this.name,
    required this.aboutYou,
    required this.gender,
  });

  Map<String, dynamic> toCreateMap() {
    return {
      'imageLink': imageLink,
      'email': email,
      'uid': uid,
      'name': name,
      'aboutYou': aboutYou,
      'gender': gender,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'name': name,
      'aboutYou': aboutYou,
      'gender': gender,
    };
  }
}
