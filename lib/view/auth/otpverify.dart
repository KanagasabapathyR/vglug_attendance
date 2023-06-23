import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:vglug_attendance/controller/auth_controller.dart';
import 'package:vglug_attendance/controller/common_controller.dart';


class OtpVerify extends StatelessWidget {
  OtpVerify({Key? key}) : super(key: key);
  var verificationId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AuthController phoneAuthController = AuthController();
    TextEditingController pinputController = TextEditingController();

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const
      // ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Verify Otp'.tr,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                   Center(
                    child: Text(
                      '6 digit code send to your Phone number'.tr,
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Pinput(
                    controller: pinputController,
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(

                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(onPressed: (){
                    if (formKey.currentState!.validate()) {
                      phoneAuthController.verifyOTP(
                          verificationId, pinputController.text);
                      // Get.to(() => SelectLanguage());
                    }
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetBuilder(
                          builder: (CommonController controller) => controller.isLoading? CircularProgressIndicator(): Text(
                            'Verify OTP'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              // color: const Color(0xffffffff),
                            ),
                          )

                      ),
                    ],
                  )),

                ],
              ),
            )
            ),
      ),
    );
  }
}
