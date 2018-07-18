

class Date  {
  int _id;
  int _date;

  Date(this._id, this._date);

  int get date => _date;

  int get id => _id;

  Date.map(dynamic obj){
    this._id = obj['id'];
    this._date = obj['date'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['date'] = date;
    return map;
  }

  Date.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._date = map['date'];
  }

}