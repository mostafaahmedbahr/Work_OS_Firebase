import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/task/details_task.dart';
import 'alart.dart';
class TaskWidgetScreen extends StatefulWidget {
  final String title;
  final String description;
  final String taskId;
  final String uploadedBy;
  final bool isDone;

  // String? taskState;
    TaskWidgetScreen({Key? key ,
    required this.description,
    required this.title,
     required this.taskId,required this.uploadedBy,required this.isDone,
    }) : super(key: key);

  @override
  State<TaskWidgetScreen> createState() => _TaskWidgetScreenState();
}

class _TaskWidgetScreenState extends State<TaskWidgetScreen> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
      builder: (context,snapShot)
      {
        return Card(
          child: ListTile(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
              {
                return   DetaiLsTaskScreen(
                  taskId: widget.taskId,
                  uploadedBy: widget.uploadedBy,
                );
              }));
            },
            onLongPress: (){
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
                            User? user = FirebaseAuth.instance.currentUser;
                            String _uid = user!.uid;
                            if(_uid == widget.uploadedBy)
                            {
                              FirebaseFirestore.instance.collection("tasks")
                                  .doc(widget.taskId).delete();
                              Navigator.pop(context);
                            }
                            else
                            {
                              Fluttertoast.showToast(
                                msg: "you can not delete this task",
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                                gravity: ToastGravity.CENTER,
                              );
                            }

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
            },
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10
            ),
            leading: Container(
              padding: const EdgeInsets.only(right: 20),
              decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1),
                  )
              ),
              child: CircleAvatar(
                // https://media.istockphoto.com/vectors/load-completed-progress-icon-isolated-on-white-background-vector-vector-id949850430?k=20&m=949850430&s=612x612&w=0&h=PZT7T3HhbT0Eq1O7qnBGLZ4xoyPWGjxXLYhGyVaNEjU=
                radius: 20,
                backgroundColor: Colors.transparent,
                child:widget.isDone ?  Image.network("https://uxwing.com/wp-content/themes/uxwing/download/checkmark-cross/tick-green-icon.png")
                    :Image.network("https://cdn-icons-png.flaticon.com/512/690/690399.png?w=740&t=st=1661530780~exp=1661531380~hmac=4d39e548ff2daa5106009a8f1c62e0a93021e8530f30e88f6e548cf58c766eac"),
              ),
            ),
            title:  Text(widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:const TextStyle(
                fontWeight: FontWeight.bold,
              ),),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.linear_scale,
                  color: Colors.pink[800],),
                Text(widget.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:const TextStyle(
                    fontSize: 16,
                  ),),
              ],
            ),
            trailing:   Icon(Icons.keyboard_arrow_right,
              color: Colors.pink[800],),
          ),

        );
      },

    );
  }
}
