import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:work_os_firebase/screens/task/tasks_screen.dart';

import '../../widgets/comment_widget.dart';
class DetaiLsTaskScreen extends StatefulWidget {
  const DetaiLsTaskScreen({Key? key,
    required this.taskId,required this.uploadedBy,

  }) : super(key: key);
  final String taskId;
  final String uploadedBy;

  @override
  State<DetaiLsTaskScreen> createState() => _DetaiLsTaskScreenState();
}

class _DetaiLsTaskScreenState extends State<DetaiLsTaskScreen> {

  var commentCon = TextEditingController();
  bool isCommented = false;
    String? authorName;
  String? authorPosition;
  String? authorImage;
  String? taskDescription;
    String? taskTitle;
    bool? taskState;
    Timestamp? postedDateTimeStamp;
    Timestamp? deadLineDateTimeStamp;
    String? postedDate;
  String? deadLineDate;
  bool isDeadLineAvailable = false;
  bool isLoading = true;

  @override
  void initState() {
    getData1();
    getData2();
     super.initState();
  }

  void getData1()async
  {
    isLoading = true;
    try
    {
      var taskDetailsRef =await FirebaseFirestore.instance.collection("workers")
          .doc(widget.uploadedBy).get();
      if(taskDetailsRef != null)
      {
        setState(() {
          authorName = taskDetailsRef.get("name");
          authorPosition =  taskDetailsRef.get("position");
          authorImage =  taskDetailsRef.get("userImageUrl");
        });
      }
      else
      {
        return;
      }
    }catch(error)
    {
      print("error in get data1 ${error.toString()}");
    }
    finally
    {
      isLoading = false;
    }

  }

