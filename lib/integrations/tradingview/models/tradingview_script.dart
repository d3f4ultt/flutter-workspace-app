import 'package:freezed_annotation/freezed_annotation.dart';

part 'tradingview_script.freezed.dart';
part 'tradingview_script.g.dart';

/// TradingView script model
@freezed
class TradingViewScript with _$TradingViewScript {
  const factory TradingViewScript({
    required String id,
    required String name,
    required String description,
    required String scriptUrl,
    bool? isActive,
    String? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) = _TradingViewScript;

  factory TradingViewScript.fromJson(Map<String, dynamic> json) =>
      _$TradingViewScriptFromJson(json);
}
