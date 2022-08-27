import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:work_os_firebase/screens/drawer_screens/workers_details.dart';

 import '../../widgets/workers_widget.dart';
import '../task/tasks_screen.dart';
class AllWorkersScreen extends StatefulWidget {
  const AllWorkersScreen({Key? key}) : super(key: key);

  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('All Workers',
          style: TextStyle(
            color: Colors.pink,
          ),),
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
      body: StreamBuilder<dynamic>(
        stream:FirebaseFirestore.instance.collection("workers").snapshots(),
        builder: (context,snapShot){
          if(snapShot.hasError)
          {
            print("Error in get workers data");
          }
          else if(snapShot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                    return     WorkersWidgetScreen(
                      name: snapShot.data!.docs[index]['name'],
                      img: snapShot.data!.docs[index]['userImageUrl'],
                      position: snapShot.data!.docs[index]['position'],
                      email: snapShot.data!.docs[index]['email'],
                      id: snapShot.data!.docs[index]['id'],
                    );
                  });
            }
            else{
              return const Center(child: Text("no workers"),);
            }
          }
          return const Text("");
        },
      ),
    );
  }
}
