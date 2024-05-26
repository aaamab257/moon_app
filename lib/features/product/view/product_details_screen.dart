import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmer/product_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/promise_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/review_section.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/bottom_cart_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/product_specification_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/related_product_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widget/youtube_video_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widget/shop_product_view_list.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final int? productId;
  final String? slug;
  final bool isFromWishList;
  const ProductDetails(
      {super.key,
      required this.productId,
      required this.slug,
      this.isFromWishList = false});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  _loadData(BuildContext context) async {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getProductDetails(context, widget.slug.toString());
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .removePrevReview();
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(widget.productId, widget.slug, context);
    Provider.of<ProductProvider>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductProvider>(context, listen: false)
        .initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getCount(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.slug.toString(), context);
  }

  @override
  void initState() {
    _loadData(context);
    super.initState();
  }

  bool isReview = false;
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('product_details', context)),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(context),
        child: Consumer<ProductDetailsProvider>(
          builder: (context, details, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: !details.isDetails
                  ? Column(
                      children: [
                        ProductImageView(
                            productModel: details.productDetailsModel),
                        Column(
                          children: [
                            ProductTitleView(
                                productModel: details.productDetailsModel,
                                averageRatting: details.productDetailsModel
                                            ?.averageReview !=
                                        null
                                    ? details.productDetailsModel!.averageReview
                                    : "0"),
                            isReview
                                ? const SizedBox() //ReviewSection(details: details)
                                : Column(
                                    children: [
                                      (details.productDetailsModel?.details !=
                                                  null &&
                                              details.productDetailsModel!
                                                  .details!.isNotEmpty)
                                          ? Container(
                                              height: 250,
                                              margin: const EdgeInsets.only(
                                                  top: Dimensions
                                                      .paddingSizeSmall),
                                              padding: const EdgeInsets.all(
                                                  Dimensions.paddingSizeSmall),
                                              child: ProductSpecification(
                                                  productSpecification: details
                                                          .productDetailsModel!
                                                          .details ??
                                                      ''),
                                            )
                                          : const SizedBox(),

                                      //   Container(
                                      //       padding: const EdgeInsets.symmetric(
                                      //           vertical: Dimensions
                                      //               .paddingSizeDefault),
                                      //       decoration: BoxDecoration(
                                      //           color:
                                      //               Theme.of(context).cardColor),
                                      //       child: const PromiseScreen()),
                                      //   (details.productDetailsModel != null &&
                                      //           details.productDetailsModel!
                                      //                   .addedBy ==
                                      //               'seller')
                                      //       ? Padding(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                   vertical: Dimensions
                                      //                       .paddingSizeDefault),
                                      //           child: TitleRow(
                                      //               title: getTranslated(
                                      //                   'more_from_the_shop',
                                      //                   context),
                                      //               isDetailsPage: true),
                                      //         )
                                      //       : const SizedBox(),
                                      //   details.productDetailsModel?.addedBy ==
                                      //           'seller'
                                      //       ? Padding(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                   horizontal: Dimensions
                                      //                       .paddingSizeDefault),
                                      //           child: ShopProductViewList(
                                      //               scrollController:
                                      //                   scrollController,
                                      //               sellerId: details
                                      //                   .productDetailsModel!
                                      //                   .userId!))
                                      //       : const SizedBox(),
                                      //   Consumer<ProductProvider>(builder:
                                      //       (context, productProvider, _) {
                                      //     return (productProvider
                                      //                     .relatedProductList !=
                                      //                 null &&
                                      //             productProvider
                                      //                 .relatedProductList!
                                      //                 .isNotEmpty)
                                      //         ? Column(
                                      //             children: [
                                      //               Padding(
                                      //                 padding: const EdgeInsets
                                      //                     .symmetric(
                                      //                     vertical: Dimensions
                                      //                         .paddingSizeExtraSmall),
                                      //                 child: TitleRow(
                                      //                     title: getTranslated(
                                      //                         'related_products',
                                      //                         context),
                                      //                     isDetailsPage: true),
                                      //               ),
                                      //               const SizedBox(height: 5),
                                      //               const Padding(
                                      //                 padding: EdgeInsets.symmetric(
                                      //                     horizontal: Dimensions
                                      //                         .paddingSizeDefault),
                                      //                 child: RelatedProductView(),
                                      //               ),
                                      //             ],
                                      //           )
                                      //         : const SizedBox();
                                      //   }),
                                      //
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    )
                  : const ProductDetailsShimmer(),
            );
          },
        ),
      ),
      bottomNavigationBar:
          Consumer<ProductDetailsProvider>(builder: (context, details, child) {
        return !details.isDetails
            ? BottomCartView(
                product: details.productDetailsModel,
                cancleCart: false,
              )
            : const SizedBox();
      }),
    );
  }
}
