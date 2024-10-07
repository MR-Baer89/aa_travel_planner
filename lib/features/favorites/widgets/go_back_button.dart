import 'package:flutter/material.dart';

class goBackButton extends StatelessWidget {
  const goBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[600]),
      child: const Text(
        'Go Back',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
