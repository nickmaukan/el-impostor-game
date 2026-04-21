import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/word_categories.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController();
  final List<String> _players = [];
  final _playerController = TextEditingController();

  void _addPlayer() {
    final name = _playerController.text.trim();
    if (name.isNotEmpty && _players.length < 20) {
      setState(() {
        _players.add(name);
        _playerController.clear();
      });
    }
  }

  void _removePlayer(int index) {
    setState(() {
      _players.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Crear Sala'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tu nombre
            Text(
              'Tu nombre',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ej: Juan',
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            
            // Jugadores
            Text(
              'Jugadores (mínimo 3)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _playerController,
                    decoration: InputDecoration(
                      hintText: 'Nombre del jugador',
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _addPlayer(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addPlayer,
                  child: const Text('AGREGAR'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Lista de jugadores
            Expanded(
              child: _players.isEmpty
                  ? const Center(
                      child: Text(
                        'Agrega al menos 3 jugadores\npara comenzar',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                _players[index][0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              _players[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _removePlayer(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            // Iniciar juego
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _players.length >= 3 ? () {
                // Start game
                context.pushReplacement('/game');
              } : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              child: Text('INICIAR (${_players.length} jugadores)'),
            ),
          ],
        ),
      ),
    );
  }
}