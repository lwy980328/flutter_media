class LoginBean {
  int roleId;
  String roleName;
  int userLogId;
  int userType;
  String userName;
  int userId;

  LoginBean(
      {this.roleId,
        this.roleName,
        this.userLogId,
        this.userType,
        this.userName,
        this.userId});

  LoginBean.fromJson(Map<String, dynamic> json) {
    roleId = json['roleId'];
    roleName = json['roleName'];
    userLogId = json['userLogId'];
    userType = json['userType'];
    userName = json['userName'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleId'] = this.roleId;
    data['roleName'] = this.roleName;
    data['userLogId'] = this.userLogId;
    data['userType'] = this.userType;
    data['userName'] = this.userName;
    data['userId'] = this.userId;
    return data;
  }
}