import 'package:dio/dio.dart';

import 'api_gateway_rsocket_client.dart';

//todo is this really a right pattern? or singleton is better?!
class ClientHolder {
  static final ApiGatewayRSocketClient client = ApiGatewayRSocketClient();
  static final Dio apiGatewayHttpClient = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.188:9531',
    // connectTimeout: 5000,
    // receiveTimeout: 3000,
  ));
}