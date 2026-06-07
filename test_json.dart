import 'dart:convert';
import 'package:bourgo_arena_mobile/data/models/loyalty_transaction_model.dart';

void main() {
  final jsonStr = '''{
    "points": 19999,
    "transactions": [
        {
            "id": 501,
            "points": 10000,
            "transaction_type": "gift",
            "source_type": "Bourgo Arena",
            "source_id": 38,
            "idempotency_key": "gift:c2331353-9a84-4ca7-bba1-b4f0f577b69f",
            "created_at": "2026-06-05T19:25:25.000000Z"
        }
    ]
  }''';

  try {
    final map = jsonDecode(jsonStr);
    final model = LoyaltyBalanceModel.fromJson(map);
    print('Parsed balance: ${model.totalPoints}');
    print('Parsed transactions: ${model.transactions?.length}');
    if (model.transactions != null && model.transactions!.isNotEmpty) {
      print('Tx 0 id: ${model.transactions![0].id}');
      print('Tx 0 points: ${model.transactions![0].points}');
      print('Tx 0 type: ${model.transactions![0].type}');
      print('Tx 0 description: ${model.transactions![0].description}');
    }
  } catch (e, st) {
    print('Error: $e\n$st');
  }
}
