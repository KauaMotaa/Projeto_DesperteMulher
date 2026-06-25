/*
Nome: AppTheme
Descrição: identidade visual centralizada, inspirada no portal Desperte Mulher.
Tons acolhedores (lilás/roxo suave) no modo normal e um modo de ALTO CONTRASTE
para acessibilidade (fundo escuro, texto branco, cores fortes), alternável
em tempo real via ThemeController.
 */

import 'package:flutter/material.dart';

/// Controlador global do modo de alto contraste.
/// Telas podem ler/alternar e o MaterialApp reage trocando o tema inteiro.
class ThemeController {
  static final ValueNotifier<bool> highContrast = ValueNotifier<bool>(false);

  static void toggle() {
    highContrast.value = !highContrast.value;
  }
}

class AppColors {
  // ----- MODO NORMAL (identidade Desperte Mulher: rosa/magenta) -----
  static const Color primary = Color(0xFFC2185B);      // magenta/rosa forte
  static const Color primaryDark = Color(0xFF8E0E45);  // vinho
  static const Color primarySoft = Color(0xFFFCE4EC);  // rosa bem claro
  static const Color background = Color(0xFFFDF6F4);    // creme rosado
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textStrong = Color(0xFF3A2A33);
  static const Color textSoft = Color(0xFF8A7680);

  // Níveis de risco - modo normal. Os níveis baixos usam teal (verde-azulado
  // sóbrio) em vez de verde vivo, para não transmitir "está tudo certo" —
  // mesmo um risco baixo existe. O gradiente esquenta até o vermelho.
  static const Color riskVeryLow = Color(0xFF26A69A);
  static const Color riskLow = Color(0xFF66BB9A);
  static const Color riskModerate = Color(0xFFFFB74D);
  static const Color riskHigh = Color(0xFFFF8A65);
  static const Color riskExtreme = Color(0xFFE57373);

  // ----- MODO ALTO CONTRASTE (sóbrio, alinhado ao tema rosa) -----
  // Fundo escuro com texto branco e destaque rosa claro — mantém alto
  // contraste real para acessibilidade, dentro da identidade do projeto.
  static const Color hcBackground = Color(0xFF241019);
  static const Color hcSurface = Color(0xFF351A26);
  static const Color hcPrimary = Color(0xFFFF8FB1); // rosa claro forte
  static const Color hcTextStrong = Color(0xFFFFFFFF);
  static const Color hcTextSoft = Color(0xFFE8D5DC);

  // Níveis de risco - alto contraste. Níveis baixos em teal (não verde-neon),
  // mantendo bom contraste e a mesma lógica do modo normal.
  static const Color hcRiskVeryLow = Color(0xFF1DE9B6);
  static const Color hcRiskLow = Color(0xFF64FFDA);
  static const Color hcRiskModerate = Color(0xFFFFD740);
  static const Color hcRiskHigh = Color(0xFFFFAB40);
  static const Color hcRiskExtreme = Color(0xFFFF5252);

  // ----- SELETORES DINÂMICOS (retornam a cor conforme o modo) -----
  static bool get _hc => ThemeController.highContrast.value;

  static Color get bg => _hc ? hcBackground : background;
  static Color get card => _hc ? hcSurface : surface;
  static Color get accent => _hc ? hcPrimary : primary;
  static Color get txtStrong => _hc ? hcTextStrong : textStrong;
  static Color get txtSoft => _hc ? hcTextSoft : textSoft;

  static Color get rVeryLow => _hc ? hcRiskVeryLow : riskVeryLow;
  static Color get rLow => _hc ? hcRiskLow : riskLow;
  static Color get rModerate => _hc ? hcRiskModerate : riskModerate;
  static Color get rHigh => _hc ? hcRiskHigh : riskHigh;
  static Color get rExtreme => _hc ? hcRiskExtreme : riskExtreme;

  // Cor do título "Desperte" — vinho no normal, branco no alto contraste
  static Color get brandDark => _hc ? hcTextStrong : primaryDark;
}

class AppTheme {
  static ThemeData get light => _build(false);
  static ThemeData get highContrast => _build(true);

  static ThemeData _build(bool hc) {
    final bg = hc ? AppColors.hcBackground : AppColors.background;
    final surface = hc ? AppColors.hcSurface : AppColors.surface;
    final accent = hc ? AppColors.hcPrimary : AppColors.primary;
    final onAccent = hc ? Colors.black : Colors.white;
    final txt = hc ? AppColors.hcTextStrong : AppColors.textStrong;

    return ThemeData(
      useMaterial3: true,
      brightness: hc ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: hc ? Brightness.dark : Brightness.light,
        primary: accent,
        surface: surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: hc ? AppColors.hcSurface : AppColors.primary,
        foregroundColor: hc ? AppColors.hcPrimary : Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      textTheme: hc
          ? const TextTheme().apply(
              bodyColor: AppColors.hcTextStrong,
              displayColor: AppColors.hcTextStrong,
            )
          : null,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
