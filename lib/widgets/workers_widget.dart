import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_os_firebase/screens/drawer_screens/my_account.dart';

 class WorkersWidgetScreen extends StatefulWidget {

  const WorkersWidgetScreen({Key? key,
    required this.name,
    required this.email,
    required this.img,
    required this.position,
    required this.id
  }) : super(key: key);
final String name;
  final String email;
  final String img;
  final String position;
  final String id;

  @override
  State<WorkersWidgetScreen> createState() => _WorkersWidgetScreenState();
}

class _WorkersWidgetScreenState extends State<WorkersWidgetScreen> {
  Future<void> sendEmail()async
  {
    final Uri url5 = Uri.parse("mailto:${widget.email}");
    if (!await launchUrl(url5)) {
      throw 'Could not launch $url5';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: (){
          Navigator.push(context,
          MaterialPageRoute(builder: (context)
          {
            return MyProfileScreen(userId: widget.id);
          }));
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
            //https://media.istockphoto.com/vectors/load-completed-progress-icon-isolated-on-white-background-vector-vector-id949850430?k=20&m=949850430&s=612x612&w=0&h=PZT7T3HhbT0Eq1O7qnBGLZ4xoyPWGjxXLYhGyVaNEjU=
            radius: 20,
            backgroundColor: Colors.transparent,
            child:widget.img==null ?  Image.network("https://img.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg?w=740&t=st=1661281139~exp=1661281739~hmac=4b7ff98060aea6f4c59fd0612f8cbb307fad290445b0cd315a43a32660dd0610")
            : ClipRRect(
              borderRadius: BorderRadius.circular(20),
                child: Image.network(widget.img)),
          ),
        ),
        title:  Text(widget.name,
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
             Text(widget.position,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:const TextStyle(
                fontSize: 16,
              ),),
          ],
        ),
        trailing:   InkWell(
          onTap: ()
          {
            sendEmail();
          },
          child: Icon(Icons.mail_outline,
            color: Colors.pink[800],),
        ),
      ),

    );
  }
}
