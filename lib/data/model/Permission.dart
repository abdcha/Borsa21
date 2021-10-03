class UserPermission {
  late User user;
  late List<Permissions> permission;
  late List<String> roles;

  UserPermission(
      {required this.user, required this.permission, required this.roles});

  UserPermission.fromJson(Map<String, dynamic> json) {
    user = (json['user'] != null ? new User.fromJson(json['user']) : null)!;
    if (json['permissions'] != null) {
      permission = <Permissions>[];
      json['permissions'].forEach((v) {
        permission.add(new Permissions.fromJson(v));
      });
    }
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.permission != null) {
      data['permissions'] = this.permission.map((v) => v.toJson()).toList();
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
  late EndSubscription? endSubscription;

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
    if (json['end_subscription'] != null) {
      endSubscription = new EndSubscription.fromJson(json['end_subscription']);
    } else {
      endSubscription = null;
    }
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
    if (this.endSubscription != null) {
      data['end_subscription'] = this.endSubscription!.toJson();
    }
    return data;
  }
}

class EndSubscription {
  late String endAt;
  late int id;
  late int userId;

  EndSubscription(
      {required this.endAt, required this.id, required this.userId});

  EndSubscription.fromJson(Map<String, dynamic> json) {
    endAt = json['end_at'];
    id = json['id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end_at'] = this.endAt;
    data['id'] = this.id;
    data['user_id'] = this.userId;
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
