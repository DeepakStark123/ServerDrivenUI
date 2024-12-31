import 'package:ease_my_deal/widgets/hexa_color_widget.dart';
import 'package:ease_my_deal/widgets/render_ui.dart';
import 'package:flutter/material.dart';

class DynamicUI extends StatelessWidget {
  final Map<String, dynamic> config;

  const DynamicUI({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: config['scaffold']?['appBar'] == null
          ? null
          : renderAppBar(config['scaffold']?['appBar']),
      backgroundColor: config['scaffold']?['backgroundColor'] != null
          ? HexColor(config['scaffold']?['backgroundColor'])
          : null,
      body: config['body'] != null ? renderBody(config['body']) : null,
    );
  }
}
