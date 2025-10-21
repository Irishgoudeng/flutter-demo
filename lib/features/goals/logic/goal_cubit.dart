import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart'; // Add uuid to pubspec.yaml for unique IDs
import '../../data/models/goal_model.dart';
import '../data/repositories/goal_repository.dart';
import 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  final GoalRepository _repository;

  GoalCubit(this._repository) : super(GoalInitial());
  
  final _uuid = const Uuid();

  Future<void> loadGoals() async {
    try {
      emit(GoalLoading());
      final goals = await _repository.fetchGoals();
      emit(GoalLoaded(goals));
    } catch (e) {
      emit(GoalError("Failed to load goals."));
    }
  }

  Future<void> addGoal(String title, String description) async {
    if (state is GoalLoaded) {
      final currentState = state as GoalLoaded;
      final newGoal = Goal(
        id: _uuid.v4(), // Generate a unique ID
        title: title,
        description: description,
      );
      
      // Immediately update UI for a responsive feel
      final updatedList = List<Goal>.from(currentState.goals)..add(newGoal);
      emit(GoalLoaded(updatedList));

      // Then, call the repository to save the data
      await _repository.addGoal(newGoal);
    }
  }
  
  Future<void> updateGoal(Goal updatedGoal) async {
     if (state is GoalLoaded) {
      final currentState = state as GoalLoaded;
      final updatedList = currentState.goals.map((goal) {
        return goal.id == updatedGoal.id ? updatedGoal : goal;
      }).toList();

      emit(GoalLoaded(updatedList));
      await _repository.updateGoal(updatedGoal);
    }
  }

  Future<void> deleteGoal(String id) async {
    if (state is GoalLoaded) {
      final currentState = state as GoalLoaded;
      final updatedList = currentState.goals.where((goal) => goal.id != id).toList();
      
      emit(GoalLoaded(updatedList));
      await _repository.deleteGoal(id);
    }
  }
  
  Future<void> toggleCompletion(Goal goal) async {
    final updatedGoal = Goal(
      id: goal.id,
      title: goal.title,
      description: goal.description,
      isCompleted: !goal.isCompleted,
    );
    await updateGoal(updatedGoal);
  }
}