
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/todo_provider.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Riverpod'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: todos.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checklist,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada tugas',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text('Tekan tombol + untuk menambah tugas'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.done,
                      activeColor: Colors.teal,
                      onChanged: (_) {
                        ref
                            .read(todoListProvider.notifier)
                            .toggle(index);
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.done ? Colors.grey : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        ref
                            .read(todoListProvider.notifier)
                            .remove(index);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          _showAddDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tugas baru'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama tugas',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              final title = controller.text.trim();

              if (title.isNotEmpty) {
                ref.read(todoListProvider.notifier).add(title);
                Navigator.pop(dialogContext);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final title = controller.text.trim();

                if (title.isNotEmpty) {
                  ref.read(todoListProvider.notifier).add(title);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }
}
