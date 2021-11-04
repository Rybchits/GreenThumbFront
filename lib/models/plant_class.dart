class Plant {
  String _name = "";
  String _group = "";
  DateTime? _dateOfNextWatering;

  String get name => _name;
  String get group => _group;
  DateTime? get dateOfNextWatering => _dateOfNextWatering;

  Plant(this._name, this._group);
  Plant.fullConstructor(this._name, this._group, this._dateOfNextWatering);
}