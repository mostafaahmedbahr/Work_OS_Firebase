
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_os_firebase/screens/auth/login_screen.dart';
 import 'dart:io';
 import '../../constants/consts.dart';
import '../task/tasks_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  var emailCon = TextEditingController();
  var passCon = TextEditingController();
  var nameCon = TextEditingController();
  var companyCon = TextEditingController();
  var phoneNumberCon = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var focusName = FocusNode();
  var focusEmail = FocusNode();
  var focusPassword = FocusNode();
  var focusPosition = FocusNode();
  var focusPhoneNumber = FocusNode();
  bool isVisible = true;
  File? imageFile;
  bool isLoading = false;
  String? url;
  @override
  void dispose() {
    animationController.dispose();
    emailCon.dispose();
    passCon.dispose();
    companyCon.dispose();
    nameCon.dispose();
    phoneNumberCon.dispose();
    focusEmail.dispose();
    focusName.dispose();
    focusPassword.dispose();
    focusPosition.dispose();
    focusPhoneNumber.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
          animationController.forward();
        }
      });
    animationController.forward();
    super.initState();
  }

  void cropImage(filePath) async
  {
    CroppedFile? cropImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (cropImage != null) {
      setState(() {
        imageFile = cropImage as File?;
      });
    }
  }

  User? user;
  void signUp(context) async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
    try{
      await  FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCon.text.trim(),
        password: passCon.text.trim(),
      );
      final User? user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;
      // عشان ارفع الصورة
      var ref = FirebaseStorage.instance.ref()
          .child("usersImages")
          .child(uid! + "jpg");
      await ref.putFile(imageFile!);
       url =await ref.getDownloadURL();
       //////////////////
      FirebaseFirestore.instance.collection("workers").doc(uid).set({
        "id":uid,
        "name":nameCon.text,
        "email":emailCon.text,
        "userImageUrl":url,
        "phoneNumber":passCon.text,
        "position":companyCon.text,
        "createdAt":Timestamp.now(),
      });
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
          print("error in sign in ${error}");
        }
    }
    else
    {
      print("error in register function");
      setState(() {
        isLoading =false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
            "https://img.freepik.com/premium-photo/businessmen-tap-hologram-icon-online-data-network-connection-uploading-data-cloud-so-that-data-can-be-transferred-other-devices-can-be-viewed-online-any-time_528263-4192.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(animation.value, 0),
            placeholder: (context, url) =>
                Image.asset("assets/images/wallpaper.jpg"),
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
                  SizedBox(
                    height: height * 0.1,
                  ),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                            text: "Already have an account !",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const TextSpan(
                          text: "  ",
                        ),
                        TextSpan(
                            text: "Login",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                      return const LoginScreen();
                                    }));
                              },
                            style: TextStyle(
                              color: Colors.blue.shade300,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ])),
                  SizedBox(height: height * 0.03),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: focusName,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(focusEmail);
                          },
                          validator: (val) {
                            if (val!.isEmpty ) {
                              return "name is not valid";
                            }
                            return null;
                          },
                          controller: nameCon,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            hintStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink.shade700,
                                )),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: height * 0.15,
                                width: width * 0.30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: imageFile == null
                                      ? Image.network(
                                    "https://as2.ftcdn.net/v2/jpg/01/26/61/13/1000_F_126611337_m8kcRtS5G7AhrFpOQ0Wufx4PgL6J4yxg.jpg",
                                    fit: BoxFit.fitHeight,
                                  )
                                      : Image.file(
                                    imageFile!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    // عشان لما اضغط على اى حاجه خارجه ميقفلوش
                                      barrierDismissible: true,
                                      // اغير لون الخلفية
                                      // barrierColor: Colors.red,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Please Choose a Photo"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Divider(
                                                thickness: 2,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  var picked = await ImagePicker()
                                                      .pickImage(
                                                    source: ImageSource.camera,
                                                    maxHeight: 1080,
                                                    maxWidth: 1080,
                                                  );
                                                  setState(() {
                                                    imageFile =
                                                        File(picked!.path);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      4.0),
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.camera,
                                                        color: Colors.purple,),
                                                      SizedBox(width: 5,),
                                                      Text("Camera",
                                                        style: TextStyle(
                                                          color: Colors.purple,
                                                        ),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  var picked = await ImagePicker()
                                                      .pickImage(
                                                    source: ImageSource.gallery,
                                                    maxHeight: 1080,
                                                    maxWidth: 1080,
                                                  );
                                                  setState(() {
                                                    imageFile =
                                                        File(picked!.path);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      4.0),
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.image_rounded,
                                                        color: Colors.purple,),
                                                      SizedBox(width: 5,),
                                                      Text("Gallery",
                                                        style: TextStyle(
                                                          color: Colors.purple,
                                                        ),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                        );
                                      }
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                    shape: BoxShape.circle,

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      imageFile == null
                                          ? Icons.add_a_photo
                                          : Icons.edit,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  TextFormField(
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(focusPassword);
                    },
                    textInputAction: TextInputAction.next,
                    focusNode: focusEmail,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 7) {
                        return "Email is not valid";
                      }
                      return null;
                    },
                    controller: emailCon,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade700,
                          )),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          )),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  TextFormField(
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(focusPhoneNumber);
                    },
                    textInputAction: TextInputAction.next,
                    focusNode: focusPassword,
                    obscureText: isVisible,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "password is not correct";
                      }
                      return null;
                    },
                    controller: passCon,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? const Icon(
                          Icons.visibility_off,
                          color: Colors.white,
                        )
                            : const Icon(
                          Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade700,
                          )),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          )),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  TextFormField(
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(focusPosition);
                    },
                    textInputAction: TextInputAction.next,
                    focusNode: focusPhoneNumber,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 7) {
                        return "phone Number is not valid";
                      }
                      return null;
                    },
                    controller: phoneNumberCon,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink.shade700,
                          )),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          )),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  InkWell(
                    onTap: () {
                      showDialog(
                        // عشان لما اضغط على اى حاجه خارجه ميقفلوش
                          barrierDismissible: false,
                          // اغير لون الخلفية
                          // barrierColor: Colors.red,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Jobs",
                                style: TextStyle(
                                  color: Colors.pink.shade300,
                                  fontSize: 20,
                                ),),
                              content: SizedBox(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: Constants.listJobs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            companyCon.text =
                                            Constants.listJobs[index];
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
                                                Text(Constants.listJobs[index],
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, child: const Text("Cancel"),
                                ),

                              ],
                            );
                          }
                      );
                    },
                    child: TextFormField(
                      enabled: false,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        // submit();
                      },
                      focusNode: focusPosition,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 7) {
                          return "position is not valid";
                        }
                        return null;
                      },
                      controller: companyCon,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: "Company Position",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.pink.shade700,
                            )),
                        errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  if (isLoading) const Center(
                    child: CircularProgressIndicator(),
                  ) else MaterialButton(
                  color: Colors.pink.shade700,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    signUp(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
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
