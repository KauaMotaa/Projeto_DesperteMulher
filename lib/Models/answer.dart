/*
Nome: Answer
Descrição: classe responsável pelo parsing de uma resposta vinda do backend.
O campo 'exclusive' indica opções que não combinam com outras em perguntas
de múltipla escolha (ex.: "Não", "Não sei").
Autor: Silvano Malfatti (base) / ajustado
Data: 13/06/2026
 */

class Answer {
  final String title;
  final int score;
  final bool exclusive;

  Answer({
    required this.title,
    required this.score,
    this.exclusive = false,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      title: json['title'] ?? '',
      score: json['score'] ?? 0,
      exclusive: json['exclusive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'score': score,
      'exclusive': exclusive,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Answer &&
        other.title == title &&
        other.score == score;
  }

  @override
  int get hashCode => Object.hash(title, score);
}
