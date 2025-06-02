part of 'exchange_rate_bloc.dart';

@immutable
sealed class ExchangeRateEvent {}

class GetAllRatesForDate extends ExchangeRateEvent {
  final int page;
  final String start;
  final String end;
  final bool details;

  GetAllRatesForDate({
    required this.page,
    required this.start,
    required this.end,
    required this.details,
  });
}

class GetAllRatesOnlyUSD extends ExchangeRateEvent {
  final String start;
  final String end;
  final bool usd;
  final bool ounce;

  GetAllRatesOnlyUSD({
    required this.start,
    required this.end,
    required this.usd,
    required this.ounce,
  });
}

class GetNewRates extends ExchangeRateEvent {}
