import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/password_model.dart';

class AddEditScreen extends StatefulWidget {
  final PasswordModel? model;
  const AddEditScreen({super.key, this.model});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController accountController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    accountController = TextEditingController(text: widget.model?.account ?? '');
    usernameController = TextEditingController(text: widget.model?.username ?? '');
    passwordController = TextEditingController(text: widget.model?.password ?? '');
  }

  @override
  void dispose() {
    accountController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void saveData() async {
    if (_formKey.currentState!.validate()) {
      final model = PasswordModel(
        id: widget.model?.id,
        account: accountController.text,
        username: usernameController.text,
        password: passwordController.text,
      );

      if (widget.model == null) {
        await DatabaseHelper.instance.insertPassword(model);
      } else {
        await DatabaseHelper.instance.updatePassword(model);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model == null ? 'Tambah Password' : 'Edit Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: accountController,
                decoration: const InputDecoration(labelText: 'Nama Akun'),
                validator: (val) => val!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (val) => val!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (val) => val!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveData,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
