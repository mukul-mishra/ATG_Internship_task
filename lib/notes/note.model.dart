class NoteModel {
  String _title;
  String _description;
  String _time;
  NoteModel(this._title, this._description, this._time);

  String get description => _description;

  String get title => _title;

  String get time => _time;
}
