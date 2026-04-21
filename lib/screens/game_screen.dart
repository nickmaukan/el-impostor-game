import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/word_categories.dart';
import '../theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentPhase = 0; // 0: waiting, 1: word, 2: clue, 3: voting, 4: result
  String _category = 'Actores';
  String _secretWord = '';
  bool _isImpostor = false;
  final _clueController = TextEditingController();
  int _timer = 30;
  Timer? _countdown;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    final cat = categories[_currentPhase % categories.length];
    _category = cat.name;
    _secretWord = cat.words[DateTime.now().microsecondsSinceEpoch % cat.words.length];
    _isImpostor = _currentPhase == 2; // Simulate impostor for testing
    setState(() {});
    _startTimer();
  }

  void _startTimer() {
    _timer = 30;
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        setState(() => _timer--);
      } else {
        timer.cancel();
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    _countdown?.cancel();
    if (_currentPhase < 4) {
      setState(() => _currentPhase++);
      _startGame();
    } else {
      // Game over
      context.pushReplacement('/result');
    }
  }

  @override
  void dispose() {
    _clueController.dispose();
    _countdown?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: _buildPhaseContent(),
      ),
    );
  }

  Widget _buildPhaseContent() {
    switch (_currentPhase) {
      case 0:
        return _buildWaitingPhase();
      case 1:
        return _buildWordPhase();
      case 2:
        return _buildCluePhase();
      case 3:
        return _buildVotingPhase();
      default:
        return _buildWordPhase();
    }
  }

  Widget _buildWaitingPhase() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Esperando jugadores...',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Código: XXXX',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordPhase() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '$_timer',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          
          // Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_category $_isImpostor',
              style: const TextStyle(fontSize: 18, color: AppTheme.secondaryColor),
            ),
          ),
          const SizedBox(height: 32),
          
          // Secret Word
          if (_isImpostor)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'TÚ ERES EL',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    'IMPOSTOR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No conoces la palabra',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const Text(
                    'Finge para no ser descubierto',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.visibility, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'TU PALABRA SECRETA',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _secretWord,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          const Spacer(),
          
          // Next button
          ElevatedButton(
            onPressed: _nextPhase,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
            ),
            child: Text(_isImpostor ? 'YA DI MI PISTA' : 'YA VI MI PALABRA'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCluePhase() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 20, color: AppTheme.accentColor),
                    const SizedBox(width: 8),
                    Text(
                      '$_timer',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          
          // Instructions
          Text(
            'Da una pista de UNA palabra',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (_isImpostor)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '(No conoces la palabra real)',
                style: TextStyle(color: AppTheme.accentColor),
              ),
            ),
          const SizedBox(height: 32),
          
          // Clue input
          TextField(
            controller: _clueController,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Escribe tu pista',
              hintStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            maxLength: 20,
          ),
          
          const Spacer(),
          
          // Submit clue
          ElevatedButton(
            onPressed: () {
              if (_clueController.text.trim().isNotEmpty) {
                _nextPhase();
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text('DAR PISTA'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildVotingPhase() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '¿Quién es el impostor?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Vota al jugador que crees que no tiene la palabra',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 32),
          
          // Players to vote
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final names = ['Juan', 'María', 'Pedro', 'Ana'];
                return GestureDetector(
                  onTap: () {
                    // Vote logic
                    context.pushReplacement('/result');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(
                            names[index][0],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          names[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}