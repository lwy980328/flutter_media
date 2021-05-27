class UserBean {
  String userPosition;
  String photo;
  int userGender;
  String userDepartment;
  String userName;

  UserBean(
      {this.userPosition,
        this.photo,
        this.userGender,
        this.userDepartment,
        this.userName});

  UserBean.fromJson(Map<String, dynamic> json) {
    userPosition = json['userPosition'];
    photo = json['photo'];
    userGender = json['userGender'];
    userDepartment = json['userDepartment'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userPosition'] = this.userPosition;
    data['photo'] = this.photo;
    data['userGender'] = this.userGender;
    data['userDepartment'] = this.userDepartment;
    data['userName'] = this.userName;
    return data;
  }
}