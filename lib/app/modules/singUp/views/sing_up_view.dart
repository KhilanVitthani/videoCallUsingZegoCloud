import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_call/constants/sizeConstant.dart';
import 'package:video_call/model/userModel.dart';
import 'package:video_call/services/FirebaseService.dart';
import 'package:video_call/services/text_field.dart';

import '../../../../constants/progress_dialog_utils.dart';
import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sing_up_controller.dart';

class SingUpView extends GetView<SingUpController> {
  const SingUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SingUpView'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.singUpKey,
              child: Column(
                children: [
                  getTextField(
                    textEditingController: controller.nameController,
                    hintText: "Name",
                    labelText: "Name",
                    textInputType: TextInputType.name,
                    validation: (value) {
                      if (isNullEmptyOrFalse(value)) {
                        return "Name can't be empty";
                      }
                      return null;
                    },
                  ),
                  Spacing.height(10),
                  getTextField(
                    textEditingController: controller.emailController,
                    hintText: "Email",
                    labelText: "Email",
                    textInputType: TextInputType.emailAddress,
                    validation: (value) => validateEmail(value),
                  ),
                  Spacing.height(10),
                  getTextField(
                    textEditingController: controller.passwordController,
                    hintText: "Password",
                    labelText: "Password",
                    textInputType: TextInputType.visiblePassword,
                    textVisible: controller.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.isPasswordVisible.toggle();
                      },
                      icon: Icon((controller.isPasswordVisible.isTrue)
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    validation: (value) {
                      if (isNullEmptyOrFalse(value)) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                  ),
                  Spacing.height(10),
                  getButton(
                    text: "SingUp",
                    onTap: () {
                      if (controller.singUpKey.currentState!.validate()) {
                        getIt<CustomDialogs>().showCircularDialog(context);
                        getIt<FirebaseService>().createUserWithEmailAndPassword(
                          context: context,
                          userModel: UserModel(
                            email: controller.emailController.text,
                            password: controller.passwordController.text,
                            name: controller.nameController.text,
                          ),
                        );
                      }
                    },
                  ),
                  Spacing.height(500),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Login here',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.offAllNamed(Routes.SING_IN);
                        },
                    ),
                  ])),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
