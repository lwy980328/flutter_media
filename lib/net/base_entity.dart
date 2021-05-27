
class BaseEntity<T>{
//  int customCode;
  int statusCode;
  String msg;
  T data;

  BaseEntity(this.statusCode, this.msg, this.data);
}