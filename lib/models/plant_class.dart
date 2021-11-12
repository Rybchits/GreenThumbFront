class Plant {
  int _id = 0;
  String _name = "";
  String _group = "";
  String _urlImage = "";
  DateTime? _dateOfNextWatering;
  int _wateringPeriodDays = 1;

  int get id => _id;
  String get name => _name;
  String get group => _group;
  String get urlImage => _urlImage;
  DateTime? get dateOfNextWatering => _dateOfNextWatering;
  int get wateringPeriodDays => _wateringPeriodDays;

  void waterThisPlant(){
    _dateOfNextWatering = DateTime.now();
  }

  Plant(this._name);
  Plant.fullConstructor(this._id, this._name, this._group, this._wateringPeriodDays,
      this._dateOfNextWatering, this._urlImage);
}