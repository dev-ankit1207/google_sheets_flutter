class SaveData {
  String? age;
  String? createdAt;
  String? lastName;
  String? firstName;
  String? gender;
  String? updatedAt;
  String? userName;

  SaveData({this.age, this.createdAt, this.firstName, this.gender, this.lastName, this.updatedAt, this.userName});

  factory SaveData.fromJson(Map<String, dynamic> json) {
    return SaveData(
      age: json['age'],
      createdAt: json['createdAt'],
      firstName: json['firstName'],
      gender: json['gender'],
      lastName: json['lastName'],
      updatedAt: json['updatedAt'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['createdAt'] = this.createdAt;
    data['firstName'] = this.firstName;
    data['gender'] = this.gender;
    data['lastName'] = this.lastName;
    data['updatedAt'] = this.updatedAt;
    data['userName'] = this.userName;
    return data;
  }

  factory SaveData.fromSheets(List<String> input) => SaveData(firstName: input[0], lastName: input[1], userName: input[2], age: input[3], gender: input[4]);

  String toParams() => "?age=$age?createdAt=$createdAt?firstName=$firstName?gender=$gender?lastName=$lastName?updatedAt=$updatedAt?userName=$userName";
}
