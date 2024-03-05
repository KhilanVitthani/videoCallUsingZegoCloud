import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/progress_dialog_utils.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../model/userModel.dart';
import '../../../../services/FirebaseService.dart';
import '../../../../services/text_field.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sing_in_controller.dart';

class SingInView extends GetView<SingInController> {
  const SingInView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sing In'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.singInKey,
              child: Column(
                children: [
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
                    text: "Sing In",
                    onTap: () {
                      if (controller.singInKey.currentState!.validate()) {
                        getIt<CustomDialogs>().showCircularDialog(context);
                        getIt<FirebaseService>().logInUserWithEmailAndPassword(
                          context: context,
                          userModel: UserModel(
                            email: controller.emailController.text,
                            password: controller.passwordController.text,
                          ),
                        );
                      }
                    },
                  ),
                  Spacing.height(500),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Don't Have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Create here',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.offAllNamed(Routes.SING_UP);
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
