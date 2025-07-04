import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class HomeService {
  void selectPageView(int index, {BuildContext context});
  Future<void> verifyLocation();
  Future<void> modalBottomSheetMenu(BuildContext context);
}
