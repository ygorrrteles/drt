import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplyCleanButtons extends StatelessWidget {

  final Function cleanButton;
  final Function applyButton;

  const ApplyCleanButtons({this.cleanButton, this.applyButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Get.width * 0.4,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FlatButton(
              onPressed: applyButton,
              child: Text(
                "Limpar",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: Get.width * 0.4,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FlatButton(
              color: Colors.blueAccent,
              onPressed: cleanButton,
              child: Text(
                "Aplicar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
