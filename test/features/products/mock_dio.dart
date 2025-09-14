import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {
  // Provide a real BaseOptions so dio.options does not crash
  @override
  BaseOptions get options => BaseOptions()..baseUrl = 'https://dummyjson.com';
}