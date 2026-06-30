class ChildListItem {
 final String id;
 final String name;
 final int age;
 final String gender;
 final String status;
 final String? externalSubjectId;
 final String? enrolmentCenter;

 ChildListItem({
 required this.id,
 required this.name,
 required this.age,
 required this.gender,
 required this.status,
 this.externalSubjectId,
 this.enrolmentCenter,
 });

 factory ChildListItem.fromJson(Map<String, dynamic> json) {
 return ChildListItem(
 id: json['id'] as String,
 name: json['name'] as String? ?? 'Unknown',
 age: json['age'] as int? ?? 0,
 gender: json['gender'] as String? ?? '',
 status: json['status'] as String? ?? '',
 externalSubjectId: json['externalSubjectId'] as String?,
 enrolmentCenter: json['enrolmentCenter'] as String?,
 );
 }
}