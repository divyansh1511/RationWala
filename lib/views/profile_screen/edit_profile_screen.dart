import 'dart:io';

import 'package:ecommerceapp/controllers/profile_controller.dart';
import 'package:ecommerceapp/widgets_common/Custom_textField.dart';
import 'package:ecommerceapp/widgets_common/bg_widget.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/consts.dart';
import '../../widgets_common/our_button.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                  ? Image.asset(imgProfile2, width: 80, fit: BoxFit.cover)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make()
                  : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                      ? Image.network(
                          data['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ourButton(
                  color: redColor,
                  onPress: () {
                    controller.changeImage(context);
                  },
                  textcolor: whiteColor,
                  title: "Change"),
              const Divider(),
              20.heightBox,
              customTextField(
                controller: controller.nameController,
                hint: nameHint,
                title: name,
                isPass: false,
              ),
              10.heightBox,
              customTextField(
                controller: controller.oldpassController,
                hint: passwordHint,
                title: oldpassword,
                isPass: true,
              ),
              10.heightBox,
              customTextField(
                controller: controller.newpassController,
                hint: passwordHint,
                title: newpassword,
                isPass: true,
              ),
              20.heightBox,
              controller.isloading.value
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    )
                  : SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButton(
                          color: redColor,
                          onPress: () async {
                            controller.isloading(true);

                            //img not selected
                            if (controller.profileImgPath.value.isNotEmpty) {
                              await controller.uploadProfileImage1();
                            } else {
                              controller.profileImgLink = data['imgUrl'];
                            }

                            if (data['password'] ==
                                controller.oldpassController.text) {
                              await controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpassController.text,
                                newpassword: controller.newpassController.text,
                              );

                              await controller.updateProfile(
                                imgUrl: controller.profileImgLink,
                                name: controller.nameController.text,
                                password: controller.newpassController.text,
                              );
                              VxToast.show(context, msg: "Updated");
                            } else {
                              VxToast.show(context, msg: "wrong old password");
                              controller.isloading(false);
                            }

                            // controller.isloading(false);
                          },
                          textcolor: whiteColor,
                          title: "Save"),
                    ),
            ],
          )
              .box
              .white
              .shadowSm
              .padding(const EdgeInsets.all(16))
              .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
              .rounded
              .make(),
        ),
      ),
    ));
  }
}
