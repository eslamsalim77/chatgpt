extension NonNullableDouble on double?{
  double notNull(){
    if(this == null){
      return 0;
    }else{
      return this!;
    }
  }
}