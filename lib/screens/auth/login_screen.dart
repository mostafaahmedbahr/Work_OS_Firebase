import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:work_os_firebase/screens/auth/forget_password.dart';
import 'package:work_os_firebase/screens/auth/register_screen.dart';
import 'package:work_os_firebase/screens/task/tasks_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin
{
  late AnimationController animationController;
  late Animation<double> animation;
  var emailCon = TextEditingController();
  var passCon = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isVisible = true;
  var focusEmail = FocusNode();
  var focusPassword = FocusNode();

  @override
  void dispose(){
    animationController.dispose();
    emailCon.dispose();
    passCon.dispose();
    focusPassword.dispose();
    focusEmail.dispose();
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
  User? user;
  bool isLoading = false;
  void login(context) async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try{
        await  FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCon.text.trim(),
          password: passCon.text.trim(),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
        {
          return const TasksScreen();
        }));
      }
      catch(error)
      {
        showDialog(
          // عشان لما اضغط على اى حاجه خارجه ميقفلوش
            barrierDismissible: false,
            // اغير لون الخلفية
            // barrierColor: Colors.red,
            context: context,
            builder: (context)
            {
              return   AlertDialog(
                title: const Text("Error"),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Ok",
                      style: TextStyle(
                        color: Colors.pink,
                      ),),
                  ),
                ],
              );
            }
        );
        print("error in login   ${error}");
      }
    }
    else
    {
      print("error in login function");
      setState(() {
        isLoading =false;
      });
    }
  }

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
                  const Text("Login",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                  const SizedBox(height:16),
                  RichText(text:  TextSpan(
                    children: [
                      const TextSpan(text: "Don'\t have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                      const TextSpan(
                        text: "  ",),
                        TextSpan(text: "Sign Up",
                          recognizer: TapGestureRecognizer()..onTap=(){
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)
                            {
                              return const RegisterScreen();
                            }));
                          },
                          style: TextStyle(
                            color: Colors.blue.shade300,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ]
                  )),
                    SizedBox(height:height*0.05),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    focusNode: focusEmail,
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(focusPassword);
                    },
                    validator: (val)
                    {
                      if(val!.isEmpty || val.length<7)
                      {
                        return "Email is not valid";
                      }
                      return null;
                    },
                    controller: emailCon,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration:  InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        )
                    ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade700,
                          )
                      ),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          )
                      ),
                    ),
                  ),
                  SizedBox(height:height*0.05),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    focusNode: focusPassword,
                    onEditingComplete: (){

                    },
                    obscureText: isVisible,
                    validator: (val)
                    {
                      if(val!.isEmpty )
                      {
                        return "password is not correct";
                      }
                      return null;
                    },
                    controller: passCon,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    decoration:  InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon:isVisible? const Icon(Icons.visibility_off,
                        color: Colors.white,) : const Icon(Icons.visibility,
                        color: Colors.white,),
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          )
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade700,
                          )
                      ),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          )
                      ),
                    ),
                  ),
                  SizedBox(height:height*0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context)
                        {
                          return const ForgetPasswordScreen();
                        }));
                      },
                      child: const Text("Forget Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),),
                    ),
                  ),
                  SizedBox(height:height*0.01),
                  isLoading? const Center(
                    child: CircularProgressIndicator(),
                  ): MaterialButton(
                    color: Colors.pink.shade700,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: (){
                      login(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("LoGin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(width: 10,),
                          Icon(Icons.login,
                          color: Colors.white,),
                        ],
                      ),
                    ),
                  )  ,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
