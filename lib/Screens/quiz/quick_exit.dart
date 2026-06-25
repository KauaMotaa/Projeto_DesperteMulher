/*
Nome: quickExit
Descrição: saída rápida de segurança. Redireciona o navegador para um site
neutro imediatamente, recurso comum em ferramentas voltadas a vítimas de
violência (permite "esconder" a tela caso o agressor se aproxime).
Usa dart:html (nativo do Flutter Web) — sem dependências extras.
 */

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void quickExit() {
  // Substitui a página atual por um site neutro (não deixa no histórico).
  html.window.location.replace('https://www.google.com');
}
