/*
Nome: QuestionWidget
Descrição: widget que apresenta uma questão com pergunta e respostas.
Suporta escolha única (RadioListTile) e múltipla escolha (CheckboxListTile),
conforme o campo 'multiple' da pergunta. A faixa lateral rosa segue a
identidade do site Desperte Mulher.
Autor: Silvano Malfatti (base) / ajustado
Data: 13/06/2026
 */

import 'package:flutter/material.dart';
import '../../Models/answer.dart';
import '../../Models/question.dart';
import '../../common/app_theme.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final VoidCallback? onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    this.onChanged,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  // Escolha única
  void _selectSingle(Answer answer) {
    setState(() {
      widget.question.selectedAnswer = answer;
    });
    widget.onChanged?.call();
  }

  // Múltipla escolha (com exclusão mútua para opções "Não"/"Não sei")
  void _toggleMultiple(Answer answer, bool selected) {
    setState(() {
      final list = widget.question.selectedAnswers;
      if (selected) {
        if (answer.exclusive) {
          // Marcou uma opção exclusiva → ela fica sozinha
          list
            ..clear()
            ..add(answer);
        } else {
          // Marcou uma opção normal → remove qualquer exclusiva antes
          list.removeWhere((a) => a.exclusive);
          if (!list.contains(answer)) list.add(answer);
        }
      } else {
        list.remove(answer);
      }
    });
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 5, color: AppColors.accent),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.question.title,
                          style: TextStyle(
                            fontSize: 22,
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                            color: AppColors.txtStrong,
                          ),
                        ),
                        if (widget.question.multiple) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Você pode marcar mais de uma opção',
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: AppColors.txtSoft,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        ...widget.question.answers.map(_buildAnswerItem),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerItem(Answer answer) {
    if (widget.question.multiple) {
      final checked = widget.question.selectedAnswers.contains(answer);
      return CheckboxListTile(
        title: Text(
          answer.title,
          style: TextStyle(
            fontSize: 17,
            height: 1.25,
            color: AppColors.txtStrong,
          ),
        ),
        value: checked,
        activeColor: AppColors.accent,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        onChanged: (v) => _toggleMultiple(answer, v ?? false),
      );
    }

    return RadioListTile<Answer>(
      title: Text(
        answer.title,
        style: TextStyle(
          fontSize: 17,
          height: 1.25,
          color: AppColors.txtStrong,
        ),
      ),
      value: answer,
      groupValue: widget.question.selectedAnswer,
      activeColor: AppColors.accent,
      contentPadding: EdgeInsets.zero,
      onChanged: (value) {
        if (value != null) _selectSingle(value);
      },
    );
  }
}
