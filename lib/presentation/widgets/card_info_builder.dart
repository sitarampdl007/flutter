import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'text_with_icon.dart';

///Widget [CardInfoBuilder] : To build card info for simple view
class CardInfoBuilder extends StatelessWidget {
  final Widget description;
  final String title;
  final IconData iconType;

  const CardInfoBuilder(
      {@required this.description,
      @required this.title,
      @required this.iconType});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 12, right: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithIcon(
              padding: const EdgeInsets.all(0),
              text: title,
              icon: Icon(
                iconType,
                size: 20,
              ),
              textStyle: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: LendenAppTheme.grey),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.012,
            ),
            description
          ],
        ),
      ),
    );
  }
}
