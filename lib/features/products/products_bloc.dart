import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../core/models/product.dart';
import '../../core/services/cache_service.dart'; // offline cache
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final Dio _dio = Dio()..options.baseUrl = 'https://dummyjson.com';
  int _skip = 0;
  bool _reachEnd = false;

  ProductsBloc() : super(ProductsInitial()) {
    on<FetchProducts>(_onFetch);
    on<SearchProducts>(_onSearch);
    on<RefreshProducts>(_onRefresh);
  }

  /* -------------------- pagination -------------------- */
  Future<void> _onFetch(FetchProducts event, Emitter<ProductsState> emit) async {
    if (_reachEnd) return;
    try {
      final url = 'https://dummyjson.com/products?limit=10&skip=$_skip';
      final res = await _dio.get(url);
      final list = (res.data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
      _reachEnd = list.length < 10;
      _skip += list.length;
      CacheService.saveProducts(list); // SAVE to Hive
      emit(ProductsLoaded([...state.products, ...list], reachEnd: _reachEnd));
    } catch (e) {
      // OFFLINE → read last cached list
      final cached = CacheService.getProducts();
      emit(ProductsLoaded(cached, reachEnd: true));
    }
  }

  /* -------------------- search -------------------- */
  Future<void> _onSearch(SearchProducts event, Emitter<ProductsState> emit) async {
    try {
      final url = 'https://dummyjson.com/products/search?q=${event.query}&limit=20';
      final res = await _dio.get(url);
      final list = (res.data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
      emit(ProductsLoaded(list, reachEnd: true));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  /* -------------------- pull-to-refresh -------------------- */
  Future<void> _onRefresh(RefreshProducts event, Emitter<ProductsState> emit) async {
    _skip = 0;
    _reachEnd = false;
    try {
      await _onFetch(FetchProducts(), emit);
    } catch (_) {
      // offline: keep old list, stop pagination
      emit(ProductsLoaded(state.products, reachEnd: true));
    }
  }
}