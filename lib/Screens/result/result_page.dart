/*
Nome: ResultPage
Descrição: tela de resultado. Recebe pontuação e máximo, calcula a
porcentagem e classifica em 5 níveis (Muito Baixo a Extremo). Topo com
gradiente da identidade Desperte Mulher, card de nível destacado, orientação
por nível e contatos de ajuda.
Autor: Silvano Malfatti (base) / ajustado
Data: 13/06/2026
 */

import 'package:flutter/material.dart';
import '../../common/app_theme.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    int score = 0;
    int maxScore = 0;
    if (args is Map) {
      score = (args['score'] as int?) ?? 0;
      maxScore = (args['maxScore'] as int?) ?? 0;
    } else if (args is int) {
      score = args;
    }

    final double percent = maxScore > 0 ? (score / maxScore) * 100 : 0;
    final level = _classify(percent);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // Topo com gradiente (estilo banner do site)
          SliverToBoxAdapter(
            child: _buildHeader(context, level, percent),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildScoreCard(level, score, maxScore, percent),
                  const SizedBox(height: 18),
                  _buildOrientation(level),
                  const SizedBox(height: 18),
                  _buildContacts(),
                  const SizedBox(height: 18),
                  _buildDisclaimer(),
                  const SizedBox(height: 20),
                  _buildButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- TOPO COM GRADIENTE ----------
  Widget _buildHeader(BuildContext context, _Level level, double percent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: Column(
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Desperte ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'Mulher',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFD2E0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(level.icon, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Avaliação concluída',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nível de risco: ${level.label}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ---------- CARD DE PONTUAÇÃO ----------
  Widget _buildScoreCard(
      _Level level, int score, int maxScore, double percent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
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
                'Pontuação obtida',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.txtSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                maxScore > 0 ? '$score de $maxScore' : '$score',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.txtStrong,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (maxScore > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 18,
                color: level.color,
                backgroundColor: AppColors.txtSoft.withValues(alpha: 0.18),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${percent.toStringAsFixed(0)}% do risco máximo',
                  style: TextStyle(fontSize: 14, color: AppColors.txtSoft),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: level.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    level.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: level.color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------- ORIENTAÇÃO ----------
  Widget _buildOrientation(_Level level) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: level.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: level.color, size: 22),
              const SizedBox(width: 8),
              Text(
                'Orientação',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: level.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            level.message,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.txtStrong,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- CONTATOS ----------
  Widget _buildContacts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
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
            children: [
              Icon(Icons.support_agent, color: AppColors.accent, size: 22),
              const SizedBox(width: 8),
              Text(
                'Precisa de ajuda? Fale agora',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.txtStrong,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _contactItem('180', 'Central de Atendimento à Mulher',
              Icons.phone_in_talk),
          const SizedBox(height: 10),
          _contactItem('190', 'Polícia Militar (emergência)', Icons.local_police),
          const SizedBox(height: 10),
          _contactItem('188', 'CVV — Apoio emocional', Icons.favorite),
        ],
      ),
    );
  }

  Widget _contactItem(String number, String label, IconData icon) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: AppColors.txtStrong),
          ),
        ),
        Icon(icon, color: AppColors.txtSoft, size: 20),
      ],
    );
  }

  // ---------- DISCLAIMER ----------
  Widget _buildDisclaimer() {
    return Text(
      'Esta análise tem caráter informativo e não substitui a avaliação da '
      'rede de proteção à mulher.',
      style: TextStyle(
        fontSize: 13,
        height: 1.3,
        color: AppColors.txtSoft,
      ),
      textAlign: TextAlign.center,
    );
  }

  // ---------- BOTÃO ----------
  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.refresh),
        label: const Text(
          'Refazer avaliação',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  _Level _classify(double percent) {
    if (percent <= 20) {
      return _Level(
        'Muito Baixo',
        AppColors.rVeryLow,
        Icons.sentiment_very_satisfied,
        'Os indicadores apontam um nível muito baixo de risco neste momento. '
            'Ainda assim, cuidar de você é sempre importante — fique atenta a '
            'qualquer mudança e mantenha pessoas de confiança por perto.',
      );
    } else if (percent <= 40) {
      return _Level(
        'Baixo',
        AppColors.rLow,
        Icons.sentiment_satisfied,
        'O nível indicado é baixo. Vale manter sua rede de apoio próxima e '
            'observar como você se sente ao longo do tempo. Conversar com '
            'alguém de confiança pode ajudar.',
      );
    } else if (percent <= 60) {
      return _Level(
        'Moderado',
        AppColors.rModerate,
        Icons.sentiment_neutral,
        'O nível é moderado. Este pode ser um bom momento para buscar '
            'orientação de profissionais da rede de proteção e pensar em um '
            'plano de segurança para você.',
      );
    } else if (percent <= 80) {
      return _Level(
        'Alto',
        AppColors.rHigh,
        Icons.sentiment_dissatisfied,
        'O nível indicado é alto. É importante procurar a rede de proteção e '
            'os serviços especializados. Você tem direito a proteção e não '
            'precisa enfrentar isso sozinha.',
      );
    } else {
      return _Level(
        'Extremo',
        AppColors.rExtreme,
        Icons.warning_amber_rounded,
        'O nível é extremo. Procure ajuda especializada o quanto antes e '
            'considere acionar a rede de proteção imediatamente. Em caso de '
            'perigo imediato, ligue 190. Você não está sozinha.',
      );
    }
  }
}

class _Level {
  final String label;
  final Color color;
  final IconData icon;
  final String message;
  _Level(this.label, this.color, this.icon, this.message);
}
