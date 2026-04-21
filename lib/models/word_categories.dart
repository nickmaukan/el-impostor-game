class WordCategory {
  final String name;
  final String icon;
  final List<String> words;

  const WordCategory({
    required this.name,
    required this.icon,
    required this.words,
  });
}

const categories = [
  WordCategory(
    name: 'Actores',
    icon: '🎬',
    words: [
      'Leonardo DiCaprio', 'Jennifer Lawrence', 'Dwayne Johnson', 'Scarlett Johansson',
      'Tom Hanks', 'Margot Robbie', 'Ryan Gosling', 'Emma Stone', 'Brad Pitt',
      'Angelina Jolie', 'Johnny Depp', 'Zendaya', 'Tom Holland', 'Will Smith',
      'Chris Hemsworth', 'Gal Gadot', 'Ryan Reynolds', 'Chris Evans', 'Anne Hathaway',
      'Keanu Reeves', 'Samuel L. Jackson', 'Morgan Freeman', 'Robert Downey Jr',
      'Chris Pratt', 'Florence Pugh', 'Jason Momoa', 'Victoria Beckham',
      'Shakira', 'Bad Bunny', 'J Balvin', 'Daddy Yankee', 'Karol G',
      'Becky G', 'Maluma', 'Ozuna', 'Farruko', 'Sech',
      'Rauw Alejandro', 'Feid', 'Quevedo', 'Mora', 'Kidd Voodoo',
      'Anuel AA', 'Wisin', 'Yandel', 'Don Omar', 'Casino',
    ],
  ),
  WordCategory(
    name: 'Futbolistas',
    icon: '⚽',
    words: [
      'Lionel Messi', 'Cristiano Ronaldo', 'Kylian Mbappé', 'Erling Haaland',
      'Jude Bellingham', 'Vinicius Jr', 'Kevin De Bruyne', 'Harry Kane',
      'Neymar Jr', 'Kylian Mbappé', 'Lamine Yamal', 'Pedri', 'Gavi',
      'Phil Foden', 'Bukayo Saka', 'Martin Ødegaard', 'Rodri', 'Federico Valverde',
      'Achraf Hakimi', 'Trent Alexander-Arnold', 'Andrew Robertson', 'Alphonso Davies',
      'Eduardo Camavinga', 'Aurélien Tchouaméni', 'Julián Álvarez', 'Emiliano Martínez',
      'Thibaut Courtois', 'Marc-André ter Stegen', 'Manuel Neuer', 'Alisson Becker',
      'Gianluigi Donnarumma', 'Éder Militão', 'Rúben Dias', 'Virgil van Dijk',
      'Antonio Rüdiger', 'Andrew Robertson', 'Theo Hernández', 'Rafael Leão',
    ],
  ),
  WordCategory(
    name: 'TikTokers',
    icon: '📱',
    words: [
      'MrBeast', 'Charli D\'Amelio', 'Addison Rae', 'Khabane Lamar',
      'Khaby Lame', 'Bella Poarch', 'Domelevo', 'Fili',
      'Camilo', 'Margarita', 'Jorge', 'Facundo',
      'Juani', 'Agustín', 'Lautaro', 'Bautista', 'Thiago',
      'Maia', 'Valentina', 'Lucía', 'María', 'Sofía',
      'Miley Cyrus', 'Doja Cat', 'Drake', 'Post Malone', 'The Weeknd',
      'Bad Bunny', 'Peso Pluma', 'Junior H', 'Gera MX', 'Santa Fe Klan',
    ],
  ),
  WordCategory(
    name: 'Cantantes',
    icon: '🎤',
    words: [
      'Taylor Swift', 'Beyoncé', 'Ed Sheeran', 'Ariana Grande',
      'Dua Lipa', 'Billie Eilish', 'Olivia Rodrigo', 'Harry Styles',
      'Adele', 'Lady Gaga', 'Rihanna', 'Bruno Mars',
      'SZA', 'Ice Spice', 'Lana Del Rey', 'Miley Cyrus',
      'Shakira', 'Rosalía', 'Karol G', 'Feid',
      'Bad Bunny', 'Daddy Yankee', 'J Balvin', 'Ozuna',
      'Marco Antonio Solís', 'Luis Miguel', 'José José', 'Juan Gabriel',
      'Ricky Martin', 'Enrique Iglesias', 'Luis Fonsi', 'Chayanne',
      'Thalia', 'Paulina Rubio', 'Christina Aguilera', 'Jennifer Lopez',
    ],
  ),
  WordCategory(
    name: 'Empresarios',
    icon: '💼',
    words: [
      'Elon Musk', 'Jeff Bezos', 'Mark Zuckerberg', 'Tim Cook',
      'Satya Nadella', 'Sundar Pichai', 'Bill Gates', 'Warren Buffett',
      'Tim Cook', 'Daniel Zhang', 'Daniel Ek', 'Jack Dorsey',
      'Brian Chesky', 'Travis Kalanick', 'Reid Hoffman', 'Peter Thiel',
      'Chamath Palihapitiya', 'Carl Icahn', 'Mark Cuban', 'Tony Robbins',
      'Robert Kiyosaki', 'Grant Cardone', 'Simon Sinek', 'Gary Vaynerchuk',
    ],
  ),
  WordCategory(
    name: 'Animales',
    icon: '🐾',
    words: [
      'Perro', 'Gato', 'León', 'Tigre', 'Elefante', 'Jirafa', 'Cebra',
      'Mono', 'Gorila', 'Oso', 'Lobo', 'Zorro', 'Conejo', 'Caballo',
      'Vaca', 'Cerdo', 'Oveja', 'Cabra', 'Burro', 'Camello',
      'Leopardo', 'Pantera', 'Jaguar', 'Puma', 'Guepardo',
      'Hipopótamo', 'Rinoceronte', 'Cocodrilo', 'Serpiente', 'Lagarto',
      'Águila', 'Halcón', 'Búho', 'Loro', 'Tucán', 'Flamenco',
      'Pinguino', 'Delfín', 'Ballena', 'Tiburón', 'Pulpo', 'Medusa',
    ],
  ),
  WordCategory(
    name: 'Comida',
    icon: '🍕',
    words: [
      'Pizza', 'Hamburguesa', 'Sushi', 'Tacos', 'Pasta', 'Paella',
      'Arepa', 'Ceviche', 'Empanada', 'Bandeja Paisa', 'Mondongo',
      'Lasagna', 'Ramen', 'Curry', 'Biryani', 'Falafel',
      'Pechuga', 'Ribeye', 'Costillas', 'Salmon', 'Camaron',
      'Helado', 'Torta', 'Brownie', 'Cheesecake', 'Tiramisu',
      'Ensalada', 'Sopa', 'Arroz', 'Frijoles', 'Pan', 'Queso',
      'Café', 'Té', 'Vino', 'Cerveza', 'Jugo', 'Agua',
    ],
  ),
  WordCategory(
    name: 'Países',
    icon: '🌍',
    words: [
      'Estados Unidos', 'Brasil', 'Argentina', 'México', 'Colombia',
      'España', 'Francia', 'Italia', 'Alemania', 'Reino Unido',
      'Portugal', 'Uruguay', 'Chile', 'Perú', 'Ecuador',
      'Venezuela', 'Costa Rica', 'Panamá', 'Cuba', 'República Dominicana',
      'Canadá', 'Australia', 'Japón', 'Corea del Sur', 'China',
      'India', 'Rusia', 'Turquía', 'Egipto', 'Sudáfrica',
      'Nigeria', 'Marruecos', 'Grecia', 'Holanda', 'Suiza',
      'Suecia', 'Noruega', 'Dinamarca', 'Finlandia', 'Polonia',
    ],
  ),
  WordCategory(
    name: 'Deportes',
    icon: '🏆',
    words: [
      'Fútbol', 'Baloncesto', 'Tenis', 'Béisbol', 'Voleibol',
      'Natación', 'Atletismo', 'Boxeo', 'UFC', 'Golf',
      'Cricket', 'Rugby', 'Hockey', 'Esgrima', 'Gimnasia',
      'Ciclismo', 'Esquiar', 'Snowboard', 'Surf', 'Skate',
      'Parkour', 'Calistenia', 'CrossFit', 'Yoga', 'Pilates',
      'MMA', 'Kickboxing', 'Taekwondo', 'Karate', 'Judo',
      'Canotaje', 'Vela', 'Windsurf', 'Kitesurf', 'Escalada',
      'Paracaidismo', 'Aladeltismo', 'Bungee', 'Motocross', 'F1',
    ],
  ),
  WordCategory(
    name: 'Objetos',
    icon: '📦',
    words: [
      'Teléfono', 'Computadora', 'Televisor', 'Refrigerador', 'Lavadora',
      'Carro', 'Moto', 'Bicicleta', 'Avión', 'Barco',
      'Silla', 'Mesa', 'Cama', 'Sofá', 'Armario',
      'Lámpara', 'Ventilador', 'Aire acondicionado', 'Calefacción', 'Estufa',
      'Reloj', 'Lentes', 'Collar', 'Anillo', 'Pulsera',
      'Bolso', 'Mochila', 'Maleta', 'Billetera', 'Llaves',
      'Raqueta', 'Pelota', 'Guantes', 'Zapatillas', 'Gorras',
      'Pendrive', 'Cargador', 'Cable', 'Batería', 'Speaker',
    ],
  ),
];

// Get random word from category
String getRandomWord(String categoryName) {
  final category = categories.firstWhere(
    (c) => c.name == categoryName,
    orElse: () => categories.first,
  );
  return category.words[(DateTime.now().microsecondsSinceEpoch % category.words.length)];
}

// Get random category
WordCategory getRandomCategory() {
  final index = DateTime.now().microsecondsSinceEpoch % categories.length;
  return categories[index];
}