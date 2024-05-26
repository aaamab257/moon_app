import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/model/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/custom_image.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final int length;
  const CategoryWidget(
      {super.key,
      required this.category,
      required this.index,
      required this.length});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(children: [
        Expanded(
          child: Container(
              height: 120,
              width: 150,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(.125),
                      width: .25),
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeSmall),
                  color: Theme.of(context).primaryColor.withOpacity(.125)),
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeSmall),
                  child: CustomImage(
                      width: 150,
                      height: 120,
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}'
                          '/${category.icon}'))),
        ),
        const SizedBox(height: 5),
        Center(
            child: SizedBox(
                width: 100,
                child: Text(category.name!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: ColorResources.getTextTitle(context)))))
      ]),
    );
  }
}
