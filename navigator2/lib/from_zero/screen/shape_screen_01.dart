/*
 * Copyright 2020 Cagatay Ulusoy (Ulus Oy Apps). All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:navigator2/from_zero/model/model.dart';

import '../widgets/app_bar_back_button.dart';
import '../widgets/shaped_button.dart';

class ShapeScreen extends StatelessWidget {
  final String colorCode;
  final ShapeBorderType shapeBorderType;

  Color get color => colorCode.hexToColor();

  const ShapeScreen({
    Key? key,
    required this.colorCode,
    required this.shapeBorderType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppBarText(
            appBarColor: color,
            text:
                '${shapeBorderType.stringRepresentation().toUpperCase()} #$colorCode ',
          ),
          leading: AppBarBackButton(color: color),
          backgroundColor: color,
        ),
        body: Center(
          child: ShapedButton(
            color: color,
            shapeBorderType: shapeBorderType,
          ),
        ));
  }
}
