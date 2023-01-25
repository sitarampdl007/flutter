import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Widget [TaskButtons] : The TaskButtons for showing various order state taps
class TaskButtons extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color btnColor;
  final bool isLoading;

  const TaskButtons(
      {Key key, this.title, this.onTap, this.btnColor, this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: btnColor,
              disabledColor: LendenAppTheme.deactivatedText,
              child: Container(
                alignment: Alignment.center,
                child: isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
                    : Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white)),
              ),
              onPressed: isLoading ? null : onTap),
        ),
        const Spacer(),
      ],
    );
  }
}
