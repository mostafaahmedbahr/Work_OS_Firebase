
import 'package:flutter/material.dart';
import 'package:work_os_firebase/screens/drawer_screens/my_account.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget(
      {Key? key,
      required this.name,
      required this.img,
      required this.comment,
      required this.commentId,
      required this.nameId})
      : super(key: key);
  final String name;
  final String nameId;
  final String commentId;
  final String img;
  final String comment;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  List<Color> colorsList = [
    Colors.red,
    Colors.green,
    Colors.brown,
    Colors.purple,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    // عشان ياخد لون عشوائى
    colorsList.shuffle();
    return InkWell(
      onTap: ()
      {
        Navigator.push(context,MaterialPageRoute(builder: (context)
        {
          return MyProfileScreen(userId:widget.nameId);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: colorsList[4],
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: widget.img == null
                            ? const NetworkImage(
                                "https://img.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg?w=740&t=st=1661281139~exp=1661281739~hmac=4b7ff98060aea6f4c59fd0612f8cbb307fad290445b0cd315a43a32660dd0610",
                              )
                            : NetworkImage(widget.img),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    widget.comment,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
