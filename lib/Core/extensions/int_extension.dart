extension NonNullableInt on int?{
  int notNull(){
    if(this == null){
      return 0;
    }else{
      return this!;
    }
  }
}