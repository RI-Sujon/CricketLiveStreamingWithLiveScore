import 'package:flutter/material.dart';

class CustomOptionButton extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;
  const CustomOptionButton(
      {Key? key, required this.innerText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.6,
      decoration: BoxDecoration(
        // color: const Color(0xff233743),
        color: Color.fromARGB(255, 46, 77, 96),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(6.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          innerText,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
