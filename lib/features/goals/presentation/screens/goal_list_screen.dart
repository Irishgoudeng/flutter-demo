import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/goal_cubit.dart';
import '../../logic/goal_state.dart';
import 'add_edit_goal_screen.dart';

class GoalListScreen extends StatelessWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Goals'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<GoalCubit, GoalState>(
        builder: (context, state) {
          if (state is GoalLoading || state is GoalInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GoalError) {
            return Center(child: Text(state.message));
          }
          if (state is GoalLoaded) {
            if (state.goals.isEmpty) {
              return const Center(child: Text('No goals yet. Add one!'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.goals.length,
              itemBuilder: (context, index) {
                final goal = state.goals[index];
                return Dismissible(
                  key: Key(goal.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    context.read<GoalCubit>().deleteGoal(goal.id); // Call Cubit method
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${goal.title} deleted')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          goal.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                          color: goal.isCompleted ? Colors.green : Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                           context.read<GoalCubit>().toggleCompletion(goal); // Call Cubit method
                        },
                      ),
                      title: Text(
                        goal.title,
                        style: TextStyle(decoration: goal.isCompleted ? TextDecoration.lineThrough : null),
                      ),
                      subtitle: Text(goal.description),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AddEditGoalScreen(goal: goal),
                        ));
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        //Hello This is a change
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const AddEditGoalScreen(),
          ));
        },
        tooltip: 'Add Goal',
        child: const Icon(Icons.add),
      ),
    );
  }
}