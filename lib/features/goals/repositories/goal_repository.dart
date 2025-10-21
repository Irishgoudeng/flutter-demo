import '../../../features/data/models/goal_model.dart';

class GoalRepository {
  // In-memory list to act as a fake database
  final List<Goal> _goals = [
    const Goal(id: '1', title: 'Learn Flutter BLoC', description: 'Finish the official course by October.', isCompleted: true),
    const Goal(id: '2', title: 'Build a CRUD App UI', description: 'Complete the UI blueprint and code.', isCompleted: true),
    const Goal(id: '3', title: 'Run 5km', description: 'Prepare for the upcoming local marathon.'),
  ];

  Future<List<Goal>> fetchGoals() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency
    return List.from(_goals);
  }

  Future<void> addGoal(Goal goal) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _goals.add(goal);
  }

  Future<void> updateGoal(Goal updatedGoal) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _goals.indexWhere((g) => g.id == updatedGoal.id);
    if (index != -1) {
      _goals[index] = updatedGoal;
    }
  }
  
  Future<void> deleteGoal(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _goals.removeWhere((g) => g.id == id);
  }
}