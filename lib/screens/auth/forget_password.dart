import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
with TickerProviderStateMixin{
  late AnimationController animationController;
  late Animation<double> animation;
  var passCon = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }
  @override
  void initState(){
    animationController = AnimationController(vsync: this,duration: const Duration(seconds: 20));
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    )..addListener(() {setState(() {

    });})..addStatusListener((status) {
      if(status==AnimationStatus.completed)
      {
        animationController.reset();
        animationController.forward();
      }
    });
    animationController.forward();
    super.initState();
  }
  void forgetPassword(){}
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "https://img.freepik.com/premium-photo/businessmen-tap-hologram-icon-online-data-network-connection-uploading-data-cloud-so-that-data-can-be-transferred-other-devices-can-be-viewed-online-any-time_528263-4192.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(animation.value,0),
            placeholder: (context, url) =>  Image.asset("assets/images/wallpaper.jpg"),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ListView(
                children: [
                  SizedBox(height: height*0.1,),
                  const Text("Forget Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),),
                  const SizedBox(height:20),
                  const Text("Email Address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),),
                  const SizedBox(height:20),
                  TextFormField(
                    validator: (val)
                    {
                      if(val!.isEmpty || val.length<7)
                      {
                        return "password is not valid";
                      }
                      return null;
                    },
                    controller: passCon,
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    decoration:  const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          )
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          )
                      ),
                     ),
                  ),
                  const SizedBox(height:40),
                  MaterialButton(
                    color: Colors.pink.shade700,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: (){
                      forgetPassword();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Reset Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                          SizedBox(width: 10,),
                          Icon(Icons.restart_alt,
                            color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
