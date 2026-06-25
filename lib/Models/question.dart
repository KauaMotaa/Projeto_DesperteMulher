/*
Nome: Question
Descrição: classe responsável pelo parsing de uma pergunta vinda do backend.
Suporta escolha única (selectedAnswer) e múltipla escolha (selectedAnswers),
conforme o campo 'multiple' do JSON.
Autor: Silvano Malfatti (base) / ajustado
Data: 13/06/2026
 */

import 'answer.dart';

class Question {
  final String title;
  final List<Answer> answers;
  final bool multiple;

  // Escolha única
  Answer? selectedAnswer;
  // Múltipla escolha
  final List<Answer> selectedAnswers;

  Question({
    required this.title,
    required this.answers,
    this.multiple = false,
    this.selectedAnswer,
    List<Answer>? selectedAnswers,
  }) : selectedAnswers = selectedAnswers ?? [];

  // Soma da pontuação: única = a resposta escolhida; múltipla = soma de todas.
  int get score {
    if (multiple) {
      return selectedAnswers.fold(0, (t, a) => t + a.score);
    }
    return selectedAnswer?.score ?? 0;
  }

  // Maior pontuação possível desta pergunta (para o cálculo do máximo).
  int get maxScore {
    if (multiple) {
      // soma de todas as opções com score positivo (pior caso)
      return answers.fold(0, (t, a) => t + (a.score > 0 ? a.score : 0));
    }
    return answers.fold(0, (m, a) => a.score > m ? a.score : m);
  }

  // Foi respondida?
  bool get isAnswered =>
      multiple ? selectedAnswers.isNotEmpty : selectedAnswer != null;

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      title: json['title'] as String,
      multiple: json['multiple'] as bool? ?? false,
      answers: (json['answers'] as List)
          .map((item) => Answer.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'multiple': multiple,
      'answers': answers.map((e) => e.toJson()).toList(),
    };
  }
}
