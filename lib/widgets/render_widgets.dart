import 'package:flutter/material.dart';
import 'package:ease_my_deal/widgets/hexa_color_widget.dart';

//---RenderTextAlignment---
TextAlign renderTextAlignment({required String alignment}) {
  switch (alignment.toLowerCase()) {
    case 'center':
      return TextAlign.center;
    case 'right':
      return TextAlign.right;
    case 'justify':
      return TextAlign.justify;
    default:
      return TextAlign.left;
  }
}

//---RenderMainAxisAlignment---
MainAxisAlignment renderMainAxisAlignment(String alignment) {
  switch (alignment.toLowerCase()) {
    case 'center':
      return MainAxisAlignment.center;
    case 'end':
      return MainAxisAlignment.end;
    case 'spaceevenly':
      return MainAxisAlignment.spaceEvenly;
    case 'spacebetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceround':
      return MainAxisAlignment.spaceAround;
    default:
      return MainAxisAlignment.start;
  }
}

//---RenderCrossAxisAlignment---
CrossAxisAlignment renderCrossAxisAlignment(String alignment) {
  switch (alignment.toLowerCase()) {
    case 'center':
      return CrossAxisAlignment.center;
    case 'end':
      return CrossAxisAlignment.end;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    default:
      return CrossAxisAlignment.start;
  }
}

//---RenderGradientColor---
Gradient? renderGradient(Map<String, dynamic>? gradientConfig) {
  if (gradientConfig == null) return null;
  return LinearGradient(
    colors: (gradientConfig['colors'] as List<dynamic>)
        .map((color) => HexColor(color))
        .toList(),
    begin: renderAlignment(gradientConfig['begin'] ?? "topLeft"),
    end: renderAlignment(gradientConfig['end'] ?? "bottomRight"),
    tileMode: renderTileMode(gradientConfig['tileMode'] ?? "clamp"),
  );
}

Alignment renderAlignment(String? alignment) {
  switch (alignment!.toLowerCase()) {
    case 'center':
      return Alignment.center;
    case 'topleft':
      return Alignment.topLeft;
    case 'topright':
      return Alignment.topRight;
    case 'topcenter':
      return Alignment.topCenter;
    case 'bottomleft':
      return Alignment.bottomLeft;
    case 'bottomright':
      return Alignment.bottomRight;
    case 'bottomcenter':
      return Alignment.bottomCenter;
    case 'centerleft':
      return Alignment.centerLeft;
    case 'centerright':
      return Alignment.centerRight;
    default:
      return Alignment.topLeft;
  }
}

TileMode renderTileMode(String mode) {
  switch (mode.toLowerCase()) {
    case 'mirror':
      return TileMode.mirror;
    case 'repeated':
      return TileMode.repeated;
    default:
      return TileMode.clamp;
  }
}

//---Text Overflow---
TextOverflow renderTextOverflow(String? overflow) {
  switch (overflow?.toLowerCase()) {
    case 'ellipsis':
      return TextOverflow.ellipsis;
    case 'clip':
      return TextOverflow.clip;
    case 'fade':
      return TextOverflow.fade;
    case 'visible':
      return TextOverflow.visible;
    default:
      return TextOverflow.ellipsis; // Default to ellipsis
  }
}

//-----RenderContainerAlignment----
Alignment? renderContainerAlignment(String? alignment) {
  if (alignment == null) {
    return null;
  }

  switch (alignment.toLowerCase()) {
    case 'center':
      return Alignment.center;
    case 'topleft':
      return Alignment.topLeft;
    case 'topright':
      return Alignment.topRight;
    case 'topcenter':
      return Alignment.topCenter;
    case 'bottomleft':
      return Alignment.bottomLeft;
    case 'bottomright':
      return Alignment.bottomRight;
    case 'bottomcenter':
      return Alignment.bottomCenter;
    case 'centerleft':
      return Alignment.centerLeft;
    case 'centerright':
      return Alignment.centerRight;
    default:
      return null;
  }
}

//-----RenderHeight----
double? renderHeight(dynamic value) {
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'infinity':
        return double.infinity;
      case 'maxfinite':
        return const BoxConstraints.expand().maxHeight;
      default:
        return 0;
    }
  }
  if (value is num) {
    return value.toDouble();
  }
  return null;
}

