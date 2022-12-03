class Creator {
  String name = "";
  String email = "";

  Creator(this.name, this.email);

  Creator.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;

    return data;
  }
}
