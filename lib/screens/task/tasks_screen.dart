import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_os_firebase/constants/consts.dart';
import 'package:work_os_firebase/screens/auth/login_screen.dart';
import 'package:work_os_firebase/screens/drawer_screens/add_task.dart';
import 'package:work_os_firebase/screens/drawer_screens/all_workers.dart';

import '../../widgets/task_widget.dart';
import '../drawer_screens/my_account.dart';

class TasksScreen extends StatefulWidget {
    const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

    void _handleMenuButtonPressed() {
        _advancedDrawerController.showDrawer();
    }

     String? taskCategoryFilter;
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.grey[300],
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text('Tasks',
          style: TextStyle(
            color: Colors.pink,
          ),),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                    color: Colors.black87,
                  ),
                );
              },
            ),
          ),
          actions: [
            IconButton(
                onPressed: (){
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
                            // height: ,
                            // width: ,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: Constants.listTasks.length,
                                itemBuilder: (context,index)
                                {
                                  return InkWell(
                                    onTap: ()
                                    {
                                      setState(() {
                                        taskCategoryFilter = Constants.listTasks[index];
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
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
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  taskCategoryFilter =null;
                                  Navigator.pop(context);
                                });
                               },
                              child: const Text("Cancel Filter"),
                            ),
                          ],
                        );
                      }
                  );
                },
                icon: const Icon(Icons.filter_list,
                color: Colors.black87,),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("tasks")
          .orderBy("createdAt",descending: false)
              .where("taskCategory", isEqualTo: taskCategoryFilter).snapshots(),
          builder: (context,snapShot)
          {
            if(snapShot.connectionState == ConnectionState.waiting)
            {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapShot.data == null)
            {
              return Container();
            }
            else if(snapShot.connectionState == ConnectionState.active)
            {
              if(snapShot.data!.docs.isNotEmpty)
              {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapShot.data!.docs.length,
                    itemBuilder: (context,index)
                    {
                      return   TaskWidgetScreen(
                        title: snapShot.data!.docs[index]["taskTitle"],
                        description: snapShot.data!.docs[index]['taskDescription'],
                        taskId: snapShot.data!.docs[index]['taskId'],
                        isDone: snapShot.data!.docs[index]['isDone'],
                        uploadedBy: snapShot.data!.docs[index]['uploadedBy'],
                        );
                    });
              }
              else{
                return const Center(child: Text("no tasks"),);
              }
            }
            return const Text("");
          },
        ),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.black87,
          iconColor: Colors.black87,
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Column(
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 20.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const Text("Mostafa Bahr",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                const Text("flutter developer at eraa soft campany"),
              ],
            ),
            const SizedBox(height: 40,),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                {
                  return const TasksScreen();
                }));
              },
              leading: const Icon(Icons.task_outlined),
              title: const Text('All Tasks'),
            ),
            ListTile(
              onTap: () {
                User? user = FirebaseAuth.instance.currentUser;
                String uid = user!.uid;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                {
                  return   MyProfileScreen(userId:uid);
                }));
              },
              leading: const Icon(Icons.settings_outlined),
              title: const Text('My Account'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                {
                  return const AllWorkersScreen();
                }));
               },
              leading: const Icon(Icons.workspaces_outline),
              title: const Text('Registered Workers'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                {
                  return const AddTaskScreen();
                }));
              },
              leading: const Icon(Icons.add_task_outlined),
              title: const Text('Add Task'),
            ),
            const Divider(thickness: 1,),
            ListTile(
              onTap: () {
                showDialog(
                  // عشان لما اضغط على اى حاجه خارجه ميقفلوش
                    barrierDismissible: false,
                    // اغير لون الخلفية
                    // barrierColor: Colors.red,
                    context: context,
                    builder: (context)
                    {
                      return   AlertDialog(
                        title: Row(
                          children: const [
                            Icon(Icons.logout_outlined,
                            color: Colors.lightBlue,),
                            SizedBox(width: 5,),
                            Text("Sign Out",
                            style: TextStyle(
                              fontSize: 16,
                            ),),
                          ],
                        ),
                        content: const Text("Do You Want to sign out ?",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),),
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            }, child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: ()async{
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                              {
                                return const LoginScreen();
                              }));
                            },
                            child: const Text("Ok",
                            style: TextStyle(
                              color: Colors.pink
                            ),),
                          ),
                        ],
                      );
                    }
                );
              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Log Out'),
            ),
            // const Spacer(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         color: Colors.black87,
            //       ),
            //       height: 40,
            //       width: 40,
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: const FaIcon(FontAwesomeIcons.linkedinIn),
            //         color: Colors.white,
            //         iconSize: 20,
            //       ),
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         color: Colors.black87,
            //       ),
            //       height: 40,
            //       width: 40,
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: const FaIcon(FontAwesomeIcons.youtube),
            //         color: Colors.white,
            //         iconSize: 20,
            //       ),
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         color: Colors.black87,
            //       ),
            //       height: 40,
            //       width: 40,
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: const FaIcon(FontAwesomeIcons.instagram),
            //         color: Colors.white,
            //         iconSize: 20,
            //       ),
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         color: Colors.black87,
            //       ),
            //       height: 40,
            //       width: 40,
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: const FaIcon(FontAwesomeIcons.twitter),
            //         color: Colors.white,
            //         iconSize: 20,
            //       ),
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         color: Colors.black87,
            //       ),
            //       height: 40,
            //       width: 40,
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: const FaIcon(FontAwesomeIcons.tiktok),
            //         color: Colors.white,
            //         iconSize: 20,
            //       ),
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //         color: Colors.black87,
            //       ),
            //       height: 40,
            //       width: 40,
            //       child: IconButton(
            //         onPressed: () {},
            //         icon: const FaIcon(FontAwesomeIcons.facebookF),
            //         color: Colors.white,
            //         iconSize: 20,
            //       ),
            //     ),
            //   ],
            // ),
            // const Spacer(),
          ]),
        ),
      ),
    );
  }
}




