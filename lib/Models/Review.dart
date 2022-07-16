


class Review{
  String userkey="";
  int productkey=0;
  double Rating=0;

  Review({required this.userkey,required this.productkey,required this.Rating});

  Map<String,dynamic> toMap()=>{
    "userkey":this.userkey,
    "productkey":this.productkey,
    "Rating":this.Rating
  };
}