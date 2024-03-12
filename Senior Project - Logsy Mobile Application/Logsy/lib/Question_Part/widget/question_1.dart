import 'package:flutter/material.dart';

class Question1 extends StatelessWidget {

  Widget buildTextForm(TextInputType input, Icon icon, String label) {
    return TextFormField(
      cursorRadius: Radius.circular(15),
      keyboardType: input,
      decoration: InputDecoration(
        icon: icon,
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue[200],
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue[100],
            width: 1.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Step 1/6",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 50,
                ),
              ),
              SizedBox(height: 30),
              buildTextForm(TextInputType.text, Icon(Icons.person), "Name"),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: buildTextForm(
                        TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        Icon(Icons.height),
                        "Height"),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildTextForm(
                        TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        Icon(Icons.line_weight),
                        "Weight"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
