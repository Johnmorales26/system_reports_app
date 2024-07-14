class TaskEntity {
  final int id;
  final String name;
  final String url;
  String image; // Cambiado a String para contener una única imagen
  bool status;

  TaskEntity(this.id, this.name, this.url, this.status, {this.image = ''});

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      json['id'],
      json['name'],
      json['url'],
      json['status'],
      image: json['image'] ?? '', // Asigna el valor de 'image' desde el JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'status': status,
      'image': image, // Agrega el campo 'image' al JSON
    };
  }
}
