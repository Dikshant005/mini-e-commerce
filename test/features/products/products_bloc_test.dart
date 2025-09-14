import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:my_shop_simple/features/products/products_bloc.dart';
import 'package:my_shop_simple/features/products/products_event.dart';
import 'package:my_shop_simple/features/products/products_state.dart';

import 'mock_dio.dart';

void main() {
  late MockDio mockDio;
  late ProductsBloc bloc;

  setUpAll(() async {
    Hive.init('./test_box');
    await Hive.openBox<String>('products_cache');
    Hive.box<String>('products_cache').put('products', '[]');
  });

  tearDownAll(() async => Hive.close());

  setUp(() {
    mockDio = MockDio();
    bloc = ProductsBloc(dio: mockDio);
  });

  group('ProductsBloc', () {
    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when FetchProducts succeeds',
      build: () => bloc,
      act: (bloc) => bloc.add(FetchProducts()),
      setUp: () {
        when(() => mockDio.get('/products')).thenAnswer(
          (_) async {
            await Future.delayed(Duration(microseconds: 1));
            return Response(
              data: {
                'products': [
                  {
                    'id': 1,
                    'title': 'Test Product',
                    'price': 10.99,
                    'thumbnail': 'url',
                    'category': 'Test',
                    'rating': 4.5,
                    'stock': 100,
                  },
                ],
              },
              requestOptions: RequestOptions(path: '/products'),
            );
          },
        );
      },
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>(),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when network fails (fallback to cache)',
      build: () => bloc,
      act: (bloc) => bloc.add(FetchProducts()),
      setUp: () {
        when(() => mockDio.get('/products')).thenThrow(Exception('API Error'));
      },
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>(), // because bloc emits cached products on error
      ],
    );
  });
}