  void getData2()async
  {
    isLoading = true;
    try
    {
      var taskDetailsRef2 =await FirebaseFirestore.instance.collection("tasks")
          .doc(widget.taskId).get();
      if(taskDetailsRef2 != null)
      {
        setState(() {
          taskState = taskDetailsRef2.get("isDone");
          deadLineDate = taskDetailsRef2.get("taskDate");
          deadLineDateTimeStamp = taskDetailsRef2.get("taskDateTimeStamp");
          postedDateTimeStamp =taskDetailsRef2.get("createdAt");
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = "${postDate.year} / ${postDate.month} / ${postDate.day}";
          var endDate = deadLineDateTimeStamp!.toDate();
          // deadLineDate = "${endDate.year} / ${endDate.month} / ${endDate.day}";
          isDeadLineAvailable = endDate.isAfter(DateTime.now());
          taskTitle = taskDetailsRef2.get("taskTitle");
          taskDescription = taskDetailsRef2.get("taskDescription");


        });
      }
      else
      {
        return;
      }
    }catch(error){
      print("error in get data2 ${error.toString()}");
    }
    finally
    {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text("Details",
        style: TextStyle(
          color: Colors.pink,
        ),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
            {
              return const TasksScreen();
            }));
          },
          icon: const Icon(Icons.arrow_back,
            color: Colors.black87,),
        ),
      ),
      body:isLoading ? const Center(child: CircularProgressIndicator(),): SingleChildScrollView(
        child: Column(
          children:  [
            const SizedBox(height: 15,),
             Align(
              alignment: Alignment.topCenter,
              child: Text(taskTitle == null ? "" : taskTitle!,
              style:const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.lightBlue,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Uploaded By",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),),
                          const Spacer(),
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration:     BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.pink,
                                      ),
                                      shape: BoxShape.circle,
                                      image:   DecorationImage(
                                        image:authorImage == null?  const NetworkImage("https://img.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg?w=740&t=st=1661281139~exp=1661281739~hmac=4b7ff98060aea6f4c59fd0612f8cbb307fad290445b0cd315a43a32660dd0610",
                                        ): NetworkImage(authorImage!),
                                      ),
                                    ),

                                  ),
                                ],
                              ),
                              const SizedBox(width: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  Text(authorName!,
                                    style:const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.lightBlue,
                                    ),),
                                  Text(authorPosition!,
                                    style:const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.lightBlue,
                                    ),),
                                ],
                              ),
                              const SizedBox(width: 15,),
                            ],
                          ),

                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Divider(
                        thickness: 2,

                      ),
                    ),
                    Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children:  [
                               const Text("Uploaded On : ",
                                 style: TextStyle(
                                   fontSize: 22,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black87,
                                 ),),
                               Text(postedDate==null ? "" : postedDate!,
                                 style:const TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.normal,
                                   color: Colors.lightBlue,
                                 ),),
                             ],
                           ),
                           const SizedBox(height: 5,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children:  [
                               const Text("DeadLine Date: ",
                                 style: TextStyle(
                                   fontSize: 22,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black87,
                                 ),),
                               Text(deadLineDate==null ? "" : deadLineDate!,
                                 style:const TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.normal,
                                   color: Colors.red,
                                 ),),
                             ],
                           ),
                           const SizedBox(height: 5,),
                             Text(isDeadLineAvailable ? "Still Have Time" : "no time left",
                           style:  TextStyle(
                             color:isDeadLineAvailable ? Colors.green :Colors.red,

                           ),),
                         ],
                       ),
                     ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Divider(
                        thickness: 2,

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: const [
                          Text("Done State : ",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children:  [
                            TextButton(onPressed: (){
                              User? user = FirebaseAuth.instance.currentUser;
                              String _uid = user!.uid;
                              if(_uid == widget.uploadedBy)
                              {
                                setState(() {
                                  FirebaseFirestore.instance.collection("tasks").doc(widget.taskId).update({
                                    "isDone": true,
                                  });
                                  getData2();
                                });
                              }
                            },
                                child:  Text("Done",
                                  style: TextStyle(
                                    decoration:taskState==true? TextDecoration.underline :TextDecoration.none,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue,
                                  ),),
                            ),
                          Opacity(
                            opacity:taskState==true? 1 : 0,
                            child:const Icon(Icons.check_box,
                            color: Colors.green,),
                          ),
                          const  SizedBox(width: 40,),
              TextButton(onPressed: (){
                User? user = FirebaseAuth.instance.currentUser;
                String _uid = user!.uid;
                if(_uid == widget.uploadedBy)
                {
                  setState(() {
                    FirebaseFirestore.instance.collection("tasks").doc(widget.taskId).update({
                      "isDone": false,
                    });
                    // عشان التغيير يبان لحظيا على الشاشة
                    getData2();
                  });
                }

              },
                  child: Text("Not Done Yet",
                    style: TextStyle(
                      decoration:taskState==false? TextDecoration.underline :TextDecoration.none,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),),
              ),
                          Opacity(
                            opacity:taskState==false? 1 : 0 ,
                            child:const Icon(Icons.check_box,
                              color: Colors.red,),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Divider(
                        thickness: 2,

                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Task Description : ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),),
                    ),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      child: Text(taskDescription==null? "" : taskDescription!,
                        style:const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.lightBlue,
                        ),),
                    ),
                     AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                      child: isCommented ?  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (val)
                              {
                                if(val!.isEmpty)
                                {
                                  return "comment is not valid";
                                }
                                return null;
                              },
                              maxLength: 200,
                              maxLines: 6,
                              controller: commentCon,
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Comment",
                                hintStyle: const TextStyle(
                                  color: Colors.black87,
                                ),
                                filled: true,
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      )
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.pink,
                                      )
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      )
                                  )

                              ),
                            ),
                          ),
                          ),
                          Column(
                             children: [
                              MaterialButton(
                                color: Colors.pink.shade700,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                onPressed: ()async{
                                  if(commentCon.text.isNotEmpty)
                                  {
                                    var user = FirebaseAuth.instance.currentUser;
                                    print(user?.uid);
                                    final DocumentSnapshot userRef = await FirebaseFirestore.instance
                                        .collection("workers")
                                        .doc(user?.uid).get();
                                     final genUid = const Uuid().v4();
                                    await FirebaseFirestore.instance.collection("tasks")
                                        .doc(widget.taskId).update({
                                      "taskComments": FieldValue.arrayUnion([{
                                        "userId" : user!.uid,
                                        "commentId" : genUid,
                                        "name" : userRef.get("name"),
                                        "userImg" : userRef.get("userImageUrl"),
                                        "commentBody" : commentCon.text,
                                        "commentAt" : Timestamp.now(),
                                      }]),
                                    });
                                    commentCon.clear();
                                  }
                                  else
                                  {
                                    Fluttertoast.showToast(
                                        msg: "you must put your comment",
                                        toastLength: Toast.LENGTH_LONG,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      gravity: ToastGravity.BOTTOM_LEFT,
                                    );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text("Post",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                ),
                              ),
                              TextButton(
                                  onPressed: (){
                                    setState(() {
                                      isCommented = !isCommented;
                                    });
                                  },
                                  child: const Text("Cancel"),
                              ),
                            ],
                          ),
                        ],
                      ) :
                      Center(
                        child: MaterialButton(
                          color: Colors.pink.shade700,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          onPressed: (){
                            setState(() {
                              isCommented = !isCommented;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Text("Comment",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<dynamic>(
                      stream: FirebaseFirestore.instance.collection("tasks").doc(widget.taskId).snapshots(),
                        builder:(context,snapShot){
                          if(snapShot.hasError)
                          {
                            print("Error in get comments data");
                          }
                          else if (snapShot.data == null)
                          {
                            return Container();
                          }
                          else if(snapShot.connectionState == ConnectionState.waiting)
                          {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          else if(snapShot.connectionState == ConnectionState.active)
                          {
                            if(snapShot.data!["taskComments"].isNotEmpty){
                              return ListView.separated(
                                reverse: true,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index)
                                {

                                  return   CommentWidget(
                                    comment: snapShot.data!["taskComments"][index]["commentBody"],
                                    img: snapShot.data!["taskComments"][index]["userImg"],
                                    name: snapShot.data!["taskComments"][index]["name"],
                                    commentId: snapShot.data!["taskComments"][index]["commentId"],
                                    nameId: snapShot.data!["taskComments"][index]["userId"],
                                  );
                                },
                                separatorBuilder: (context,index)
                                {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Divider(
                                      thickness: 2,

                                    ),
                                  );
                                },
                                itemCount: snapShot.data!["taskComments"].length,
                              );
                            }
                            else{
                              return const Center(child: Text("no comments yet"),);
                            }
                          }
                          return const Text("");
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
