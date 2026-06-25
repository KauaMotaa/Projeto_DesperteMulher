
/*
Nome: QuizServer
Descrição: classe responsavel por buscar os dados das questões de acordo com a página solicitada
Autor: Silvano Malfatti
Data: 13/06/2026
 */

import 'dart:convert';
import 'package:flutter/services.dart';
import '../../Models/quiz_page.dart';

class QuizServer {
  Future<QuizPageResponse> fetchQuestions([int page = 1]) async {
    await Future.delayed(const Duration(seconds: 1));

    final jsonString = await rootBundle.loadString(
      'assets/Mock/page$page.json',
    );

    final Map<String, dynamic> json =
    jsonDecode(jsonString);

    return QuizPageResponse.fromJson(json);
  }
}