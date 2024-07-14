class TaskEntity {
  final int id;
  final String name;
  final String url;
  bool status;

  TaskEntity(this.id, this.name, this.url, this.status);

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      json['id'],
      json['name'],
      json['url'],
      json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'status': status,
    };
  }
}
