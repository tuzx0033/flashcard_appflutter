class Vocabulary {
  final String word;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;

  Vocabulary(
      {required this.word, required this.phonetics, required this.meanings});

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    var phoneticsFromJson = json['phonetics'] as List;
    var meaningsFromJson = json['meanings'] as List;

    return Vocabulary(
      word: json['word'],
      phonetics: phoneticsFromJson.map((i) => Phonetic.fromJson(i)).toList(),
      meanings: meaningsFromJson.map((i) => Meaning.fromJson(i)).toList(),
    );
  }
}

class Phonetic {
  final String text;
  final String audio;

  Phonetic({required this.text, required this.audio});

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'] ?? '',
      audio: json['audio'] ?? '',
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    var definitionsFromJson = json['definitions'] as List;
    return Meaning(
      partOfSpeech: json['partOfSpeech'],
      definitions:
          definitionsFromJson.map((i) => Definition.fromJson(i)).toList(),
    );
  }
}

class Definition {
  final String definition;
  final String example;

  Definition({required this.definition, this.example = ''});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'],
      example: json['example'] ?? '',
    );
  }
}
