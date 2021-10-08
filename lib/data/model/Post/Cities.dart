class Cities {
  late data datas;

  Cities({required this.datas});

  Cities.fromJson(Map<String, dynamic> json) {
    datas = (json['data'] != null ? new data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.datas.toJson();
    return data;
  }
}

class data {
  late List<list> lists;

  data({required this.lists});

  data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      lists = <list>[];
      json['list'].forEach((v) {
        lists.add(new list.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list'] = this.lists.map((v) => v.toJson()).toList();
    return data;
  }
}

class list {
  late int id;
  late String name;

  list({required this.id, required this.name});

  list.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
