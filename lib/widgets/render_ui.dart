import 'package:flutter/material.dart';
import 'package:ease_my_deal/utils/ui_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ease_my_deal/widgets/render_widgets.dart';
import 'package:ease_my_deal/widgets/hexa_color_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

//--RenderAppBar--
PreferredSizeWidget? renderAppBar(Map<String, dynamic>? appBarConfig) {
  if (appBarConfig == null) return null;

  final titleConfig = appBarConfig['properties']?['title'];
  final actionsConfig = appBarConfig['properties']?['actions'] ?? [];

  return AppBar(
    backgroundColor: appBarConfig['properties']?['backgroundColor'] != null
        ? HexColor(appBarConfig['properties']['backgroundColor'])
        : null,
    elevation: appBarConfig['properties']?['elevation']?.toDouble() ?? 4.0,
    title: titleConfig != null
        ? Text(
            titleConfig['data'],
            style: titleConfig['style'] != null
                ? TextStyle(
                    fontSize: titleConfig['style']['fontSize']?.toDouble(),
                    fontWeight: titleConfig['style']['fontWeight'] == 'bold'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: titleConfig['style']['color'] != null
                        ? HexColor(titleConfig['style']['color'])
                        : null,
                  )
                : null,
          )
        : null,
    actions: actionsConfig.isNotEmpty
        ? actionsConfig.map<Widget>((action) {
            return IconButton(
              icon: UiHelper.getIcon(
                action['iconCode'],
                action['iconType'],
                color:
                    action['color'] != null ? HexColor(action['color']) : null,
              ),
              onPressed: () {},
            );
          }).toList()
        : null,
  );
}

