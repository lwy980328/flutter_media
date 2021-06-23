import 'dart:io';


class videoFileList{
  List<String> allVideo;
  // List<String> allVideoPath;
  int length;

  videoFileList(int length){
    this.allVideo = new List();
    // this.allVideoPath = new List();
    this.length = length;
  }

   removeLastList(){
    allVideo.removeLast();
  }

  removeFromList(int index){
    allVideo.removeAt(index);
  }

   clearList(){
    allVideo.clear();
  }

  bool fullList(){
    if(allVideo.length==length){
      return true;
    }
    return false;
  }

  addToList(File f){
    if(!fullList()){
      allVideo.add(f.path);
    }
  }

  int lengthIs(){
    return allVideo.length;
  }

  printList(){
    for(int i=0;i<allVideo.length;i++){
      print(allVideo[i]);
    }

  }

}