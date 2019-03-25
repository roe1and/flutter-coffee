class Units {
  int id;
  String temperature;
  String weight;
 
  Units(this.id, this.temperature, this.weight);
 
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'temperature': temperature,
      'weight': weight,
    };
    return map;
  }
 
  Units.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    temperature = map['temperature'];
    weight = map['weight'];
  }
}