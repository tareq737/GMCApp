import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/HR/models/attendance_absent_report_model.dart';

class HrServices {
  final ApiClient _apiClient;
  final AuthInteractor _authInteractor;

  HrServices(
      {required ApiClient apiClient, required AuthInteractor authInteractor})
      : _apiClient = apiClient,
        _authInteractor = authInteractor;

  Future<Either<Failure, UserEntity>> getCredentials() async {
    var user = await _authInteractor.getSession();
    if (user is UserEntity) {
      return right(user);
    } else {
      return left(Failure(message: 'no user'));
    }
  }

  Future<AttendanceAbsentReportModel?> getAttendanceAbsentReport({
    required String date,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getOneMap(
          user: success,
          endPoint: 'attendance_absent_report',
          queryParams: {
            "date": date,
          },
        );
        if (response == null) {
          return null;
        }
        return AttendanceAbsentReportModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }
}
