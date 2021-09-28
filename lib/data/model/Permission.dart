class UserPermission {
  late User user;
  late List<Permissions> premissions;
  late List<String> roles;

  UserPermission(
      {required this.user, required this.premissions, required this.roles});

  UserPermission.fromJson(Map<String, dynamic> json) {
    user = (json['user'] != null ? new User.fromJson(json['user']) : null)!;
    if (json['premissions'] != null) {
      premissions = <Permissions>[];
      json['premissions'].forEach((v) {
        premissions.add(new Permissions.fromJson(v));
      });
    }
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.premissions != null) {
      data['premissions'] = this.premissions.map((v) => v.toJson()).toList();
    }
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
  late String phone;
  late Null createdBy;
  late String createdAt;
  late String updatedAt;
  late int companyid;
  late int cityid;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    active = json['active'];
    phone = json['phone'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyid = json['company_id'];
    cityid = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['active'] = this.active;
    data['phone'] = this.phone;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['company_id'] = this.companyid;
    data['city_id'] = this.cityid;
    return data;
  }
}

class Permissions {
  late int id;
  late String name;
  late String guardName;
  late Null createdAt;
  late Null updatedAt;
  late Pivot pivot;

  Permissions.fromJson(Map<String, dynamic> json) {
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
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
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
