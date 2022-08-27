import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/login_screen.dart';
import '../task/tasks_screen.dart';
class WorkersProfileScreen extends StatefulWidget {
  const WorkersProfileScreen({Key? key,required this.userId}) : super(key: key);
  //   عشان اجيب بيانات المستخدم الفعلى لازم امبرر ال uid من خلال ال currentUser
  final String userId;
  @override
  State<WorkersProfileScreen> createState() => _WorkersProfileScreenState();
}

class _WorkersProfileScreenState extends State<WorkersProfileScreen> {

  // phone call
  // static var phoneNumber1 = "01124032088";
  // final Uri url1 = Uri.parse('tel:+$phoneNumber1');
  Future<void> calling()async
  {
    final Uri url1 = Uri.parse('tel:+$userNumber');
    if (!await launchUrl(url1)) {
      throw 'Could not launch $url1';
    }
  }
  // whats app
  // static var phoneNumber2 = "01124032088";
  // final Uri url2 = Uri.parse('whatsapp://send?phone=+2$phoneNumber2');
  Future<void> openWhatsAppChat()async
  {
    final Uri url2 = Uri.parse('whatsapp://send?phone=+2$userNumber');
    if (!await launchUrl(url2)) {
      throw 'Could not launch $url2';
    }
  }
  //messenger
  static var emailMessengerLink = "xyzchannelxyz";
  final Uri url3 = Uri.parse('https://m.me/$emailMessengerLink');
  Future<void> messenger()async
  {
    if (!await launchUrl(url3)) {
      throw 'Could not launch $url3';
    }
  }
  //sms
  // static var phoneNumber4 = "xyzchannelxyz";
  // final Uri url4 = Uri.parse('sms:+$phoneNumber4');
  Future<void> sms()async
  {
    final Uri url4 = Uri.parse('sms:+$userNumber');
    if (!await launchUrl(url4)) {
      throw 'Could not launch $url4';
    }
  }
  //email
  // static var mailto = userEmail;
  // final Uri url5 = Uri.parse("mailto:$mailto");
  Future<void> email()async
  {
    final Uri url5 = Uri.parse("mailto:$userEmail");
    if (!await launchUrl(url5)) {
      throw 'Could not launch $url5';
    }
  }

  bool isLoading = false;
  String userName="";
  String userEmail="";
  String userJob="";
  String userNumber="";
  String? userImage;
  String userJoinedAt="";
  bool isSameUser = false;
  @override
  void initState()
  {
    super.initState();
    getUserData();
  }
  void getUserData()async
  {
    isLoading= true;
    try{
      final DocumentSnapshot userRef = await FirebaseFirestore.instance
          .collection("workers")
          .doc(widget.userId).get();
      if(userRef==null)
      {
        return;
      }
      else
      {
        setState(() {
          userEmail = userRef.get("email");
          userName = userRef.get("name");
          userNumber = userRef.get("phoneNumber");
          userJob = userRef.get("position");
          userImage = userRef.get("userImageUrl");
          Timestamp timestamp = userRef.get("createdAt");
          var date = timestamp.toDate() ;
          userJoinedAt = "${date.year} / ${date.month} / ${date.day}";

        });
        User? user = FirebaseAuth.instance.currentUser;
        String _uid = user!.uid;
        setState(() {
          // isSameUser = true;
          isSameUser = _uid==widget.userId;
        });
      }
    }
    catch(error)
    {
      print("error in get user data ${error.toString()}");
    }finally
    {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('My Profile',
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
      body:  SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Card(
                  margin: const EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:     [
                        const SizedBox(height: 80,),
                        Align(
                          alignment: Alignment.center,
                          child:userName == null ? const Text("",
                            style:TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),): Text("$userName",
                            style:const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),),
                        ),
                        const SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              userJob == null ? const Text("",
                                style:TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),):  Text(userJob,
                                style:const TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontStyle: FontStyle.normal,
                                ),),
                              userJoinedAt == null ? const Text("",
                                style:TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),):  Text("joined at $userJoinedAt",
                                style:const TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontStyle: FontStyle.normal,
                                ),),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Divider(thickness: 2,),
                        ),
                        const Text("Contact Info",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),),
                        const SizedBox(height: 10,),
                        Row(
                          children:  [
                            const Text("Email / ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),),
                            userEmail == null ? const Text("",
                              style:TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),): Text(userEmail,
                              style:const TextStyle(
                                fontSize: 16,
                                color: Colors.lightBlue,
                                fontStyle: FontStyle.italic,
                              ),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children:  [
                            const   Text("Phone Number : ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),),
                            userNumber == null ? const Text("",
                              style:TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),): Text(userNumber,
                              style:const TextStyle(
                                fontSize: 16,
                                color: Colors.lightBlue,
                                fontStyle: FontStyle.italic,
                              ),),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        isSameUser? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                ),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              height: 40,
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  openWhatsAppChat();
                                },
                                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                                color: Colors.green,
                                iconSize: 20,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.pink.shade300,
                                ),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              height: 40,
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  email();
                                },
                                icon: const FaIcon(FontAwesomeIcons.mailBulk),
                                color: Colors.pink.shade300,
                                iconSize: 20,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.purple,
                                ),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              height: 40,
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  calling();
                                },
                                icon: const FaIcon(FontAwesomeIcons.phoneAlt),
                                color: Colors.purple,
                                iconSize: 20,
                              ),
                            ),
                          ],
                        ) : const Text(""),
                        const SizedBox(height: 20,),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Divider(thickness: 2,),
                        ),
                        const SizedBox(height: 10,),
                        Center(
                          child: MaterialButton(
                            color: Colors.pink.shade700,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: ()async{
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                              {
                                return const LoginScreen();
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Log Out",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.exit_to_app_outlined,
                                    color: Colors.white,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration:     BoxDecoration(
                        border: Border.all(
                            width: 5,
                            color: Theme.of(context).scaffoldBackgroundColor
                        ),
                        shape: BoxShape.circle,
                        image:   DecorationImage(
                          image: userImage == null ?  const NetworkImage("https://img.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg?w=740&t=st=1661281139~exp=1661281739~hmac=4b7ff98060aea6f4c59fd0612f8cbb307fad290445b0cd315a43a32660dd0610",
                          ) : NetworkImage(userImage!),
                        ),
                      ),

                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
