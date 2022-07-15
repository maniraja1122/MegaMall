


class Cart{
  String userkey="";
  int productkey=0;
  int quantity=0;

  Cart({required this.userkey,required this.productkey,required this.quantity});

  Map<String,dynamic> toMap()=>{
    "userkey":this.userkey,
    "productkey":this.productkey,
    "quantity":this.quantity
  };
}