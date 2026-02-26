class ContactResponse {
  final String status;
  final String message;
  final ContactData data;

  ContactResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: ContactData.fromJson(json['data'] ?? {}),
    );
  }
}

class ContactData {
  final List<Category> categories;
  final List<Contact> contacts;

  ContactData({required this.categories, required this.contacts});

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e))
              .toList() ??
          [],
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((e) => Contact.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}

class Contact {
  final String id;
  final bool isEmpty;
  final String? name;
  final String? phone;
  final String? categoryId;
  final String? avatarUrl;
  final String? subtitle;
  final String? status;
  final DateTime? createdAt;

  Contact({
    required this.id,
    required this.isEmpty,
    this.name,
    this.phone,
    this.categoryId,
    this.avatarUrl,
    this.subtitle,
    this.status,
    this.createdAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? '',
      isEmpty: json['isEmpty'] ?? true,
      name: json['name'],
      phone: json['phone'],
      categoryId: json['categoryId'],
      avatarUrl: json['avatarUrl'],
      subtitle: json['subtitle'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
