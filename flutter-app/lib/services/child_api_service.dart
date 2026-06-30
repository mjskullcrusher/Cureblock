import 'package:dio/dio.dart';
import '../models/child_list_item.dart';
import '../models/child_detail.dart';

class ChildApiService {
 // Mac running Flutter on desktop/web/iOS simulator -> localhost works.
 // Android emulator -> use http://10.0.2.2:8080
 static const String baseUrl = 'http://localhost:8080';

 final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

 Future<List<ChildListItem>> getChildren({int page = 0, int size = 500}) async {
 final response = await _dio.get(
 '/api/v1/children',
 queryParameters: {'page': page, 'size': size},
 );
 final content = response.data['content'] as List<dynamic>;
 return content
 .map((e) => ChildListItem.fromJson(e as Map<String, dynamic>))
 .toList();
 }
 Future<ChildDetail> getChild(String id) async {
 final response = await _dio.get('/api/v1/children/$id');
 return ChildDetail.fromJson(response.data as Map<String, dynamic>);
 }
 Future<String> enrolChild(Map<String, dynamic> body) async {
 final response = await _dio.post('/api/v1/enrolment', data: body);
 return response.data['childId'] as String;
 }
}