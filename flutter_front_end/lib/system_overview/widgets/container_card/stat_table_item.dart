import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//ignore: must_be_immutable
class StatTableItem extends StatelessWidget {
  String? header = "";
  String body;
  String? trailer = "";
  Color? textColor = Colors.white;

  StatTableItem({
    this.header,
    required this.body,
    this.trailer,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "${header}: ",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          TextSpan(
            text: body,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.bold, color: this.textColor),
          ),
          TextSpan(
            text: " ${trailer}",
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
