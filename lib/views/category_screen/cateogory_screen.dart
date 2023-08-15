import 'package:ecommerceapp/consts/consts.dart';
import 'package:ecommerceapp/controllers/product_controller.dart';
import 'package:ecommerceapp/views/category_screen/category_details.dart';
import 'package:ecommerceapp/widgets_common/bg_widget.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).white.makeCentered(),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 200),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset(
                      categoriesImages[index],
                      height: 150,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    20.heightBox,
                    categoriesList[index]
                        .text
                        .bold
                        .color(darkFontGrey)
                        .align(TextAlign.center)
                        .make(),
                    // 20.heightBox,
                  ],
                )
                    .box
                    .white
                    .rounded
                    .clip(Clip.antiAlias)
                    .outerShadowSm
                    .make()
                    .onTap(() {
                  controller.getSubCategories(categoriesList[index]);
                  Get.to(() => CategoryDetails(
                        title: categoriesList[index],
                      ));
                });
              }),
        ),
      ),
    );
  }
}
