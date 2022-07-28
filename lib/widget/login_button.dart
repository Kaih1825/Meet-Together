import 'package:flutter/material.dart';
import '../utils/color.dart';
import '../main.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class login_button extends StatefulWidget {
  final String application;
  final Function() onPressed;
  const login_button({
    Key? key,
    required this.application,
    required this.onPressed,
  }) : super(key: key);
  @override
  State<login_button> createState() => _login_buttonState();
}

class _login_buttonState extends State<login_button> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 100),
      onPressed: widget.onPressed,
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0.8),
                child: Text(
                  widget.application,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
