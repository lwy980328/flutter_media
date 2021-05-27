class InfoListBean {
  int totalNum;
  String authorName;
  int publicNewsId;
  int time;
  String title;
  int type;
  int authorId;
  String content;

  InfoListBean(
      {this.totalNum,
        this.authorName,
        this.publicNewsId,
        this.time,
        this.title,
        this.type,
        this.authorId,
        this.content});

  InfoListBean.fromJson(Map<String, dynamic> json) {
    totalNum = json['totalNum'];
    authorName = json['authorName'];
    publicNewsId = json['publicNewsId'];
    time = json['time'];
    title = json['title'];
    type = json['type'];
    authorId = json['authorId'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalNum'] = this.totalNum;
    data['authorName'] = this.authorName;
    data['publicNewsId'] = this.publicNewsId;
    data['time'] = this.time;
    data['title'] = this.title;
    data['type'] = this.type;
    data['authorId'] = this.authorId;
    data['content'] = this.content;
    return data;
  }
}