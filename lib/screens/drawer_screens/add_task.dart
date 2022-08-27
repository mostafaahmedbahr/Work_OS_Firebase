import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:work_os_firebase/screens/task/tasks_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/consts.dart';
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var taskCategoryCon = TextEditingController();
  var taskTitleCon = TextEditingController();
  var taskDescriptionCon = TextEditingController();
  var taskDateCon = TextEditingController();
  var focusTaskCategory = FocusNode();
  var focusTaskTitle = FocusNode();
  var focusTaskDescription = FocusNode();
  var focusTaskDate = FocusNode();
  @override
  void dispose(){
    taskCategoryCon.dispose();
    taskTitleCon.dispose();
    taskDescriptionCon.dispose();
    taskDateCon.dispose();
    focusTaskCategory.dispose();
    focusTaskTitle.dispose();
    focusTaskDescription.dispose();
    focusTaskDate.dispose();
    super.dispose();
  }
  var formKey = GlobalKey<FormState>();
  DateTime? datePicked;
  // String? taskCategory;
Timestamp? taskDateTimeStamp;
  void addTask()async
  {
    final taskId = const Uuid().v4();
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid)
    {
      // await FirebaseFirestore.instance.collection("tasks").add({
      //   "taskCategory": taskCategoryCon.text,
      //   "taskTitle":taskTitleCon.text,
      //   "taskDescription":taskDescriptionCon.text,
      //   "taskDate":taskDateCon.text,
      // });
      User? user = FirebaseAuth.instance.currentUser;
      String _uid = user!.uid;
      try{
        await FirebaseFirestore.instance.collection("tasks").doc(taskId).set({
          "taskId": taskId,
          "uploadedBy": _uid,
          "taskCategory": taskCategoryCon.text,
          "taskTitle":taskTitleCon.text,
          "taskDescription":taskDescriptionCon.text,
          "taskDate":taskDateCon.text,
          "taskDateTimeStamp": taskDateTimeStamp,
          "taskComments":[],
          "isDone":false,
          "createdAt":Timestamp.now(),
        });
        Fluttertoast.showToast(
            msg: "task is uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        taskDateCon.clear();
        taskCategoryCon.clear();
        taskTitleCon.clear();
        taskDescriptionCon.clear();
      }
          catch(error)
          {
            print("error in add task to firebase ${error.toString()}");
          }
    }
    else
    {
      print("error");
    }

  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Card(
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:   [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("All Field Are Required",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                      const Divider(thickness: 2,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            const Text("Task Category *",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(height:height*0.01),
                            InkWell(
                              onTap: () {
                                   showDialog(
                                  // عشان لما اضغط على اى حاجه خارجه ميقفلوش
                                    barrierDismissible: false,
                                    // اغير لون الخلفية
                                    // barrierColor: Colors.red,
                                    context: context,
                                    builder: (context)
                                    {
                                      return    AlertDialog(
                                        title: Text("Tasks Category",
                                          style: TextStyle(
                                            color: Colors.pink.shade300,
                                            fontSize: 20,
                                          ),),
                                        content: SizedBox(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: Constants.listTasks.length,
                                              itemBuilder: (context,index)
                                              {
                                                return InkWell(
                                                  onTap: ()
                                                  {
                                                    setState(() {
                                                      taskCategoryCon.text = Constants.listTasks[index];
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.check_circle_rounded,
                                                            color: Colors.pink[200],),
                                                          const SizedBox(width: 5,),
                                                          Text(Constants.listTasks[index],
                                                            style: const TextStyle(
                                                              fontSize: 18,
                                                              fontStyle: FontStyle.italic,
                                                              color: Color(0xff00325A),
                                                            ),),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            }, child: const Text("Cancel"),
                                          ),

                                        ],
                                      );
                                    }
                                );

                              },
                              child: TextFormField(
                                controller: taskCategoryCon,
                                validator: (val)
                                {
                                  if(val!.isEmpty)
                                  {
                                    return "Field is missing";
                                  }
                                  return null;
                                },
                                enabled: false,
                                key: const ValueKey("hello"),
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:  InputDecoration(
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                                  filled: true,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.pink.shade700,
                                      )
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      )
                                  ),
                                  hintText: "Task Category",
                                  hintStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                  enabledBorder:   UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:Theme.of(context).scaffoldBackgroundColor,
                                      )
                                  ),

                                ),
                                focusNode: focusTaskTitle,
                                onEditingComplete: (){
                                  FocusScope.of(context).requestFocus(focusTaskDescription);
                                },
                              ),
                            ),
                            SizedBox(height:height*0.02),
                            const Text("Task Title *",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(height:height*0.01),
                            TextFormField(
                              maxLines: 1,
                              maxLength: 100,
                              controller: taskTitleCon,
                              validator: (val)
                              {
                                if(val!.isEmpty)
                                {
                                  return "Title is missing";
                                }
                                return null;
                              },
                              enabled: true,
                              key: const ValueKey("hello2"),
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration:  InputDecoration(
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                filled: true,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.pink.shade700,
                                    )
                                ),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    )
                                ),
                                enabledBorder:   UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:Theme.of(context).scaffoldBackgroundColor,
                                    )
                                ),

                              ),
                              focusNode: focusTaskCategory,
                              onEditingComplete: (){
                                FocusScope.of(context).requestFocus(focusTaskTitle);
                              },


                            ),
                            SizedBox(height:height*0.02),
                            const Text("Task Description *",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(height:height*0.01),
                            TextFormField(
                              maxLines: 4,
                              maxLength: 1000,
                              controller: taskDescriptionCon,
                              validator: (val)
                              {
                                if(val!.isEmpty)
                                {
                                  return "description is missing";
                                }
                                return null;
                              },
                              enabled: true,
                              key: const ValueKey("hello3"),
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration:  InputDecoration(
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                filled: true,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.pink.shade700,
                                    )
                                ),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    )
                                ),
                                enabledBorder:   UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:Theme.of(context).scaffoldBackgroundColor,
                                    )
                                ),

                              ),
                              focusNode: focusTaskDescription,
                              onEditingComplete: (){
                                FocusScope.of(context).requestFocus(focusTaskDate);
                              },
                            ),
                            SizedBox(height:height*0.02),
                            const Text("Task DeadLine Date *",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(height:height*0.01),
                            InkWell(
                              onTap: ()async
                              {
                              datePicked =  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2030),
                                );
                              if(datePicked != null)
                              {
                                setState(() {
                                  // عشان احول صيغه الوقت
                                  taskDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(datePicked!.microsecondsSinceEpoch);
                                  taskDateCon.text =  "${datePicked?.year} / ${datePicked?.month} / ${datePicked?.day}";
                                });
                              }
                               },
                              child: TextFormField(
                                maxLines: 1,
                                maxLength: 100,
                                controller: taskDateCon,
                                validator: (val)
                                {
                                  if(val!.isEmpty)
                                  {
                                    return "Date is missing";
                                  }
                                  return null;
                                },
                                enabled: false,
                                key: const ValueKey("hello4"),
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:  InputDecoration(
                                  hintText: "Pick Up Date",
                                  hintStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                                  filled: true,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.pink.shade700,
                                      )
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      )
                                  ),
                                  enabledBorder:   UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:Theme.of(context).scaffoldBackgroundColor,
                                      )
                                  ),

                                ),
                                focusNode: focusTaskDate,
                                // onEditingComplete: (){
                                //   FocusScope.of(context).requestFocus(focusTaskDate);
                                // },
                              ),
                            ),
                            SizedBox(height:height*0.03),
                            Center(
                              child: MaterialButton(
                                color: Colors.pink.shade700,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () async{
                                  addTask();
                                  await Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context)
                                  {
                                    return const TasksScreen();
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Save",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      SizedBox(width: 10,),
                                      Icon(Icons.upload_file_outlined,
                                        color: Colors.white,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height:height*0.03),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
          ),
          ),
      ),
    );
  }
}
