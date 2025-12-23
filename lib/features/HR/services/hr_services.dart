import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/exceptions.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/features/HR/models/attendance_absent_report_model.dart';
import 'package:gmcappclean/features/HR/models/attendance_logs_model.dart';
import 'package:gmcappclean/features/HR/models/brief_employee_model.dart';
import 'package:gmcappclean/features/HR/models/employee_model.dart';
import 'package:gmcappclean/features/HR/models/overtime_model.dart';
import 'package:gmcappclean/features/HR/models/workleaves_model.dart';

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

  Future<EmployeeModel?> getOneEmployeeByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'hr/employees',
          id: id,
        );
        return EmployeeModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<EmployeeModel?> addEmployee(EmployeeModel employeeModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'hr/employees',
          data: employeeModel.toJson(),
        );
        return EmployeeModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<EmployeeModel?> updateEmployee(
      int id, EmployeeModel employeeModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'hr/employees',
          data: employeeModel.toJson(),
          id: id,
        );
        return EmployeeModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<PageintedResult?> searchEmployee({
    String? search,
    String? department,
    bool? is_working,
    required int page,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        // Build query parameters dynamically
        final Map<String, dynamic> queryParams = {
          'page_size': 40,
          'page': page,
        };

        if (search != null && search.isNotEmpty) queryParams['search'] = search;
        if (department != null && department.isNotEmpty) {
          queryParams['department'] = department;
        }
        if (is_working != null) queryParams['is_working'] = is_working;

        // Call API
        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'hr/employeebrief',
          queryParams: queryParams,
        );

        // Map results to models
        final models = paginated.results
            .map((item) => BriefEmployeeModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<Either<Uint8List, Failure>> exportExcelEmployees(
      {required bool? isWorking}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold(
        (failure) {
          return right(Failure(message: 'No tokens found.'));
        },
        (success) async {
          try {
            final Map<String, dynamic> queryParams = {
              'is_working': isWorking,
            };
            final response = await _apiClient.downloadFile(
              user: success,
              endPoint: 'hr/export_employees',
              queryParameters: queryParams,
            );
            return left(response);
          } catch (e) {
            print('Error exporting Excel tasks: $e');
            return right(
                Failure(message: 'Failed to export Excel: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Caught error in exportExcelTasks service: $e');
      return right(Failure(
          message: 'Unexpected error during Excel export: ${e.toString()}'));
    }
  }

  Future<List<Map<String, dynamic>>?> getDepartmentEmployees() async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.get(
          user: success,
          endPoint: 'hr/department_employees',
        );
        return List.generate(response.length, (index) {
          return (response[index]);
        });
      });
    } catch (e) {
      print('exception caught');
      return null;
    }
  }

  Future<PageintedResult?> getWorkLeaves({
    required int page,
    required int? progress,
    required int? employee_id,
    required String? date1,
    required String? date2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        // Build query parameters dynamically
        final Map<String, dynamic> queryParams = {
          'page_size': 40,
          'page': page,
        };

        if (progress != null) queryParams['progress'] = progress;
        if (employee_id != null) queryParams['employee_id'] = employee_id;
        if (date1 != null && date1.isNotEmpty) queryParams['date1'] = date1;
        if (date2 != null && date2.isNotEmpty) queryParams['date2'] = date2;

        // Call API
        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'hr/workleaves',
          queryParams: queryParams,
        );

        // Map results to models
        final models = paginated.results
            .map((item) => WorkleavesModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<WorkleavesModel?> getOneWorkLeaveByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'hr/workleaves',
          id: id,
        );
        return WorkleavesModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<WorkleavesModel?> addWorkLeave(WorkleavesModel workleavesModel) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        throw const ServerException('Failed to load credentials');
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'hr/workleaves',
          data: workleavesModel.toJson(),
        );
        return WorkleavesModel.fromMap(response);
      });
    } on ServerException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException('$e');
    }
  }

  Future<WorkleavesModel?> updateWorkLeave(
      int id, WorkleavesModel workleavesModel) async {
    final userEntity = await getCredentials();
    return userEntity.fold((failure) {
      return null;
    }, (success) async {
      final response = await _apiClient.updateViaPut(
        user: success,
        endPoint: 'hr/workleaves',
        data: workleavesModel.toJson(),
        id: id,
      );
      return WorkleavesModel.fromMap(response);
    });
  }

  Future<Either<Uint8List, Failure>> getWorkLeavesReportImage(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'hr/work_leaves_report', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<Map<String, dynamic>?> addWorkLeavesReportImage({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "medical_report": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'hr/work_leaves_report/upload',
              formData: formData,
              id: id);
          return (response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteWorkLeavesReportImageByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'hr/work_leaves_report/delete',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  Future<WorkleavesModel> workLeaveApprove({
    required int id,
    required String? approve,
    required String? role,
    required String? notes,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        throw const ServerException('Failed to load credentials');
      }, (success) async {
        final response = await _apiClient.addById(
            userTokens: success,
            endPoint: 'hr/work_leave_approve',
            id: id,
            data: {'approve': approve, 'role': role, 'notes': notes});
        return WorkleavesModel.fromMap(response);
      });
    } on ServerException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException('$e');
    }
  }

  Future<Either<Uint8List, Failure>> exportExcelWorksLeave(
      {required String? date1,
      required String? date2,
      int? employee_id}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold(
        (failure) {
          return right(Failure(message: 'No tokens found.'));
        },
        (success) async {
          try {
            final Map<String, dynamic> queryParams = {
              'date1': date1,
              'date2': date2,
              'employee_id': employee_id,
            };
            final response = await _apiClient.downloadFile(
              user: success,
              endPoint: 'hr/export_workleaves',
              queryParameters: queryParams,
            );
            return left(response);
          } catch (e) {
            print('Error exporting Excel tasks: $e');
            return right(
                Failure(message: 'Failed to export Excel: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Caught error in exportExcelTasks service: $e');
      return right(Failure(
          message: 'Unexpected error during Excel export: ${e.toString()}'));
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
          endPoint: 'hr/attendance_absent_report',
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

  Future<Either<Uint8List, Failure>> getIDImage(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'hr/employee_image/id_image', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<Map<String, dynamic>?> addIDImage({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "id_image": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'hr/employee_image/upload/id_image',
              formData: formData,
              id: id);
          return (response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteIDImageByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success,
            endPoint: 'hr/employee_image/delete/id_image',
            id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  Future<Either<Uint8List, Failure>> getInsImage(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
            user: success,
            endPoint: 'hr/employee_image/ins_reg_image',
            id: id,
          );
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<Map<String, dynamic>?> addInsImage({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "ins_reg_image": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
            userTokens: success,
            endPoint: 'hr/employee_image/upload/ins_reg_image',
            formData: formData,
            id: id,
          );
          return (response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteInsImageByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
          user: success,
          endPoint: 'hr/employee_image/delete/ins_reg_image',
          id: id,
        );
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  Future<Either<Uint8List, Failure>> getEmpImage(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return right(Failure(message: 'no tokens'));
      }, (success) async {
        try {
          final response = await _apiClient.getImage(
              user: success, endPoint: 'hr/employee_image/photo', id: id);
          return left(response);
        } catch (e) {
          return right(Failure(message: e.toString()));
        }
      });
    } catch (e) {
      print('Error catched service');
      return right(Failure(message: e.toString()));
    }
  }

  Future<Map<String, dynamic>?> addEmpImage({
    required int id,
    required File image,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        try {
          FormData formData = FormData.fromMap({
            "photo": await MultipartFile.fromFile(image.path,
                filename: "upload.jpg"),
          });
          final response = await _apiClient.addImageByID(
              userTokens: success,
              endPoint: 'hr/employee_image/upload/photo',
              formData: formData,
              id: id);
          return (response);
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteEmpImageByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return false;
      }, (success) async {
        final response = await _apiClient.delete(
            user: success, endPoint: 'hr/employee_image/delete/photo', id: id);
        return response;
      });
    } catch (e) {
      return false;
    }
  }

  //attendance_logs

  Future fetchAttendance(
    String date,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
            userTokens: success,
            endPoint: 'hr/fetch_attendance',
            data: json.encode({}),
            queryParameters: {'date': date});
        return response;
      });
    } catch (e) {
      return null;
    }
  }

  Future<PageintedResult?> getAttendanceLogs({
    required String date,
    required int page,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        // Build query parameters dynamically
        final Map<String, dynamic> queryParams = {
          'page_size': 100,
          'page': page,
          'date': date
        };

        // Call API
        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'hr/attendance_logs',
          queryParams: queryParams,
        );

        // Map results to models
        final models = paginated.results
            .map((item) => AttendanceLogsModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<AttendanceLogsModel?> getOneAttendanceLogByID(
    int id,
  ) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'hr/attendance_logs',
          id: id,
        );
        return AttendanceLogsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<AttendanceLogsModel?> updateAttendanceLog(
      {required String date,
      required AttendanceLogsModel attendanceLogsModel}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'hr/attendance_logs',
          data: attendanceLogsModel.toJson(),
          queryParameters: {'date': date},
        );
        return AttendanceLogsModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  //overtime

  Future<PageintedResult?> getOvertimes({
    required int page,
    required bool? approve,
    required int? employee_id,
    required String? date1,
    required String? date2,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        // Build query parameters dynamically
        final Map<String, dynamic> queryParams = {
          'page_size': 40,
          'page': page,
        };

        if (approve != null) queryParams['approve'] = approve;
        if (employee_id != null) queryParams['employee_id'] = employee_id;
        if (date1 != null && date1.isNotEmpty) queryParams['date1'] = date1;
        if (date2 != null && date2.isNotEmpty) queryParams['date2'] = date2;

        final paginated = await _apiClient.getPageinatedWithCount(
          user: success,
          endPoint: 'hr/overtime',
          queryParams: queryParams,
        );

        // Map results to models
        final models = paginated.results
            .map((item) => OvertimeModel.fromMap(item))
            .toList();

        return PageintedResult(results: models, totalCount: paginated.count);
      });
    } catch (e) {
      print('exception caught: $e');
      return null;
    }
  }

  Future<OvertimeModel?> getOneOvertimeByID({
    required int id,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.getById(
          user: success,
          endPoint: 'hr/overtime',
          id: id,
        );
        return OvertimeModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<OvertimeModel?> addOvertime(
      {required OvertimeModel overtimeModel}) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.add(
          userTokens: success,
          endPoint: 'hr/overtime',
          data: overtimeModel.toJson(),
        );
        return OvertimeModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }

  Future<OvertimeModel?> updateOvertime({
    required int id,
    required OvertimeModel overtimeModel,
  }) async {
    try {
      final userEntity = await getCredentials();
      return userEntity.fold((failure) {
        return null;
      }, (success) async {
        final response = await _apiClient.updateViaPut(
          user: success,
          endPoint: 'hr/overtime',
          data: overtimeModel.toJson(),
          id: id,
        );
        return OvertimeModel.fromMap(response);
      });
    } catch (e) {
      return null;
    }
  }
}
