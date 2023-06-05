import 'package:flutter/foundation.dart';
import 'dart:html' as html;

void avoidContextMenu() {
  if (kIsWeb) {
    html.document.body!.addEventListener('contextmenu', (event) => event.preventDefault());
  }
}
