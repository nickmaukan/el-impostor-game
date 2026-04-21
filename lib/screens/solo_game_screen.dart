import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/player.dart';
import '../models/word_categories.dart';
import '../theme/app_theme.dart';

class SoloGameScreen extends StatefulWidget {
  const SoloGameScreen({super.key});

  @override
  State<SoloGameScreen> createState() => _SoloGameScreenState();
}

class _SoloGameScreenState extends State<SoloGameScreen> {
  int _playersCount = 4;
  final List<String> _playerNames = [];
  String _playerName = '';
  String _category = 'Actores';
  String _secretWord = '';
  bool _isImpostor = false;
  final _clueController = TextEditingController();
  final List<Map<String, String>> _allClues = []; // {name, clue}
  int _currentClueIndex = 0;
  int _timer = 30;
  Timer? _countdown;
  int _gamePhase = 0; // 0: setup, 1: word, 2: clues, 3: voting, 4: result
  int _impostorIdx = 0;
  Map<String, int> _votes = {};
  int? _winner;

  // Simulated players
  final List<String> _simulatedPlayers = [
    'María', 'Pedro', 'Juan', 'Ana', 'Luis', 'Carmen', 'José', 'Laura',
    'Carlos', 'Sofía', 'Diego', 'Margarita', 'Andrés', 'Patricia',
  ];

  final Map<String, String> _simulatedClues = {
    'María': 'Famoso',
    'Pedro': 'Hollywood',
    'Juan': 'Oscar',
    'Ana': 'Titanic',
    'Luis': 'Actor',
    'Carmen': 'Reparto',
    'José': 'Dirección',
    'Laura': 'Película',
  };

  @override
  void dispose() {
    _clueController.dispose();
    _countdown?.cancel();
    super.dispose();
  }

