import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'حدث خطأ في الخادم',
    super.code,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'حدث خطأ في التخزين المحلي',
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'لا يوجد اتصال بالإنترنت',
    super.code,
  });
}

class LocationFailure extends Failure {
  const LocationFailure({
    super.message = 'حدث خطأ في تحديد الموقع',
    super.code,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'تم رفض إذن الوصول',
    super.code,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'لم يتم العثور على البيانات',
    super.code,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'حدث خطأ غير متوقع',
    super.code,
  });
}
