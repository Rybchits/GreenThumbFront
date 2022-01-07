class Plant {
  int _id = 0;
  String _name = "";
  String _group = "";
  String? _urlImage = "";
  DateTime? _dateOfNextWatering = DateTime.now();
  int? _wateringPeriodDays = 0;

  int get id => _id;
  String get name => _name;
  String get group => _group;
  String? get urlImage => _urlImage;
  DateTime? get dateOfNextWatering => _dateOfNextWatering;
  int? get wateringPeriodDays => _wateringPeriodDays;

  void waterThisPlant(){
    _dateOfNextWatering = DateTime.now().add(Duration(days: wateringPeriodDays ?? 0));
  }

  Plant({ required id, required name, required group, wateringPeriodDays, dateOfNextWatering, urlImage }) {
    _id = id;
    _name = name;
    _group = group;
    _wateringPeriodDays = wateringPeriodDays;
    _dateOfNextWatering = dateOfNextWatering;
    _urlImage = urlImage;
  }
}