  void _startGame() {
    // Select category and word
    final cat = categories.firstWhere((c) => c.name == _category, orElse: () => categories.first);
    final random = Random();
    _secretWord = cat.words[random.nextInt(cat.words.length)];
    
    // Create player list with simulated players
    _playerNames.clear();
    _playerNames.add(_playerName);
    for (int i = 0; i < _playersCount - 1; i++) {
      _playerNames.add(_simulatedPlayers[i]);
    }
    
    // Random impostor
    _impostorIdx = random.nextInt(_playerNames.length);
    _isImpostor = _impostorIdx == 0;
    
    // Start game
    setState(() {
      _gamePhase = 1;
      _allClues.clear();
      _votes.clear();
      _winner = null;
    });
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
        // Auto advance if time runs out
        if (_gamePhase == 1) {
          _simulateOtherClues();
        }
      }
    });
  }

  void _submitClue() {
    final clue = _clueController.text.trim();
    if (clue.isEmpty) return;
    
    setState(() {
      _allClues.add({'name': _playerName, 'clue': clue, 'isMe': 'true'});
      _clueController.clear();
      _gamePhase = 2;
    });
    _countdown?.cancel();
    
    // Simulate other players' clues
    _simulateOtherClues();
  }

  void _simulateOtherClues() {
    for (int i = 0; i < _playerNames.length; i++) {
      if (i != 0) { // Skip host (user)
        final playerName = _playerNames[i];
        String clue;
        
        if (i == _impostorIdx) {
          // Impostor - random clue
          final fakeClues = ['No sé', 'Algo', 'Hmm', 'Veremos', 'Necesito más'];
          clue = fakeClues[Random().nextInt(fakeClues.length)];
        } else {
          // Normal player - clue related to word
          clue = _simulatedClues[playerName] ?? _generateClue();
        }
        
        _allClues.add({'name': playerName, 'clue': clue, 'isMe': 'false'});
      }
    }
    
    setState(() {
      _currentClueIndex = 0;
      _gamePhase = 3;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _gamePhase = 4);
      }
    });
  }

  String _generateClue() {
    // Simple clue generator based on first letter or generic
    final clues = ['Conozco', 'He visto', 'Me gusta', 'Famoso', 'Popular', 'Todos conocen'];
    return clues[Random().nextInt(clues.length)];
  }

  void _castVote(String votedName) {
    // User vote
    _votes[_playerName] = 1;
    
    // Simulate AI votes
    for (int i = 1; i < _playerNames.length; i++) {
      final voter = _playerNames[i];
      String voted;
      
      if (i == _impostorIdx) {
        // Impostor votes randomly
        final others = _playerNames.where((n) => n != _playerNames[i]).toList();
        voted = others[Random().nextInt(others.length)];
      } else {
        // AI votes for impostor
        voted = _playerNames[_impostorIdx];
      }
      
      _votes[voted] = (_votes[voted] ?? 0) + 1;
    }
    
    // Determine winner
    final maxVotes = _votes.values.reduce((a, b) => a > b ? a : b);
    final candidates = _votes.entries.where((e) => e.value == maxVotes).map((e) => e.key).toList();
    
    setState(() {
      if (candidates.length == 1) {
        _winner = candidates[0] == _playerNames[_impostorIdx] ? 1 : 0;
      } else {
        // Tie - impostor wins
        _winner = 1;
      }
      _gamePhase = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Modo Solo'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(child: _buildContent()),
    );
  }

  Widget _buildContent() {
    switch (_gamePhase) {
      case 0:
        return _buildSetup();
      case 1:
        return _buildWordPhase();
      case 2:
        return _buildClueSubmission();
      case 3:
        return _buildClueReveal();
      case 4:
        return _buildWaitingClues();
      case 5:
        return _buildResult();
      default:
        return _buildSetup();
    }
  }

  Widget _buildSetup() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tu nombre
          Text('Tu nombre', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(
            onChanged: (v) => _playerName = v,
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
          
          // Número de jugadores
          Text('Jugadores totales', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              for (int n in [3, 4, 5, 6, 8])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => setState(() => _playersCount = n),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _playersCount == n 
                            ? AppTheme.primaryColor 
                            : AppTheme.cardColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('$n', style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Categoría
          Text('Categoría', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSelected = _category == cat.name;
              return GestureDetector(
                onTap: () => setState(() => _category = cat.name),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(cat.icon, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(cat.name, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          
          // Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white54),
                    SizedBox(width: 8),
                    Text('Cómo funciona', style: TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Tú y $_playersCount jugadores simulados\n'
                  '• Todos menos 1 verán la palabra secreta\n'
                  '• El impostor NO sabe la palabra\n'
                  '• Cada uno da UNA pista\n'
                  '• Votan quién es el impostor',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: _playerName.isNotEmpty ? _startGame : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
            ),
            child: const Text('INICIAR JUEGO'),
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
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, size: 24),
                const SizedBox(width: 8),
                Text('$_timer', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Spacer(),
          
          if (_isImpostor)
            Container(
              padding: const EdgeInsets.all(40),
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
                  const Text('TÚ ERES EL', style: TextStyle(color: Colors.white70, fontSize: 18)),
                  const Text('IMPOSTOR', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('No conoces la palabra', style: TextStyle(color: Colors.white70)),
                  const Text('Finge para no ser descubierto', style: TextStyle(color: Colors.white70)),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(40),
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
                  const Text('TU PALABRA SECRETA', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    _secretWord,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          
          const Spacer(),
          
          ElevatedButton(
            onPressed: () {
              _countdown?.cancel();
              _simulateOtherClues();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
            ),
            child: Text(_isImpostor ? 'YA DI MI PISTA' : 'YA VI MI PALABRA'),
          ),
        ],
      ),
    );
  }

  Widget _buildClueSubmission() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, size: 24, color: AppTheme.accentColor),
                const SizedBox(width: 8),
                Text('$_timer', style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
              ],
            ),
          ),
          const Spacer(),
          
          Text('Da una pista de UNA palabra', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 32),
          
          TextField(
            controller: _clueController,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Escribe tu pista',
              hintStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
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
          
          ElevatedButton(
            onPressed: _submitClue,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text('DAR PISTA'),
          ),
        ],
      ),
    );
  }

  Widget _buildClueReveal() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Pistas de jugadores', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView.builder(
              itemCount: _allClues.length,
              itemBuilder: (context, index) {
                final clueData = _allClues[index];
                final isMe = clueData['isMe'] == 'true';
                final playerIdx = _playerNames.indexOf(clueData['name'] ?? '');
                final isImp = playerIdx == _impostorIdx;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isImp 
                        ? AppTheme.accentColor.withOpacity(0.2)
                        : AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: isImp ? Border.all(color: AppTheme.accentColor) : null,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isImp ? AppTheme.accentColor : AppTheme.primaryColor,
                        child: Text(
                          clueData['name']![0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  clueData['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                if (isImp) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('IMPOSTOR?', style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                                if (isMe) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text('TÚ', style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '"${clueData['clue']}"',
                              style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          const Text(
            'Revisa las pistas. ¿Quién está fingiendo?',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          ElevatedButton(
            onPressed: () => setState(() => _gamePhase = 4),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text('VOTAR'),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingClues() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Simulando pistas de otros jugadores...',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final impostorName = _playerNames[_impostorIdx];
    final userWins = _isImpostor ? (_winner == 1) : (_winner == 0);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: userWins
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  userWins ? Icons.emoji_events : Icons.masks,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                userWins ? '¡VICTORIA!' : '¡DERROTA!',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('La palabra era:', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text(
                      _secretWord,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              if (_isImpostor)
                Text(
                  'Eras el impostor. ${userWins ? "Escapaste!" : "Te descubrieron!"}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                )
              else
                Text(
                  'El impostor era: $impostorName',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              
              const SizedBox(height: 16),
              Text(
                'Votos: ${_votes.entries.map((e) => "${e.key}→${e.value}").join(", ")}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              
              const Spacer(),
              
              ElevatedButton(
                onPressed: () => setState(() => _gamePhase = 0),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  backgroundColor: Colors.white,
                  foregroundColor: userWins ? const Color(0xFF059669) : const Color(0xFFDC2626),
                ),
                child: const Text('NUEVA PARTIDA'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text('SALIR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}