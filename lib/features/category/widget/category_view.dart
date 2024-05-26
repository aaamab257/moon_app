import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widget/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/view/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

import 'category_shimmer.dart';

class CategoryView extends StatelessWidget {
  final bool isHomePage;
  const CategoryView({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryList != null
            ? categoryProvider.categoryList!.isNotEmpty
                ? SizedBox(
                    child: GridView.builder(
                      //padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 1.0,
                              mainAxisSpacing: 1.0,),
                      itemCount: categoryProvider.categoryList?.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BrandAndCategoryProductScreen(
                                          isBrand: false,
                                          id: categoryProvider
                                              .categoryList![index].id
                                              .toString(),
                                          name: categoryProvider
                                              .categoryList![index].name,
                                        )));
                          },
                          child: CategoryWidget(
                              category: categoryProvider.categoryList![index],
                              index: index,
                              length: categoryProvider.categoryList!.length),
                        );
                      },
                    ),
                  )
                : const SizedBox()
            : const CategoryShimmer();
      },
    );
  }
}
