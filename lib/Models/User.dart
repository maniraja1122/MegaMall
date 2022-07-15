


class Users{
  String key="";
  String Name="";
  String Email="";
  String Password="";
  Users({required this.key,required this.Name,required this.Email,required this.Password});
  Map<String,dynamic> toMap()=>{
    "key":this.key,
    "Name":this.Name,
    "Email":this.Email,
    "Password":this.Password
  };
}