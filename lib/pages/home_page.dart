import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'video_call_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String mode = 'normal';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // No logged-in user, redirect to login
        Navigator.pushReplacementNamed(context, '/');
        return;
      }

      final data = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        mode = data['mode'] ?? 'normal';
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading profile: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleMode() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final newMode = (mode == 'normal') ? 'easy' : 'normal';

    await Supabase.instance.client
        .from('profiles')
        .update({'mode': newMode})
        .eq('id', user.id);

    setState(() => mode = newMode);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Medonna")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Mode: $mode", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleMode,
              child: const Text("Switch Mode"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final appId = dotenv.env['AGORA_APP_ID'];
                final token = dotenv.env['TEMP_TOKEN'];

                if (appId == null || token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Agora credentials missing!")),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoCallPage(
                      appId: appId,
                      token: token,
                      channel: "test",
                    ),
                  ),
                );
              },
              child: const Text("Start AI Voice Assistant"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}
