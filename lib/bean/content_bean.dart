class ContentBean {
  int smId;
  String image;
  List<String> modulesName;
  String scriptSubTitle;
  int scriptNowId;
  String scriptMainTitle;
  String abstractContent;
  int creatorId;
  String creatorName;
  int spId;
  int scriptOrigintId;
  List<String> moduleIds;
  int totalNum;
  int scriptStatusId;
  String scriptStatusImage;
  String scriptStatusName;
  List<ButtonInfo> buttonInfo;
  int time;

  ContentBean(
      {this.smId,
        this.image,
        this.modulesName,
        this.scriptSubTitle,
        this.scriptNowId,
        this.scriptMainTitle,
        this.abstractContent,
        this.creatorId,
        this.creatorName,
        this.spId,
        this.scriptOrigintId,
        this.moduleIds,
        this.totalNum,
        this.scriptStatusId,
        this.scriptStatusImage,
        this.scriptStatusName,
        this.buttonInfo,
        this.time});

  ContentBean.fromJson(Map<String, dynamic> json) {
    smId = json['smId'];
    image = json['image'];
    modulesName = json['modulesName'].cast<String>();
    scriptSubTitle = json['scriptSubTitle'];
    scriptNowId = json['scriptNowId'];
    scriptMainTitle = json['scriptMainTitle'];
    abstractContent = json['abstractContent'];
    creatorId = json['creatorId'];
    creatorName = json['creatorName'];
    spId = json['spId'];
    scriptOrigintId = json['scriptOrigintId'];
    moduleIds = json['moduleIds'].cast<String>();
    totalNum = json['totalNum'];
    scriptStatusId = json['scriptStatusId'];
    scriptStatusImage = json['scriptStatusImage'];
    scriptStatusName = json['scriptStatusName'];
    if (json['buttonInfo'] != null) {
      buttonInfo = new List<ButtonInfo>();
      json['buttonInfo'].forEach((v) {
        buttonInfo.add(new ButtonInfo.fromJson(v));
      });
    }
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['smId'] = this.smId;
    data['image'] = this.image;
    data['modulesName'] = this.modulesName;
    data['scriptSubTitle'] = this.scriptSubTitle;
    data['scriptNowId'] = this.scriptNowId;
    data['scriptMainTitle'] = this.scriptMainTitle;
    data['abstractContent'] = this.abstractContent;
    data['creatorId'] = this.creatorId;
    data['creatorName'] = this.creatorName;
    data['spId'] = this.spId;
    data['scriptOrigintId'] = this.scriptOrigintId;
    data['moduleIds'] = this.moduleIds;
    data['totalNum'] = this.totalNum;
    data['scriptStatusId'] = this.scriptStatusId;
    data['scriptStatusImage'] = this.scriptStatusImage;
    data['scriptStatusName'] = this.scriptStatusName;
    if (this.buttonInfo != null) {
      data['buttonInfo'] = this.buttonInfo.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    return data;
  }
}

class ButtonInfo {
  int buttonId;
  String buttonName;

  ButtonInfo({this.buttonId, this.buttonName});

  ButtonInfo.fromJson(Map<String, dynamic> json) {
    buttonId = json['buttonId'];
    buttonName = json['buttonName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buttonId'] = this.buttonId;
    data['buttonName'] = this.buttonName;
    return data;
  }
}