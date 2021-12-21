import 'package:flutter/material.dart';

class SpaceFiltersComponent extends StatefulWidget {
  final void Function(String searchString, bool spacesBelong) refreshListByFilters;
  const SpaceFiltersComponent({Key? key, required this.refreshListByFilters}) : super(key: key);

  @override
  _SpaceFiltersState createState() => _SpaceFiltersState();
}

class _SpaceFiltersState extends State<SpaceFiltersComponent>{
  final _searchController = TextEditingController();
  bool onlyOwnSpace = false;

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        widget.refreshListByFilters(_searchController.text, onlyOwnSpace);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Метод для обработки
  void setSpacesBelong(bool? value) {
    setState(() {
      onlyOwnSpace = value ?? false;
      widget.refreshListByFilters(_searchController.text, onlyOwnSpace);
    });
  }

  @override
  Widget build(BuildContext context) {

    final comboboxSpacesBelong = InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<bool>(
          value: onlyOwnSpace,
          isDense: true,
          isExpanded: true,
          items: const [
            DropdownMenuItem(child: Text("Все"), value: false),
            DropdownMenuItem(child: Text("Личные"), value: true),
          ],
          onChanged: setSpacesBelong
        ),
      ),
    );

    final searchField = TextFormField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Поиск...',
        hintStyle: TextStyle(
          color: Color(0xffA9B2AA),
          fontSize: 14,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
          child: Icon(Icons.search, size: 20, color: Color(0xffA9B2AA)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffA9B2AA)),
        ),
        contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 0.0),
      ),
      cursorColor: Theme.of(context).primaryColorDark,
    );

    return Row(
      children: <Widget>[
        Expanded(child: searchField, flex: 8),
        const Expanded(child: SizedBox(width: 20), flex: 1),
        Expanded(child: SizedBox(child: comboboxSpacesBelong, height: 35), flex: 4)
      ],
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

}