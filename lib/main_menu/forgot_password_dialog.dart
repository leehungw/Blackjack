import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatefulWidget {
  TextEditingController emailForgotPasswordController = TextEditingController();
  ForgotPasswordDialog(
      {super.key, required this.emailForgotPasswordController});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Wrap(children: [
        Container(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors: const [Color(0xFF5D0000), Color(0xFFD40000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(
            children: [
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 38, left: 32),
                    child: Text(
                      "Enter your email:",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 13, right: 32),
                child: TextField(
                  controller: widget.emailForgotPasswordController,
                  keyboardType: TextInputType.emailAddress,
                  // onTap: () =>
                  //     {firstEnterEmailTF = true},
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Color(0xFF97FF9B)),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                    filled: true,
                    fillColor: Color.fromARGB(80, 217, 217, 217),
                    // enabledBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(width: 0, color: Colors.black),
                    //     borderRadius: BorderRadius.circular(10)),
                    // focusedBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(width: 1, color: Colors.black),
                    //     borderRadius: BorderRadius.circular(10)),
                    helperText: " ",
                  ),
                  obscureText: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, left: 32, right: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xFF969292),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Color(0xFF969292)),
                        ),
                      ),
                      child: SizedBox(
                          width: 70, child: Center(child: Text('Cancel'))),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: handle confirm forgot pw logic
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF440682),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Color(0xFF440682)),
                        ),
                      ),
                      child: SizedBox(
                          width: 70, child: Center(child: Text('Confirm'))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}
