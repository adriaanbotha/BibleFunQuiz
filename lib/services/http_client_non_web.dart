import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io_client;

http.Client createClient() {
  final ioClient = HttpClient();
  ioClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return io_client.IOClient(ioClient);
}
