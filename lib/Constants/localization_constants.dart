import 'package:flutter/cupertino.dart';
import 'package:order/Localization/localization.dart';

String getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context).getTranslatedValue(key);
}
