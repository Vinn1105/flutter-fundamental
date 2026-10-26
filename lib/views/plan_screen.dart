
import 'package:flutter/material.dart';
import '../models/data_layer.dart';
import '../provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;

  const PlanScreen({
    super.key,
    required this.plan,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  Plan get plan => widget.plan;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).unfocus();
      });
  }

  @override
  Widget build(BuildContext context) {
    final plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
      ),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          final planIndex =
              plans.indexWhere((p) => p.name == plan.name);

          if (planIndex == -1) {
            return const Center(
              child: Text('Rencana tidak ditemukan.'),
            );
          }

          final currentPlan = plans[planIndex];
          final totalTasks = currentPlan.tasks.length;
          final completedTasks = currentPlan.completedCount;
          final progress = totalTasks == 0
              ? 0.0
              : completedTasks / totalTasks;

          return Column(
            children: [
              Expanded(
                child: _buildList(currentPlan),
              ),

              // Panel progres di bawah daftar tugas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$completedTasks dari $totalTasks tugas selesai',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.purple.shade100,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          Colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).round()}% selesai',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    final plansNotifier = PlanProvider.of(context);

    return FloatingActionButton(
      onPressed: () {
        final plans = plansNotifier.value;
        final planIndex =
            plans.indexWhere((p) => p.name == plan.name);

        if (planIndex == -1) return;

        final currentPlan = plans[planIndex];
        final updatedTasks =
            List<Task>.from(currentPlan.tasks)
              ..add(const Task());

        final updatedPlans = List<Plan>.from(plans);
        updatedPlans[planIndex] = Plan(
          name: currentPlan.name,
          tasks: updatedTasks,
        );

        plansNotifier.value = updatedPlans;
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildTaskTile(
    Task task,
    int index,
    BuildContext context,
  ) {
    final plansNotifier = PlanProvider.of(context);

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        activeColor: Colors.purple,
        onChanged: (selected) {
          final plans = plansNotifier.value;
          final planIndex =
              plans.indexWhere((p) => p.name == plan.name);

          if (planIndex == -1) return;

          final currentPlan = plans[planIndex];
          final updatedTasks =
              List<Task>.from(currentPlan.tasks);

          updatedTasks[index] = Task(
            description: task.description,
            complete: selected ?? false,
          );

          final updatedPlans = List<Plan>.from(plans);
          updatedPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

          plansNotifier.value = updatedPlans;
        },
      ),
      title: TextFormField(
        key: ValueKey('task-${plan.name}-$index'),
        initialValue: task.description,
        decoration: const InputDecoration(
          hintText: 'Masukkan tugas',
        ),
        onChanged: (text) {
          final plans = plansNotifier.value;
          final planIndex =
              plans.indexWhere((p) => p.name == plan.name);

          if (planIndex == -1) return;

          final currentPlan = plans[planIndex];
          final updatedTasks =
              List<Task>.from(currentPlan.tasks);

          updatedTasks[index] = Task(
            description: text,
            complete: task.complete,
          );

          final updatedPlans = List<Plan>.from(plans);
          updatedPlans[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

          plansNotifier.value = updatedPlans;
        },
      ),
    );
  }

  Widget _buildList(Plan currentPlan) {
    return ListView.builder(
      controller: scrollController,
      keyboardDismissBehavior:
          Theme.of(context).platform == TargetPlatform.iOS
              ? ScrollViewKeyboardDismissBehavior.onDrag
              : ScrollViewKeyboardDismissBehavior.manual,
      itemCount: currentPlan.tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskTile(
          currentPlan.tasks[index],
          index,
          context,
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
