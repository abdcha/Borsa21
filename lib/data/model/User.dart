// class User {
//   String status;
//   Data data;

//   User({required this.status, required this.data});

//   User.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     return data;
//   }
// }

class Data {
  late User user;
  late List<Premissions> premissions;
  late List<String> roles;

  Data({required this.user, required this.premissions, required this.roles});

  Data.fromJson(Map<String, dynamic> json) {
    user = (json['user'] != null ? new User.fromJson(json['user']) : null)!;
    if (json['premissions'] != null) {
      premissions = <Premissions>[];
      json['premissions'].forEach((v) {
        premissions.add(new Premissions.fromJson(v));
      });
    }
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user.toJson();
    data['premissions'] = this.premissions.map((v) => v.toJson()).toList();
    data['roles'] = this.roles;
    return data;
  }
}

class User {
  late int id;
  late String name;
  late String email;
  late Null emailVerifiedAt;
  late int active;
  late Null location;
  late String phone;
  late Null createdBy;
  late String createdAt;
  late String updatedAt;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    active = json['active'];
    location = json['location'];
    phone = json['phone'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['active'] = this.active;
    data['location'] = this.location;
    data['phone'] = this.phone;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Premissions {
  late int id;
  late String name;
  late String guardName;
  Null createdAt;
  Null updatedAt;
  late Pivot pivot;

  Premissions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = (json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pivot'] = this.pivot.toJson();
    return data;
  }
}

class Pivot {
  late int roleId;
  late int permissionId;

  Pivot({required this.roleId, required this.permissionId});

  Pivot.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    permissionId = json['permission_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_id'] = this.roleId;
    data['permission_id'] = this.permissionId;
    return data;
  }
}
