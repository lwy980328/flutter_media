
class BaseEntity<T>{
  int customCode;
  int statusCode;
  String msg;
  T obj;

  BaseEntity(this.customCode,this.statusCode, this.msg, this.obj);
}