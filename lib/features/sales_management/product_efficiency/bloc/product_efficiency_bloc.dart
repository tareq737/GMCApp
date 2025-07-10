import 'package:bloc/bloc.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/sales_management/product_efficiency/service/product_efficiency_service.dart';
import 'package:meta/meta.dart';

part 'product_efficiency_event.dart';
part 'product_efficiency_state.dart';

class ProductEfficiencyBloc
    extends Bloc<ProductEfficiencyEvent, ProductEfficiencyState> {
  final ProductEfficiencyService _productEfficiencyServiceServices;
  ProductEfficiencyBloc(
    this._productEfficiencyServiceServices,
  ) : super(ProductEfficiencyInitial()) {
    on<ProductEfficiencyEvent>((event, emit) {
      emit(ProductEfficiencyInitial());
    });
    on<GetAllProducts>(
      (event, emit) async {
        emit(ProductEfficiencyLoading());
        var result = await _productEfficiencyServiceServices.getAllProducts(
          page: event.page,
          search: event.search,
        );
        if (result == null) {
          emit(ProductEfficiencyError(errorMessage: 'Error'));
        } else {
          emit(ProductEfficiencySuccess(result: result));
        }
      },
    );
    on<GetOneProduct>(
      (event, emit) async {
        emit(ProductEfficiencyLoading());
        var result =
            await _productEfficiencyServiceServices.getOneProduct(event.id);
        if (result == null) {
          emit(ProductEfficiencyError(
              errorMessage: 'Error fetching  with ID: ${event.id}'));
        } else {
          emit(ProductEfficiencySuccess(result: result));
        }
      },
    );
  }
}
