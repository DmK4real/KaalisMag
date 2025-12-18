import 'dart:html' as html;

void redirectToArticle(String path) {
  // Navigate the current window to the given relative path.
  html.window.location.href = path;
}
