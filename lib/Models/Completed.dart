

class Completed{
  String userkey="";
  int productkey=0;
  bool reviewed=false;

  Completed({required this.userkey,required this.productkey});

  Map<String,dynamic> toMap()=>{
    "userkey":this.userkey,
    "productkey":this.productkey,
    "reviewed":this.reviewed
  };
}