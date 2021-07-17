class video0bean{
  int id;
  String keywords;
  String title;
  String description;
  String videoUrl;
  String bgmUrl;
  int filter;

  video0bean(this.id,this.videoUrl,this.keywords,this.filter,{this.title,this.description,this.bgmUrl});
}