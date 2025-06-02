part of 'exchange_rate_bloc.dart';

@immutable
sealed class ExchangeRateState {}

final class ExchangeRateInitial extends ExchangeRateState {}

class RatesLoading extends ExchangeRateState {}

class NewRatesLoading extends ExchangeRateState {}

class RatesError extends ExchangeRateState {
  final String errorMessage;

  RatesError({required this.errorMessage});
}

class RatesSuccess<T> extends ExchangeRateState {
  final T result;

  RatesSuccess({required this.result});
}
