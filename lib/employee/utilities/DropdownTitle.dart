class DropdownTitle {
  String _Title = "";
  int _index = 0;
  DropdownTitle(String title, int ind) {
    _Title = title;
    _index = ind;
  }
  String getTitle() {
    return _Title;
  }

  bool operator ==(t) =>
      t is DropdownTitle && t._Title == _Title && t._index == _index;
}
