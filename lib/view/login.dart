import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vglug_attendance/controller/auth_controller.dart';
import 'package:vglug_attendance/controller/common_controller.dart';
import 'package:vglug_attendance/view/widgets/customtextformfield.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AuthController phoneAuthController = AuthController();
    TextEditingController phoneNumberController = TextEditingController();
    // CommonController controller=CommonController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Login',
                    // AppLocalization.of(context)!
                    //     .translate('By signing up,you accept our'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 20),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomTextFormFieldWidget(
                      keyBoard: TextInputType.text,
                      controller: phoneNumberController,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter mobile number'.tr;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        formKey.currentState!.validate();
                      },

                      // hint: AppLocalization.of(context)!.translate("Mobile"),
                      hint: 'Enter Mobile number'.tr,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(onPressed: (){
                      if (formKey.currentState!.validate()) {
                        phoneAuthController
                            .verifyPhoneNumber(phoneNumberController.text);
                        // Get.to(() => OtpVerify());
                      }
                    }, child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder(
                            builder: (CommonController controller) => controller.isLoading? CircularProgressIndicator(): Text(
                              'Send OTP'.tr,
                              textAlign: TextAlign.center,
                              style:TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                // color: const Color(0xffffffff),
                              ),
                            )

                        ),
                      ],
                    )),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(20),
                  //   child: RawMaterialButton(
                  //     constraints: const BoxConstraints(minHeight: 40),
                  //     onPressed: () {
                  //
                  //       if (formKey.currentState!.validate()) {
                  //         phoneAuthController
                  //             .verifyPhoneNumber(phoneNumberController.text);
                  //        // Get.to(() => OtpVerify());
                  //       }
                  //     },
                  //     // fillColor: const Color(0xfffec001),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         GetBuilder(
                  //           builder: (CommonController controller) => controller.isLoading? CircularProgressIndicator(color: Colors.white,): Text(
                  //               'Send OTP'.tr,
                  //               textAlign: TextAlign.center,
                  //               style:TextStyle(
                  //                 fontSize: 17,
                  //                 fontWeight: FontWeight.w400,
                  //                 color: const Color(0xffffffff),
                  //               ),
                  //             )
                  //
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Text(
                  //   'By signing up,you accept our'.tr,
                  //   // AppLocalization.of(context)!
                  //   //     .translate('By signing up,you accept our'),
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 17,
                  //     fontWeight: FontWeight.w400,
                  //   color:  const Color(0xffffffff),                    ),
                  // ),
                  // const SizedBox(width: 10),
                  // TextButton(
                  //   onPressed: () {
                  //     Get.to(()=>TandC());
                  //   },
                  //   child: Text(
                  //     'Terms And Conditions'.tr,
                  //     // AppLocalization.of(context)!
                  //     //     .translate('Terms And Conditions'),
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.acme(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.w400,
                  //       color: kYellow,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
