import 'package:flutter/material.dart';
void alert(BuildContext context) {
  showDialog(
    // عشان لما اضغط على اى حاجه خارجه ميقفلوش
      barrierDismissible: true,
      // اغير لون الخلفية
      // barrierColor: Colors.red,
      context: context,
      builder: (context)
      {
        return   AlertDialog(
          actions: [
            TextButton(
              onPressed: (){

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete,
                  color: Colors.pink,),
                  SizedBox(width: 5,),
                  Text("Delete",
                  style: TextStyle(
                    color: Colors.pink,
                  ),),
                ],
              ),
            ),
          ],
        );
      }
  );
}