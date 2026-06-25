/*
Nome: RiskMeter
Descrição: medidor de risco em tempo real. Mostra a porcentagem atual
(pontuação / máximo) com barra animada e rótulo de nível, atualizando
conforme o preenchimento — feedback visual imediato.
 */

import 'package:flutter/material.dart';
import '../../common/app_theme.dart';

class RiskMeter extends StatelessWidget {
  final int score;
  final int maxScore;

  const RiskMeter({
    super.key,
    required this.score,
    required this.maxScore,
  });

  double get _percent => maxScore > 0 ? (score / maxScore) : 0;

  String get _label {
    final p = _percent * 100;
    if (p <= 20) return 'Muito Baixo';
    if (p <= 40) return 'Baixo';
    if (p <= 60) return 'Moderado';
    if (p <= 80) return 'Alto';
    return 'Extremo';
  }

  Color get _color {
    final p = _percent * 100;
    if (p <= 20) return AppColors.rVeryLow;
    if (p <= 40) return AppColors.rLow;
    if (p <= 60) return AppColors.rModerate;
    if (p <= 80) return AppColors.rHigh;
    return AppColors.rExtreme;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _color.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nível de risco atual',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.txtSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _percent),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 16,
                  color: _color,
                  backgroundColor: AppColors.txtSoft.withValues(alpha: 0.2),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(_percent * 100).toStringAsFixed(0)}% do risco máximo',
            style: TextStyle(fontSize: 14, color: AppColors.txtSoft),
          ),
        ],
      ),
    );
  }
}
