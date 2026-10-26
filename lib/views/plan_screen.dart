import 'package:flutter/material.dart';

import '../models/data_layer.dart';
import '../provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Master Plan Alvin')),
      body: ValueListenableBuilder<Plan>(
        valueListenable: PlanProvider.of(context),
        builder: (context, plan, child) {
          final totalTasks = plan.tasks.length;
          final completedTasks = plan.completedCount;

          final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

          return Column(
            children: [
              // Daftar tugas
              Expanded(child: _buildList(plan)),

              // Panel progres
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

                    // Bar progres ungu
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.purple.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
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

  // Tombol untuk menambahkan tugas
  Widget _buildAddTaskButton(BuildContext context) {
    final planNotifier = PlanProvider.of(context);

    return FloatingActionButton(
      onPressed: () {
        final currentPlan = planNotifier.value;

        planNotifier.value = Plan(
          name: currentPlan.name,
          tasks: List<Task>.from(currentPlan.tasks)..add(const Task()),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  // Tampilan setiap tugas
  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    final planNotifier = PlanProvider.of(context);

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        activeColor: Colors.purple,
        onChanged: (selected) {
          final currentPlan = planNotifier.value;

          final updatedTasks = List<Task>.from(currentPlan.tasks);

          updatedTasks[index] = Task(
            description: task.description,
            complete: selected ?? false,
          );

          planNotifier.value = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );
        },
      ),

      title: TextFormField(
        initialValue: task.description,
        decoration: const InputDecoration(hintText: 'Masukkan tugas'),
        onChanged: (text) {
          final currentPlan = planNotifier.value;

          final updatedTasks = List<Task>.from(currentPlan.tasks);

          updatedTasks[index] = Task(
            description: text,
            complete: task.complete,
          );

          planNotifier.value = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );
        },
      ),
    );
  }

  // Membuat daftar tugas
  Widget _buildList(Plan plan) {
    return ListView.builder(
      controller: scrollController,
      keyboardDismissBehavior: Theme.of(context).platform == TargetPlatform.iOS
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskTile(plan.tasks[index], index, context);
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
