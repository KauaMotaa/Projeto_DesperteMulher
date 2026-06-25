/*
Nome: QuizPage
Descrição: tela do questionário em MODO FOCO — exibe uma pergunta por vez
para reduzir a carga cognitiva e não sobrecarregar a usuária. Mantém o
carregamento por página via QuizServer (busca a próxima página quando o
usuário avança além das questões já carregadas). Inclui medidor de risco
em tempo real, barra de progresso, navegação Anterior/Próxima e alternância
de alto contraste.
Autor: Silvano Malfatti (base) / ajustado
Data: 13/06/2026
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/question.dart';
import '../../common/app_routes.dart';
import '../../common/app_theme.dart';
import 'question_widget.dart';
import 'quick_exit.dart';
import 'quiz_server.dart';
import 'risk_meter.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizServer _server = QuizServer();

  bool _isLoading = true;
  bool _isLoadingNextPage = false;

  int _loadedPage = 1;
  int _lastPage = 1;

  // Índice da pergunta atualmente exibida (no modo foco)
  int _currentIndex = 0;

  final List<Question> _questions = [];
  final List<int> _pageSizes = []; // qtd de perguntas por página carregada

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
  }

  // ---------- cálculo ----------
  int get _totalScore =>
      _questions.fold(0, (total, q) => total + q.score);

  int get _maxScore =>
      _questions.fold(0, (total, q) => total + q.maxScore);

  int get _answeredCount =>
      _questions.where((q) => q.isAnswered).length;

  bool get _hasMorePages => _loadedPage < _lastPage;

  // ---------- carregamento ----------
  Future<void> _loadFirstPage() async {
    final result = await _server.fetchQuestions(1);
    if (!mounted) return;
    setState(() {
      _loadedPage = result.page;
      _lastPage = result.lastPage;
      _questions
        ..clear()
        ..addAll(result.questions);
      _pageSizes
        ..clear()
        ..add(result.questions.length);
      _isLoading = false;
    });
    await _restoreAnswers();
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingNextPage || !_hasMorePages) return;
    setState(() => _isLoadingNextPage = true);
    try {
      final result = await _server.fetchQuestions(_loadedPage + 1);
      if (!mounted) return;
      setState(() {
        _loadedPage = result.page;
        _lastPage = result.lastPage;
        _questions.addAll(result.questions);
        _pageSizes.add(result.questions.length);
      });
      await _restoreAnswers();
    } finally {
      if (mounted) setState(() => _isLoadingNextPage = false);
    }
  }

  // ---------- persistência (shared_preferences) ----------
  static const _prefsKey = 'respostas_salvas';

  // Salva um mapa {índice da pergunta: [títulos das respostas escolhidas]}
  Future<void> _saveAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, List<String>> data = {};
    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final titles = q.multiple
          ? q.selectedAnswers.map((a) => a.title).toList()
          : (q.selectedAnswer != null ? [q.selectedAnswer!.title] : <String>[]);
      if (titles.isNotEmpty) data['$i'] = titles;
    }
    await prefs.setString(_prefsKey, jsonEncode(data));
  }

  // Restaura as respostas salvas para as perguntas já carregadas
  Future<void> _restoreAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    final Map<String, dynamic> data = jsonDecode(raw);
    if (!mounted) return;
    setState(() {
      data.forEach((key, value) {
        final idx = int.tryParse(key);
        if (idx == null || idx >= _questions.length) return;
        final q = _questions[idx];
        final titles = (value as List).cast<String>();
        for (final t in titles) {
          final match = q.answers.where((a) => a.title == t);
          if (match.isEmpty) continue;
          final ans = match.first;
          if (q.multiple) {
            if (!q.selectedAnswers.contains(ans)) q.selectedAnswers.add(ans);
          } else {
            q.selectedAnswer = ans;
          }
        }
      });
    });
  }

  Future<void> _clearSavedAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  // ---------- navegação entre perguntas ----------
  Future<void> _onNext() async {
    final current = _questions[_currentIndex];
    if (!current.isAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma resposta para continuar.')),
      );
      return;
    }

    // Se é a última pergunta carregada e há mais páginas, busca a próxima.
    final isLastLoaded = _currentIndex == _questions.length - 1;
    if (isLastLoaded && _hasMorePages) {
      await _loadNextPage();
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      // Acabou tudo -> confirma antes de mostrar o resultado
      _confirmAndShowResult();
    }
  }

  void _onPrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  Future<void> _confirmAndShowResult() async {
    final answered = _answeredCount;
    final total = _questions.length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Finalizar avaliação?'),
        content: Text(
          'Você respondeu $answered de $total perguntas.\n\n'
          'Deseja ver o resultado agora?',
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Continuar respondendo',
              style: TextStyle(color: AppColors.txtSoft),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ver resultado'),
          ),
        ],
      ),
    );

    if (confirmed == true) _onShowResult();
  }

  void _onShowResult() {
    // Avaliação concluída: limpa o rascunho salvo
    _clearSavedAnswers();
    Navigator.pushNamed(
      context,
      AppRoutes.resultPage,
      arguments: {'score': _totalScore, 'maxScore': _maxScore},
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = _questions[_currentIndex];
    final isFirst = _currentIndex == 0;
    final isLastOverall =
        _currentIndex == _questions.length - 1 && !_hasMorePages;

    // total estimado de perguntas: usamos o que já temos; some quando carrega mais
    final answeredCount =
        _questions.where((q) => q.isAnswered).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, color: AppColors.accent, size: 24),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Desperte ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brandDark,
                    ),
                  ),
                  TextSpan(
                    text: 'Mulher',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: ThemeController.highContrast,
            builder: (context, isHc, _) => IconButton(
              tooltip: isHc
                  ? 'Desativar alto contraste'
                  : 'Ativar alto contraste',
              icon: Icon(isHc ? Icons.contrast : Icons.contrast_outlined),
              color: AppColors.accent,
              onPressed: ThemeController.toggle,
            ),
          ),
          // Saída rápida de segurança
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton.icon(
              onPressed: quickExit,
              icon: const Icon(Icons.exit_to_app, size: 18),
              label: const Text('Sair'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.rExtreme,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoBanner(),
          RiskMeter(score: _totalScore, maxScore: _maxScore),
          _buildProgress(answeredCount),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _isLoadingNextPage
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : QuestionWidget(
                      key: ValueKey(_currentIndex),
                      question: current,
                      onChanged: () {
                        setState(() {});
                        _saveAnswers();
                      },
                    ),
            ),
          ),
          _buildNavBar(isFirst, isLastOverall),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: AppColors.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Esta análise tem caráter informativo e não substitui a avaliação '
              'da rede de proteção à mulher. Em caso de violência, procure os '
              'serviços especializados.',
              style: TextStyle(
                fontSize: 13,
                height: 1.3,
                color: AppColors.txtStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(int answeredCount) {
    final total = _questions.length;
    final shownNumber = _currentIndex + 1;

    // Etapa atual: descobre a qual página (etapa) a pergunta atual pertence,
    // somando os tamanhos das páginas já carregadas.
    int currentStep = 1;
    int acc = 0;
    for (int p = 0; p < _pageSizes.length; p++) {
      acc += _pageSizes[p];
      if (_currentIndex < acc) {
        currentStep = p + 1;
        break;
      }
      currentStep = p + 1;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          // Bolinhas de etapa (estilo Desperte Mulher: 1-2-3...)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_lastPage, (i) {
              final step = i + 1;
              final isActive = step == currentStep;
              final isDone = step < currentStep;
              return Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (isActive || isDone)
                          ? AppColors.accent
                          : AppColors.txtSoft.withValues(alpha: 0.25),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$step',
                      style: TextStyle(
                        color: (isActive || isDone)
                            ? Colors.white
                            : AppColors.txtSoft,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (step < _lastPage)
                    Container(
                      width: 24,
                      height: 2,
                      color: AppColors.txtSoft.withValues(alpha: 0.25),
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pergunta $shownNumber${_hasMorePages ? '' : ' de $total'}',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.txtSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$answeredCount respondidas',
                style: TextStyle(fontSize: 14, color: AppColors.txtSoft),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(bool isFirst, bool isLastOverall) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (!isFirst)
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _onPrevious,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Anterior', style: TextStyle(fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: BorderSide(color: AppColors.accent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            if (!isFirst) const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _onNext,
                  icon: Icon(
                      isLastOverall ? Icons.check_circle : Icons.arrow_forward),
                  label: Text(isLastOverall ? 'Ver Resultado' : 'Próxima', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
