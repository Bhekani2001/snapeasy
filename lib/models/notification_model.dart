class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool read;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.read = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? date,
    bool? read,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'date': date.toIso8601String(),
    'read': read,
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      date: DateTime.parse(json['date'] as String),
      read: json['read'] as bool? ?? false,
    );
  }
}
