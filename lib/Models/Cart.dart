


class Cart{
  String userkey="";
  int productkey=0;
  int quantity=0;
  int Price=0;

  Cart({required this.Price,required this.userkey,required this.productkey,required this.quantity});

  Map<String,dynamic> toMap()=>{
    "userkey":this.userkey,
    "productkey":this.productkey,
    "quantity":this.quantity,
    "Price":this.Price
  };
}