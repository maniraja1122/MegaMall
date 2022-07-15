


class Review{
  String userkey="";
  int productkey=0;
  double Rating=0;
  String comment="";
  int time=DateTime.now().microsecondsSinceEpoch;

  Review({required this.userkey,required this.productkey,required this.Rating,required this.comment});

  Map<String,dynamic> toMap()=>{
    "userkey":this.userkey,
    "productkey":this.productkey,
    "Rating":this.Rating,
    "comment":this.comment,
    "time":this.time,
  };
}