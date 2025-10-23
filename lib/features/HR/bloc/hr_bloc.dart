import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:gmcappclean/core/error/exceptions.dart';
import 'package:gmcappclean/features/HR/models/employee_model.dart';
import 'package:gmcappclean/features/HR/models/workleaves_model.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:meta/meta.dart';

part 'hr_event.dart';
part 'hr_state.dart';

class HrBloc extends Bloc<HrEvent, HrState> {
  final HrServices _hrServices;
  HrBloc(this._hrServices) : super(HrInitial()) {
    on<HrEvent>((event, emit) {
      emit(HrInitial());
    });
    on<GetOnEemployee>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.getOneEmployeeByID(event.id);
        if (result == null) {
          emit(HRError(errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(HRSuccess(result: result));
        }
      },
    );
    on<AddEmployee>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.addEmployee(event.employeeModel);
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(HRSuccess(result: result));
        }
      },
    );
    on<UpdateEmployee>(
      (event, emit) async {
        emit(HRLoading());
        var result =
            await _hrServices.updateEmployee(event.id, event.employeeModel);
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(HRSuccess(result: result));
        }
      },
    );
    on<SearchEmployee>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.searchEmployee(
          search: event.search,
          page: event.page,
          department: event.department,
          is_working: event.is_working,
        );
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(HRSuccess(result: result));
        }
      },
    );
    on<ExportExcelEmployees>(
      (event, emit) async {
        var result =
            await _hrServices.exportExcelEmployees(isWorking: event.isWorking);
        result.fold(
          (successBytes) {
            emit(ExcelExportedSuccess(result: successBytes));
          },
          (failure) {
            emit(HRError(errorMessage: 'Error'));
          },
        );
      },
    );
    on<GetDepartmentEmployees>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.getDepartmentEmployees();
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(GetDepartmentEmployeesSuccess(result: result));
        }
      },
    );
    on<GetOnWorkLeave>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.getOneWorkLeaveByID(event.id);
        if (result == null) {
          emit(HRError(errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(HRSuccess(result: result));
        }
      },
    );
    on<GetWorkLeaves>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.getWorkLeaves(
          page: event.page,
          progress: event.progress,
          employee_id: event.employee_id,
          date1: event.date1,
          date2: event.date2,
        );
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(HRSuccess(result: result));
        }
      },
    );
    on<AddWorkLeave>((event, emit) async {
      emit(HRLoading());
      try {
        final result = await _hrServices.addWorkLeave(event.workleavesModel);
        emit(HRSuccess(result: result));
      } on ServerException catch (e) {
        emit(HRError(errorMessage: e.message));
      } catch (e) {
        emit(HRError(errorMessage: 'Unexpected error occurred: $e'));
      }
    });
    on<UpdateWorkLeave>((event, emit) async {
      emit(HRLoading());
      try {
        final result =
            await _hrServices.updateWorkLeave(event.id, event.workleavesModel);
        if (result == null) {
          emit(HRError(errorMessage: 'Failed to get user credentials'));
        } else {
          emit(HRSuccess(result: result));
        }
      } on ServerException catch (e) {
        emit(HRError(errorMessage: e.message));
      } catch (e) {
        emit(HRError(errorMessage: 'Unexpected error occurred: $e'));
      }
    });
    on<GetWorkLeavesReportImage>((event, emit) async {
      emit(HRLoading());
      var result = await _hrServices.getWorkLeavesReportImage(event.id);
      result.fold((success) {
        emit(HRSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(HRError(errorMessage: failure.message));
      });
    });
    on<AddWorkLeavesReportImage>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.addWorkLeavesReportImage(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(ImageSavedSuccess(result: result));
        }
      },
    );

    on<DeleteWorkLeavesReportImage>(
      (event, emit) async {
        emit(HRLoading());
        var result =
            await _hrServices.deleteWorkLeavesReportImageByID(event.id);
        if (result == false) {
          emit(HRError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(HRSuccess<bool>(result: true));
        }
      },
    );
    on<WorkLeaveApprove>((event, emit) async {
      emit(HRLoading());
      try {
        final result = await _hrServices.workLeaveApprove(
          id: event.id,
          approve: event.approve,
          role: event.role,
          notes: event.notes,
        );
        emit(HRSuccess(result: result));
      } on ServerException catch (e) {
        emit(HRError(errorMessage: e.message));
      } catch (e) {
        emit(HRError(errorMessage: 'Unexpected error occurred: $e'));
      }
    });
    on<ExportExcelWorksLeaves>(
      (event, emit) async {
        var result = await _hrServices.exportExcelWorksLeave(
            date1: event.date1,
            date2: event.date2,
            employee_id: event.employee_id);
        result.fold(
          (successBytes) {
            emit(ExcelExportedSuccess(result: successBytes));
          },
          (failure) {
            emit(HRError(errorMessage: 'Error'));
          },
        );
      },
    );
    on<GetAttendanceAbsentReport>(
      (event, emit) async {
        emit(HRLoading());
        var result =
            await _hrServices.getAttendanceAbsentReport(date: event.date);
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(HRSuccess(result: result));
        }
      },
    );
    on<GetIDImage>((event, emit) async {
      emit(HRLoading());
      var result = await _hrServices.getIDImage(event.id);
      result.fold((success) {
        emit(HRSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(HRError(errorMessage: failure.message));
      });
    });
    on<AddIDImage>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.addIDImage(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(ImageSavedSuccess(result: result));
        }
      },
    );

    on<DeleteIDImage>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.deleteIDImageByID(event.id);
        if (result == false) {
          emit(HRError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(HRSuccess<bool>(result: true));
        }
      },
    );
    on<GetInsImage>((event, emit) async {
      emit(HRLoading());
      var result = await _hrServices.getInsImage(event.id);
      result.fold((success) {
        emit(HRSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(HRError(errorMessage: failure.message));
      });
    });
    on<AddInsImage>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.addInsImage(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(ImageSavedSuccess(result: result));
        }
      },
    );

    on<DeleteInsImage>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.deleteInsImageByID(event.id);
        if (result == false) {
          emit(HRError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(HRSuccess<bool>(result: true));
        }
      },
    );
    on<GetEmpImage>((event, emit) async {
      emit(HRLoading());
      var result = await _hrServices.getEmpImage(event.id);
      result.fold((success) {
        emit(HRSuccess<Uint8List>(result: success));
      }, (failure) {
        emit(HRError(errorMessage: failure.message));
      });
    });
    on<AddEmpImage>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.addEmpImage(
          id: event.id,
          image: event.image,
        );
        if (result == null) {
          emit(HRError(errorMessage: 'Error'));
        } else {
          emit(ImageSavedSuccess(result: result));
        }
      },
    );

    on<DeleteEmpImage>(
      (event, emit) async {
        emit(HRLoading());
        var result = await _hrServices.deleteEmpImageByID(event.id);
        if (result == false) {
          emit(HRError(
              errorMessage:
                  'Error delete purchase image with ID: ${event.id}'));
        } else {
          emit(HRSuccess<bool>(result: true));
        }
      },
    );
  }
}