//--RenderWidget--
Widget renderBody(Map<String, dynamic> widgetData) {
  switch (widgetData['type']) {
    case 'Row':
      return renderPadding(
        paddingConfig: widgetData['properties']['padding'] ?? {},
        child: Row(
          mainAxisAlignment: renderMainAxisAlignment(
              widgetData['properties']['mainAxisAlignment'] ?? 'start'),
          children: widgetData['items'] != null && widgetData['items'] is List
              ? (widgetData['items'] as List)
                  .map((item) => renderBody(item))
                  .toList()
              : [],
        ),
      );
    case 'Column':
      return renderPadding(
        paddingConfig: widgetData['properties']['padding'] ?? {},
        child: Column(
          mainAxisAlignment: renderMainAxisAlignment(
              widgetData['properties']['mainAxisAlignment'] ?? 'start'),
          crossAxisAlignment: renderCrossAxisAlignment(
              widgetData['properties']['crossAxisAlignment'] ?? 'start'),
          children:
              widgetData['children'] != null && widgetData['children'] is List
                  ? (widgetData['children'] as List)
                      .map((child) => renderBody(child))
                      .toList()
                  : [],
        ),
      );
    case 'Stack':
      return Stack(
        alignment: widgetData['properties']?['alignment'] != null
            ? renderAlignment(widgetData['properties']?['alignment'])
            : AlignmentDirectional.topStart,
        children:
            widgetData['children'] != null && widgetData['children'] is List
                ? (widgetData['children'] as List)
                    .map((child) => renderBody(child))
                    .toList()
                : [],
      );

    case 'Banner':
      return CarouselSlider(
        options: CarouselOptions(
          height: widgetData['properties']['height']?.toDouble(),
          autoPlay: widgetData['properties']['autoPlay'],
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction:
              widgetData['properties']['viewportFraction'].toDouble(),
        ),
        items: (widgetData["properties"]!["images"] as List).map((image) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widgetData['properties']?['borderRadius']?.toDouble() ??
                        10.0,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    case 'Text':
      return Text(
        widgetData['data'],
        textAlign:
            renderTextAlignment(alignment: widgetData['textAlign'] ?? 'left'),
        overflow: widgetData['overflow'] == null
            ? null
            : renderTextOverflow(widgetData['overflow']),
        maxLines: widgetData['maxLines'] != null
            ? int.tryParse(widgetData['maxLines'].toString())
            : null,
        style: widgetData['style'] == null
            ? null
            : TextStyle(
                fontSize: widgetData['style']['fontSize']?.toDouble(),
                fontWeight: widgetData['style']['fontWeight'] == "bold"
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: widgetData['style']['color'] == null
                    ? null
                    : HexColor(widgetData['style']['color']),
              ),
      );
    case 'padding':
      return Padding(
        padding: renderEdgeInsets(widgetData['properties']),
        child: widgetData.containsKey('child') && widgetData['child'] != null
            ? renderBody(widgetData['child'])
            : null,
      );
    case 'SizedBox':
      return SizedBox(
        height: widgetData["height"]?.toDouble(),
        width: widgetData["width"]?.toDouble(),
      );
    case 'Grid':
      return renderPadding(
        paddingConfig: widgetData['properties']?['padding'] ?? {},
        child: GridView.count(
          crossAxisCount: widgetData['properties']?['columns'],
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: widgetData['items'].map<Widget>((item) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UiHelper.getIcon(item["iconCode"], item["iconType"],
                    color: HexColor(widgetData['properties']?['iconColor'])),
                Text(
                  item['label'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widgetData['properties']?['labelColor'] == null
                        ? null
                        : HexColor(widgetData['properties']?['labelColor']),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    case 'Expanded':
      return Expanded(
        flex: widgetData['properties']?['flex'] ?? 1,
        child: renderBody(widgetData['child']),
      );
    case 'Center':
      return Center(
        child: widgetData['child'] != null
            ? renderBody(widgetData['child'] ?? {})
            : null,
      );
    case 'Card':
      return renderPadding(
        paddingConfig: widgetData['properties']?['padding'] ?? {},
        child: Card(
          elevation: widgetData['properties']?['elevation']?.toDouble() ?? 2.0,
          color: widgetData['properties']?['color'] != null
              ? HexColor(widgetData['properties']['color'])
              : null,
          child: widgetData['child'] != null
              ? renderBody(widgetData['child'] ?? {})
              : null,
        ),
      );
    case 'Container':
      return renderPadding(
        paddingConfig: widgetData['properties']['padding'] ?? {},
        child: Container(
          height: renderHeight(widgetData['properties']['height']),
          width: renderWidth(widgetData['properties']['width']),
          alignment:
              renderContainerAlignment(widgetData['properties']['alignment']),
          padding: widgetData['properties']?['padding'] != null
              ? EdgeInsets.only(
                  left: widgetData['properties']['padding']?['padding_left']
                          ?.toDouble() ??
                      0,
                  right: widgetData['properties']['padding']?['padding_right']
                          ?.toDouble() ??
                      0,
                  top: widgetData['properties']['padding']?['padding_top']
                          ?.toDouble() ??
                      0,
                  bottom: widgetData['properties']['padding']?['padding_bottom']
                          ?.toDouble() ??
                      0,
                )
              : EdgeInsets.all(
                  widgetData['properties']?['padding_all']?.toDouble() ?? 0,
                ),
          margin: EdgeInsets.only(
            left: widgetData['properties']?['margin_left']?.toDouble() ?? 0,
            right: widgetData['properties']?['margin_right']?.toDouble() ?? 0,
            top: widgetData['properties']?['margin_top']?.toDouble() ?? 0,
            bottom: widgetData['properties']?['margin_bottom']?.toDouble() ?? 0,
          ),
          decoration: BoxDecoration(
            borderRadius:
                renderBorderRadius(widgetData['properties']['borderRadius']),
            color: widgetData['properties']['color'] != null
                ? HexColor(widgetData['properties']['color'])
                : null,
            gradient: renderGradient(widgetData['properties']?['gradient']),
            boxShadow: widgetData['properties']?['boxShadow'] != null
                ? (widgetData['properties']['boxShadow'] as List)
                    .map(
                      (shadow) => BoxShadow(
                        color: HexColor(shadow['color'])
                            .withOpacity(shadow['opacity'] ?? 1.0),
                        blurRadius: shadow['blurRadius']?.toDouble() ?? 0,
                        spreadRadius: shadow['spreadRadius']?.toDouble() ?? 0,
                        offset: Offset(
                          shadow['offsetX']?.toDouble() ?? 0,
                          shadow['offsetY']?.toDouble() ?? 0,
                        ),
                      ),
                    )
                    .toList()
                : null,
            image: widgetData['properties']?['decorationImage'] != null
                ? renderDecorationImage(
                    widgetData['properties']?['decorationImage'],
                  )
                : null,
          ),
          child: widgetData['child'] != null
              ? renderBody(widgetData['child'] ?? {})
              : null,
        ),
      );
    case 'SingleChildScrollView':
      return renderPadding(
        paddingConfig: widgetData['properties']?['padding'] ?? {},
        child: SingleChildScrollView(
          scrollDirection:
              widgetData['properties']?['scrollDirection'] == 'horizontal'
                  ? Axis.horizontal
                  : Axis.vertical,
          child: widgetData.containsKey('child') && widgetData['child'] != null
              ? renderBody(widgetData['child'])
              : null,
        ),
      );
    case 'Icon':
      return UiHelper.getIcon(
        widgetData['iconCode'],
        widgetData['iconType'],
        color:
            widgetData['color'] != null ? HexColor(widgetData['color']) : null,
        size: widgetData['size']?.toDouble(),
      );
    case 'ListViewBuilder':
      return renderPadding(
        paddingConfig: widgetData['properties']['padding'] ?? {},
        child: SizedBox(
          height: widgetData['properties']['height']?.toDouble() ?? 0,
          child: ListView.builder(
            scrollDirection: widgetData['properties']?['scrollDirection'] ==
                    null
                ? Axis.vertical
                : widgetData['properties']?['scrollDirection'] == 'horizontal'
                    ? Axis.horizontal
                    : Axis.vertical,
            shrinkWrap: widgetData['properties']?['shrinkWrap'] ?? true,
            physics: widgetData['properties']?['physics'] == 'neverScrollable'
                ? const NeverScrollableScrollPhysics()
                : null,
            itemCount: widgetData['items']?.length ?? 0,
            itemBuilder: (context, index) {
              final item = widgetData['items'][index];
              return renderBody(item);
            },
          ),
        ),
      );
    case 'Align':
      return renderPadding(
        paddingConfig: widgetData['properties']?['padding'] ?? {},
        child: Align(
          alignment: renderAlignment(widgetData['properties']?['alignment']),
          child: widgetData.containsKey('child') && widgetData['child'] != null
              ? renderBody(widgetData['child'])
              : null,
        ),
      );
    case 'Image':
      final String? imageUrl = widgetData['properties']?['url'];
      final double? height = widgetData['properties']?['height']?.toDouble();
      final double? width = widgetData['properties']?['width']?.toDouble();
      final BoxFit? fit = renderBoxFit(widgetData['properties']?['fit']);
      if (imageUrl == null) {
        return const Icon(Icons.broken_image, color: Colors.red);
      }
      final imageWidget = imageUrl.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              height: height,
              width: width,
              fit: fit,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image, color: Colors.red),
            )
          : Image.asset(
              imageUrl,
              height: height,
              width: width,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.red);
              },
            );
      return imageWidget;
    case 'CachedNetworkImage':
      final String? imageUrl = widgetData['properties']?['url'];
      final BoxFit? fit =
          renderBoxFit(widgetData['properties']?['fit'] ?? 'cover');
      final Map<String, dynamic>? colorFilterConfig =
          widgetData['properties']?['colorFilter'];
      if (imageUrl == null) {
        return const Icon(Icons.broken_image, color: Colors.red);
      }
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
              colorFilter: colorFilterConfig != null
                  ? ColorFilter.mode(
                      HexColor(colorFilterConfig['color']),
                      BlendMode.values.firstWhere(
                        (mode) =>
                            mode.toString().split('.').last ==
                            colorFilterConfig['blendMode'],
                        orElse: () => BlendMode.color,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.error, color: Colors.red),
        ),
      );

    case 'ClipRRect':
      final double? borderRadius =
          widgetData['properties']?['borderRadius']?.toDouble() ?? 0.0;
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: widgetData['child'] != null
            ? renderBody(widgetData['child'])
            : const SizedBox.shrink(),
      );

    default:
      return const SizedBox.shrink();
  }
}
