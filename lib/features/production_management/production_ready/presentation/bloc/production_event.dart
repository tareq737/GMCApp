part of 'production_bloc.dart';

@immutable
sealed class ProdEvent {}

final class ProdAdd<T> extends ProdEvent {
  final T item;

  ProdAdd({required this.item});
}

final class ProdUpdate<T> extends ProdEvent {
  final T item;

  ProdUpdate({required this.item});
}

final class ProdDelete<T> extends ProdEvent {
  final int id;

  ProdDelete({required this.id});
}

final class ProdGetById<T> extends ProdEvent {
  final int id;

  ProdGetById({required this.id});
}

final class ProdGetAll<T> extends ProdEvent {
  ProdGetAll();
}

final class ProdSearch<T> extends ProdEvent {
  final String lexum;

  ProdSearch({required this.lexum});
}

final class ProdPlanCheck extends ProdEvent {
  final CheckViewModel check;

  ProdPlanCheck({required this.check});
}

final class ProdPlanTransfer extends ProdEvent {
  final int id;

  ProdPlanTransfer({required this.id});
}
