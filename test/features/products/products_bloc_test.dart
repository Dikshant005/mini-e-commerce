// test/features/products/products_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:my_shop_simple/features/products/products_bloc.dart';
import 'package:my_shop_simple/features/products/products_event.dart';
import 'package:my_shop_simple/features/products/products_state.dart';

void main() {
  group('ProductsBloc', () {
    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsInitial, ProductsLoading, ProductsLoaded] when FetchProducts succeeds',
      build: () => ProductsBloc(),
      act: (bloc) => bloc.add(FetchProducts()),
      expect: () => [
        ProductsInitial(),
        ProductsLoading(),
        isA<ProductsLoaded>(), // network result
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [ProductsInitial, ProductsLoading, ProductsError] when network fails',
      build: () => ProductsBloc(),
      seed: () => ProductsInitial(),
      act: (bloc) => bloc.add(FetchProducts()),
      expect: () => [
        ProductsLoading(),
        isA<ProductsError>(),
      ],
    );
  });
}