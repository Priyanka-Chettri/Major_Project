import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

PhoneAuthCredential globalCredential = PhoneAuthProvider.credential(
    verificationId: '', smsCode: '');

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FocusNode otpFocusNode = FocusNode();

  bool isValidPhone = false;
  bool otpSent = false;
  bool isValidOtp = false;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = const TextStyle(
        color: Colors.black, fontSize: 14, fontFamily: "Playfair Display");
    TextStyle linkStyle = const TextStyle(
        color: Colors.blue, fontSize: 14, fontFamily: "Playfair Display");
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xFFEF9A94),
                Color(0xFFFFEBEE),
              ]),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                RichText(
                    text: TextSpan(
                  style: defaultStyle,
                  children: [
                    const TextSpan(text: "Don't have an account?"),
                    TextSpan(
                      text: " Register",
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => RegisterScreen()),
                          //     (route) => true);
                        },
                    ),
                  ],
                )),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Phone Number",
                      hintStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      if (value.length == 10) {
                        isValidPhone = true;
                      } else {
                        isValidPhone = false;
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width/2 - 10,
                  child: ElevatedButton(
                    onPressed: () async{
                      if(isValidPhone){
                        await FirebaseAuthentication().sendOTP(phoneController.text);
                        setState(() {
                          otpSent = true;
                          otpFocusNode.requestFocus();
                        });
                        print("${isValidPhone}");
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => HomeScreen()),
                        //     (route) => true);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(isValidPhone ? otpSent? Colors.green : Color.fromARGB(255, 229, 150, 104) : Colors.grey.shade400),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                    ),
                    child: Text(
                      otpSent ? "OTP Sent !" : "Send OTP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "PlayFair Display",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                otpSent
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: otpController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Enter OTP",
                            hintStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          focusNode: otpFocusNode,
                          onChanged: (value) {
                            if (value.length == 6) {
                              isValidOtp = true;
                            } else {
                              isValidOtp = false;
                            }
                            setState(() {});
                          },
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      print("${phoneController.text}");
                      FirebaseAuthentication().verifyOtp(globalCredential.verificationId ?? "",  otpController.text, context);
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => HomeScreen()),
                      //     (route) => true);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(
                            otpController.text=="" ? Colors.grey.shade400 :
                            Color(0xff4A148C)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "PlayFair Display",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );  
  }
}

class FirebaseAuthentication {
  String phoneNumber = "";
  
  sendOTP(String phoneNumber) async {
    this.phoneNumber = phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) async {
        printMessage("Auto Verification Completed");
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        printMessage("Auto Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) async {
        printMessage("OTP Sent");
        String smsCode = '111111';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        globalCredential = credential;
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        printMessage("Auto Retrieval Timeout");
      },
    );
    printMessage("OTP Sent to +91 $phoneNumber");
  }
  
  authenticate(ConfirmationResult confirmationResult, String otp) async {
    UserCredential userCredential = await confirmationResult.confirm(otp);
    userCredential.additionalUserInfo!.isNewUser
        ? printMessage("Authentication Successful")
        : printMessage("User already exists");
  }

  Future<void> verifyOtp(String verID, String otpPin, BuildContext context) async{
    await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
          verificationId: verID,
          smsCode: otpPin
      )
    ).whenComplete(()async{
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>const HomeScreen()), (route)=>true);

      /*showSnackBar("Verification completed please enter other details to proceed");
      setState(() {
        isverifyclicked=true;
      });*/

    });

  }
  
  printMessage(String msg) {
    debugPrint(msg);
  }
}