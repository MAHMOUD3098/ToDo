import 'package:flutter/material.dart';
import 'package:todo/presentation/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(CustomColors.kGreenColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15)),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: CustomColors.kWhiteColor),
          ),
        ),
      ),
    );
  }
}
