


class Product{
  int key=DateTime.now().microsecondsSinceEpoch;
  String Name="";
  String description="";
  int Price=0;
  int Total_Sells=0;
  String Type="";
  String imglink="";

  Product({required this.Name,required this.description,required this.Price,required this.Type,required this.imglink});

  Map<String,dynamic> toMap()=>{
    "key":this.key,
    "Name":this.Name,
    "description":this.description,
    "Price":this.Price,
    "Total_Sells":this.Total_Sells,
    "Type":this.Type,
    "imglink":this.imglink,
  };
}