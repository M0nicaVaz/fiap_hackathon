import 'package:fiap_hackathon/core/design_system/provider/design_system_provider.dart';
import 'package:fiap_hackathon/core/design_system/widgets/ds_button/ds_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileController>().profile;
    _nameController = TextEditingController(text: profile?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await context.read<ProfileController>().save(
          displayName: _nameController.text.trim(),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil salvo com sucesso.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final ctrl = context.watch<ProfileController>();
    final profile = ctrl.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ds.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage: profile?.photoUrl != null
                    ? NetworkImage(profile!.photoUrl!)
                    : null,
                child: profile?.photoUrl == null
                    ? Icon(Icons.person, size: 48, color: ds.colors.primary)
                    : null,
              ),
            ),
            SizedBox(height: ds.spacing.xl),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(label: Text('Nome')),
            ),
            SizedBox(height: ds.spacing.md),
            TextFormField(
              initialValue: profile?.email ?? '',
              readOnly: true,
              decoration: const InputDecoration(label: Text('E-mail')),
            ),
            SizedBox(height: ds.spacing.xxl),
            DSButton(
              label: 'Salvar',
              onPressed: ctrl.loading ? null : _save,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
