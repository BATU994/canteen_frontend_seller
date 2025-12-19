// import 'package:dio/dio.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:shoply/src/core/exceptions/domain_exception.dart';

// abstract interface class RestClient {
//   void setBaseUrl({
//     required String ipAddress,
//     int? port,
//   });

//   // Get:-----------------------------------------------------------------------
//   Future<Either<DomainException, Response>> get(
//     String url, {
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//     ProgressCallback? onReceiveProgress,
//   });

//   // Post:----------------------------------------------------------------------
//   Future<Either<DomainException, Response>> post(
//     String uri, {
//     data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });

//   // Put:-----------------------------------------------------------------------
//   Future<Either<DomainException, Response>> put(
//     String uri, {
//     data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });

//   // Delete:--------------------------------------------------------------------
//   Future<Either<DomainException, Response>> delete(
//     String uri, {
//     data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//     ProgressCallback? onSendProgress,
//     ProgressCallback? onReceiveProgress,
//   });

//   // Patch:---------------------------------------------------------------------
//   Future<Either<DomainException, Response>> patch(
//     String uri, {
//     Object? data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
//   });
// }
