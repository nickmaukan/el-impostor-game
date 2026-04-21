import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Unirse a Sala'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(
              Icons.group_add,
              size: 80,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(height: 32),
            Text(
              'Código de sala',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              maxLength: 4,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 16,
              ),
              decoration: InputDecoration(
                hintText: '----',
                counterText: '',
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Tu nombre',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              decoration: InputDecoration(
                hintText: 'Escribe tu nombre',
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Join room logic here
                context.pushReplacement('/game');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              child: const Text('UNIRSE'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}