//-----RenderWidth----
double? renderWidth(dynamic value) {
  if (value is String) {
    switch (value.toLowerCase()) {
      case 'infinity':
        return double.infinity;
      case 'maxfinite':
        return const BoxConstraints.expand().maxWidth;
      default:
        return 0;
    }
  }
  if (value is num) {
    return value.toDouble();
  }
  return null;
}

//--RenderPadding--
Widget renderPadding(
    {required Map<String, dynamic> paddingConfig, required Widget child}) {
  if (paddingConfig.containsKey('padding_all')) {
    return Padding(
      padding: EdgeInsets.all(paddingConfig['padding_all'].toDouble()),
      child: child,
    );
  } else if (paddingConfig.containsKey('padding_symmetric')) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical:
            paddingConfig['padding_symmetric']['vertical']?.toDouble() ?? 0.0,
        horizontal:
            paddingConfig['padding_symmetric']['horizontal']?.toDouble() ?? 0.0,
      ),
      child: child,
    );
  } else {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        paddingConfig['padding_left']?.toDouble() ?? 0.0,
        paddingConfig['padding_top']?.toDouble() ?? 0.0,
        paddingConfig['padding_right']?.toDouble() ?? 0.0,
        paddingConfig['padding_bottom']?.toDouble() ?? 0.0,
      ),
      child: child,
    );
  }
}

//-----RenderBoxFit----
BoxFit? renderBoxFit(String? fit) {
  switch (fit!.toLowerCase()) {
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fill':
      return BoxFit.fill;
    case 'fitheight':
      return BoxFit.fitHeight;
    case 'fitwidth':
      return BoxFit.fitWidth;
    case 'none':
      return BoxFit.none;
    case 'scaleDown':
      return BoxFit.scaleDown;
    default:
      return null;
  }
}

//-----RenderDecorationImage----
DecorationImage? renderDecorationImage(Map<String, dynamic>? imageConfig) {
  if (imageConfig == null) return null;
  final String? imageUrl = imageConfig['url'];
  final BoxFit? fit = renderBoxFit(imageConfig['fit'] ?? 'cover');
  if (imageUrl == null) return null;
  return imageUrl.startsWith('http')
      ? DecorationImage(
          image: NetworkImage(imageUrl),
          fit: fit,
          onError: (error, stackTrace) {
            debugPrint('Image Load Error: $error');
          },
        )
      : DecorationImage(
          image: AssetImage(imageUrl),
          fit: fit,
        );
}

//-----RenderBorderRadius----
BorderRadius? renderBorderRadius(dynamic borderRadiusConfig) {
  if (borderRadiusConfig == null || borderRadiusConfig == {}) {
    return null;
  }
  return (borderRadiusConfig is int)
      ? BorderRadius.circular(borderRadiusConfig.toDouble())
      : BorderRadius.only(
          topLeft: Radius.circular(
            borderRadiusConfig['topLeft']?.toDouble() ?? 0.0,
          ),
          topRight: Radius.circular(
            borderRadiusConfig['topRight']?.toDouble() ?? 0.0,
          ),
          bottomLeft: Radius.circular(
            borderRadiusConfig['bottomLeft']?.toDouble() ?? 0.0,
          ),
          bottomRight: Radius.circular(
            borderRadiusConfig['bottomRight']?.toDouble() ?? 0.0,
          ),
        );
}

//-----RenderEdgeInsets----
EdgeInsets renderEdgeInsets(Map<String, dynamic>? config) {
  if (config == null) return EdgeInsets.zero;
  if (config.containsKey('all')) {
    return EdgeInsets.all(config['all']?.toDouble() ?? 0.0);
  } else if (config.containsKey('symmetric')) {
    final symmetricConfig = config['symmetric'];
    return EdgeInsets.symmetric(
      vertical: symmetricConfig['vertical']?.toDouble() ?? 0.0,
      horizontal: symmetricConfig['horizontal']?.toDouble() ?? 0.0,
    );
  } else {
    return EdgeInsets.only(
      left: config['left']?.toDouble() ?? 0.0,
      right: config['right']?.toDouble() ?? 0.0,
      top: config['top']?.toDouble() ?? 0.0,
      bottom: config['bottom']?.toDouble() ?? 0.0,
    );
  }
}
