class OverviewBean {
  int unReadMessageNum;
  int waitPublishNum;
  int waitCheckNum;
  int returnedNum;
  int waitCheckMenuId;
  int waitPublishMenuId;
  int returnedMenuId;

  OverviewBean(
      {this.unReadMessageNum,
        this.waitPublishNum,
        this.waitCheckNum,
        this.returnedNum,
        this.waitCheckMenuId,
        this.waitPublishMenuId,
        this.returnedMenuId});

  OverviewBean.fromJson(Map<String, dynamic> json) {
    unReadMessageNum = json['unReadMessageNum'];
    waitPublishNum = json['waitPublishNum'];
    waitCheckNum = json['waitCheckNum'];
    returnedNum = json['returnedNum'];
    waitCheckMenuId = json['waitCheckMenuId'];
    waitPublishMenuId = json['waitPublishMenuId'];
    returnedMenuId = json['returnedMenuId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unReadMessageNum'] = this.unReadMessageNum;
    data['waitPublishNum'] = this.waitPublishNum;
    data['waitCheckNum'] = this.waitCheckNum;
    data['returnedNum'] = this.returnedNum;
    data['waitCheckMenuId'] = this.waitCheckMenuId;
    data['waitPublishMenuId'] = this.waitPublishMenuId;
    data['returnedMenuId'] = this.returnedMenuId;
    return data;
  }
}