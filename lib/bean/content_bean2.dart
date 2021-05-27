class ContentBean2 {
  String scriptContent;
  int smId;
  String image;
  String scriptSubTitle;
  int scriptNowId;
  List<String> moduleName;
  String scriptMainTitle;
  String abstractContent;
  int creatorId;
  String creatorName;
  String contentSourceUrl;
  int spId;
  int scriptOrigintId;
  String scriptTypeName;
  int publishType;
  int totalNum;
  int scriptStatusId;
  String scriptStatusImage;
  int scriptType;
  String scriptStatusName;
  List<ButtonInfo> buttonInfo;
  int time;
  List<int> moduleId;

  ContentBean2(
      {this.scriptContent,
        this.smId,
        this.image,
        this.scriptSubTitle,
        this.scriptNowId,
        this.moduleName,
        this.scriptMainTitle,
        this.abstractContent,
        this.creatorId,
        this.creatorName,
        this.contentSourceUrl,
        this.spId,
        this.scriptOrigintId,
        this.scriptTypeName,
        this.publishType,
        this.totalNum,
        this.scriptStatusId,
        this.scriptStatusImage,
        this.scriptType,
        this.scriptStatusName,
        this.buttonInfo,
        this.time,
        this.moduleId});

  ContentBean2.fromJson(Map<String, dynamic> json) {
    scriptContent = json['scriptContent'];
    smId = json['smId'];
    image = json['image'];
    scriptSubTitle = json['scriptSubTitle'];
    scriptNowId = json['scriptNowId'];
    moduleName = json['moduleName'].cast<String>();
    scriptMainTitle = json['scriptMainTitle'];
    abstractContent = json['abstractContent'];
    creatorId = json['creatorId'];
    creatorName = json['creatorName'];
    contentSourceUrl = json['contentSourceUrl'];
    spId = json['spId'];
    scriptOrigintId = json['scriptOrigintId'];
    scriptTypeName = json['scriptTypeName'];
    publishType = json['publishType'];
    totalNum = json['totalNum'];
    scriptStatusId = json['scriptStatusId'];
    scriptStatusImage = json['scriptStatusImage'];
    scriptType = json['scriptType'];
    scriptStatusName = json['scriptStatusName'];
    if (json['buttonInfo'] != null) {
      buttonInfo = new List<ButtonInfo>();
      json['buttonInfo'].forEach((v) {
        buttonInfo.add(new ButtonInfo.fromJson(v));
      });
    }
    time = json['time'];
    moduleId = json['moduleId'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scriptContent'] = this.scriptContent;
    data['smId'] = this.smId;
    data['image'] = this.image;
    data['scriptSubTitle'] = this.scriptSubTitle;
    data['scriptNowId'] = this.scriptNowId;
    data['moduleName'] = this.moduleName;
    data['scriptMainTitle'] = this.scriptMainTitle;
    data['abstractContent'] = this.abstractContent;
    data['creatorId'] = this.creatorId;
    data['creatorName'] = this.creatorName;
    data['contentSourceUrl'] = this.contentSourceUrl;
    data['spId'] = this.spId;
    data['scriptOrigintId'] = this.scriptOrigintId;
    data['scriptTypeName'] = this.scriptTypeName;
    data['publishType'] = this.publishType;
    data['totalNum'] = this.totalNum;
    data['scriptStatusId'] = this.scriptStatusId;
    data['scriptStatusImage'] = this.scriptStatusImage;
    data['scriptType'] = this.scriptType;
    data['scriptStatusName'] = this.scriptStatusName;
    if (this.buttonInfo != null) {
      data['buttonInfo'] = this.buttonInfo.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    data['moduleId'] = this.moduleId;
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