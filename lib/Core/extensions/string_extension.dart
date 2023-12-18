extension NonNullable on String?{
  String notNull(){
    if(this == null){
      return "";
    }else{
      return this!;
    }
  }

  int toInt(){
    if(this == null){
      return int.parse("0");
    }else{
      return int.parse(this!);
    }
  }

}