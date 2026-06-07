import 'package:flutter/foundation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_plans_use_case.dart';

class PlansViewModel extends ChangeNotifier {
  final GetPlansUseCase _getPlansUseCase;

  PlansViewModel({required GetPlansUseCase getPlansUseCase})
    : _getPlansUseCase = getPlansUseCase;

  bool get isLoading => false;
  List<dynamic> get plans => [];
  String? get errorMessage => null;

  Future<void> loadPlans() async {}
}
