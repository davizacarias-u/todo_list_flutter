import 'package:flutter/material.dart';
import '../services/app_storage.dart';

class SettingsPages extends StatefulWidget {
  final VoidCallback onLogout;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPages({
    super.key,
    required this.onLogout,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppStorage _appStorage = AppStorage();
  bool _isLoading = true;
  bool _darkMode = false;
  bool _confirmDelete = true;

  @override
  void InitState(){
    super.initState();
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    final settings = await _appStorage.loadSettings();
    setState(() {
      _darkMode = settings.darkMode;
      _confirmDelete = settings.confirmDelete;
      _isLoading = false;
    });
  }

  Future<void> _toggleDarkMode(bool value) async{
    setState(() {
      _darkMode = value;
    });

    await _appStorage.saveDarkMode(value);
    widget.onThemeChanged(value);
  }

  Future<void> _toggleConfirmDelete(bool value) async{
    setState(() {
      _confirmDelete = value;
    });

    await _appStorage.saveConformDelete(value);
  }

  Future<void> _confirmLogout() async{
    final shouldLogout = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Deseja sair da conta?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar'),),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sair'),),
          ],
        );
      }
    );  

    if (shouldLogout == true){
      await _appStorage.setLoggedIn(false);

      if (!mounted){
        return;
      }

      Navigator.pop(context);

      widget.onLogout();
    }
  }
}