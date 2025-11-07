import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/password_model.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PasswordModel> passwords = [];

  @override
  void initState() {
    super.initState();
    loadPasswords();
  }

  Future<void> loadPasswords() async {
    final data = await DatabaseHelper.instance.getPasswords();
    setState(() => passwords = data);
  }

  void deleteItem(int id) async {
    await DatabaseHelper.instance.deletePassword(id);
    loadPasswords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Manager')),
      body: passwords.isEmpty
          ? const Center(child: Text('Belum ada data password.'))
          : ListView.builder(
              itemCount: passwords.length,
              itemBuilder: (context, index) {
                final item = passwords[index];
                return ListTile(
                  title: Text(item.account),
                  subtitle: Text('${item.username} — ${item.password}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditScreen(model: item),
                            ),
                          );
                          loadPasswords();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteItem(item.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditScreen()),
          );
          loadPasswords();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

