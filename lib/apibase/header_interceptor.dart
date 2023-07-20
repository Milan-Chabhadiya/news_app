import 'package:dio/dio.dart';

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers.putIfAbsent(
      'x-api-key',
      () => '2K6KtQxMELe2QVXUUUc51_ZuFQuDFGz8J1ktL9L35oM',
    );

    // 2K6KtQxMELe2QVXUUUc51_ZuFQuDFGz8J1ktL9L35oM

    // doXDPgUn6Eq8DbcwoGA3eifrWpuf--GJeSmy6Hqinr0

    // eJhFb1aurRijnochWGemDqLwPtQbQrQ5PhrgX8_F5lY

    // dDLXfb4Yw-PnS68uZKDrsjefw1t30XIC8rO8AY3ArwM

    handler.next(options);
  }
}
