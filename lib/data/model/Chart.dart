class Chart {
  late Data data;

  Chart({required this.data});

  Chart.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late List<DataChanges> dataChanges;

  Data({required this.dataChanges});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['dataChanges'] != null) {
      dataChanges = <DataChanges>[];
      json['dataChanges'].forEach((v) {
        dataChanges.add(new DataChanges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dataChanges'] = this.dataChanges.map((v) => v.toJson()).toList();
    return data;
  }
}

class DataChanges {
  late double sell;
  late double buy;
  late String updatedAt;
  late int id;

  DataChanges(
      {required this.sell,
      required this.buy,
      required this.updatedAt,
      required this.id});

  DataChanges.fromJson(Map<String, dynamic> json) {
    sell = json['sell'].toDouble();
    buy = json['buy'].toDouble();
    updatedAt = json['updated_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sell'] = this.sell;
    data['buy'] = this.buy;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
