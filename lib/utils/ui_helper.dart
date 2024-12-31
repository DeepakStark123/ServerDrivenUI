import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UiHelper {
  //--------Get-Icons-From-Code-------
  static FaIcon getIcon(String iconCode, String iconType,
      {Color? color, double? size}) {
    return FaIcon(
      color: color,
      size: size,
      iconType == "Regular"
          ? IconDataRegular(int.parse(
              iconCode.isEmpty ? "0xf192" : "0x${iconCode.toString()}",
            ))
          : iconType == "Brands"
              ? IconDataBrands(int.parse(
                  iconCode.isEmpty ? "0xf192" : "0x${iconCode.toString()}",
                ))
              : IconDataSolid(
                  int.parse(
                    iconCode.isEmpty ? "0xf192" : "0x${iconCode.toString()}",
                  ),
                ),
    );
  }
}
