
import 'package:flutter/material.dart';
import '../models/data_layer.dart';
import '../provider/plan_provider.dart';
import 'plan_screen.dart';

class PlanCreatorScreen extends StatefulWidget {
  const PlanCreatorScreen({super.key});

  @override
  State<PlanCreatorScreen> createState() =>
      _PlanCreatorScreenState();
}

class _PlanCreatorScreenState
    extends State<PlanCreatorScreen> {
  final TextEditingController textController =
      TextEditingController();

  void addPlan() {
    final text = textController.text.trim();

    if (text.isEmpty) return;

    final plansNotifier = PlanProvider.of(context);

    // Cegah nama rencana yang sama agar mudah dibedakan.
    final alreadyExists = plansNotifier.value.any(
      (plan) => plan.name.toLowerCase() == text.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama rencana sudah digunakan.'),
        ),
      );
      return;
    }

    final newPlan = Plan(
      name: text,
      tasks: const [],
    );

    plansNotifier.value = [
      ...plansNotifier.value,
      newPlan,
    ];

    textController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Plans Alvin'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: textController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Add a plan',
                hintText: 'Contoh: Belajar Flutter',
                contentPadding: const EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addPlan,
                ),
              ),
              onSubmitted: (_) => addPlan(),
            ),
          ),

          Expanded(
            child: ValueListenableBuilder<List<Plan>>(
              valueListenable: plansNotifier,
              builder: (context, plans, child) {
                if (plans.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.note_alt_outlined,
                          size: 100,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Anda belum memiliki rencana apa pun.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final total = plan.tasks.length;
                    final completed = plan.completedCount;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.assignment_outlined),
                        ),
                        title: Text(plan.name),
                        subtitle: Text(
                          '$completed dari $total tugas selesai',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PlanScreen(
                                plan: plan,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
