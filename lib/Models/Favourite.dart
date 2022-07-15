

class Favourite{
  String userkey="";
  int productkey=0;

  Favourite({required this.userkey,required this.productkey});

  Map<String,dynamic> toMap()=>{
    "userkey":this.userkey,
    "productkey":this.productkey,
  };
}