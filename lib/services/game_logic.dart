import 'dart:math';
import '../models/player.dart';
import '../models/word_categories.dart';

enum GamePhase {
  waiting,
  selectingCategory,
  wordDistribution,
  givingClues,
  voting,
  result,
}

class GameState {
  final String roomCode;
  final List<Player> players;
  final String category;
  final String secretWord;
  final int impostorIndex;
  final int currentTurn;
  final List<String> clues;
  final GamePhase phase;
  final int timerSeconds;

  GameState({
    required this.roomCode,
    required this.players,
    required this.category,
    required this.secretWord,
    required this.impostorIndex,
    this.currentTurn = 0,
    this.clues = const [],
    this.phase = GamePhase.waiting,
    this.timerSeconds = 30,
  });

  GameState copyWith({
    String? roomCode,
    List<Player>? players,
    String? category,
    String? secretWord,
    int? impostorIndex,
    int? currentTurn,
    List<String>? clues,
    GamePhase? phase,
    int? timerSeconds,
  }) {
    return GameState(
      roomCode: roomCode ?? this.roomCode,
      players: players ?? this.players,
      category: category ?? this.category,
      secretWord: secretWord ?? this.secretWord,
      impostorIndex: impostorIndex ?? this.impostorIndex,
      currentTurn: currentTurn ?? this.currentTurn,
      clues: clues ?? this.clues,
      phase: phase ?? this.phase,
      timerSeconds: timerSeconds ?? this.timerSeconds,
    );
  }
}

class GameService {
  static String generateRoomCode() {
    final random = Random();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
  }

  static List<Player> createPlayers(List<String> names) {
    return names.asMap().entries.map((e) => Player(
      id: e.key.toString(),
      name: e.value,
    )).toList();
  }

  static GameState setupGame(List<Player> players, String category) {
    final random = Random();
    final impostorIndex = random.nextInt(players.length);
    
    final cat = categories.firstWhere(
      (c) => c.name == category,
      orElse: () => categories.first,
    );
    
    final word = cat.words[random.nextInt(cat.words.length)];
    
    final playersWithImpostor = players.map((p) => Player(
      id: p.id,
      name: p.name,
      isImpostor: p.id == impostorIndex.toString(),
    )).toList();
    
    return GameState(
      roomCode: generateRoomCode(),
      players: playersWithImpostor,
      category: category,
      secretWord: word,
      impostorIndex: impostorIndex,
      phase: GamePhase.wordDistribution,
    );
  }

  static GameState addClue(GameState state, String clue) {
    final newClues = [...state.clues, clue];
    final nextTurn = state.currentTurn + 1;
    
    if (nextTurn >= state.players.length) {
      // All players gave clues, move to voting
      return state.copyWith(
        clues: newClues,
        currentTurn: nextTurn,
        phase: GamePhase.voting,
      );
    }
    
    return state.copyWith(
      clues: newClues,
      currentTurn: nextTurn,
    );
  }

  static GameState vote(GameState state, String voterId, String votedPlayerId) {
    final updatedPlayers = state.players.map((p) {
      if (p.id == votedPlayerId) {
        return Player(
          id: p.id,
          name: p.name,
          isImpostor: p.isImpostor,
          votes: p.votes + 1,
        );
      }
      return p;
    }).toList();
    
    // Check if all have voted
    final allVoted = updatedPlayers.every((p) => p.votes > 0 || p.id == voterId);
    
    return state.copyWith(
      players: updatedPlayers,
      phase: allVoted ? GamePhase.result : state.phase,
    );
  }

  static bool checkWinner(GameState state) {
    final maxVotes = state.players.map((p) => p.votes).reduce((a, b) => a > b ? a : b);
    final mostVoted = state.players.where((p) => p.votes == maxVotes).toList();
    
    if (mostVoted.length > 1) {
      // Tie - impostor wins
      return true;
    }
    
    final caughtPlayer = mostVoted.first;
    return caughtPlayer.isImpostor;
  }

  static Player? getImpostor(GameState state) {
    if (state.impostorIndex < state.players.length) {
      return state.players[state.impostorIndex];
    }
    return null;
  }
}