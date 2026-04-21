class Player {
  final String id;
  final String name;
  bool isImpostor;
  bool hasGuessed;
  int votes;

  Player({
    required this.id,
    required this.name,
    this.isImpostor = false,
    this.hasGuessed = false,
    this.votes = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isImpostor': isImpostor,
    'hasGuessed': hasGuessed,
    'votes': votes,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'],
    name: json['name'],
    isImpostor: json['isImpostor'] ?? false,
    hasGuessed: json['hasGuessed'] ?? false,
    votes: json['votes'] ?? 0,
  );
}