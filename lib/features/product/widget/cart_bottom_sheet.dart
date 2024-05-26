import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/model/product_details_model.dart'
    as pd;
import 'package:flutter_sixvalley_ecommerce/features/product/domain/model/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/provider/splash_provider.dart';

import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/custom_image.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/views/cart_screen.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatefulWidget {
  final pd.ProductDetailsModel? product;
  final Product? productModel ;
  final Function? callback;
  const CartBottomSheet({super.key,  this.product, this.callback , this.productModel});

  @override
  CartBottomSheetState createState() => CartBottomSheetState();
}

class CartBottomSheetState extends State<CartBottomSheet> {
  @override
  void initState() {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initData(widget.product!, widget.product!.minimumOrderQty, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Consumer<ProductDetailsProvider>(
            builder: (ctx, details, child) {
              String? colorWiseSelectedImage = '';

              if (widget.product != null &&
                  widget.product!.colorImage != null &&
                  widget.product!.colorImage!.isNotEmpty) {
                for (int i = 0; i < widget.product!.colorImage!.length; i++) {
                  if (widget.product!.colorImage![i].color ==
                      '${widget.product!.colors?[details.variantIndex ?? 0].code?.substring(1, 7)}') {
                    colorWiseSelectedImage =
                        widget.product!.colorImage![i].imageName;
                  }
                }
              }

              Variation? variation;
              String? variantName = (widget.product!.colors != null &&
                      widget.product!.colors!.isNotEmpty)
                  ? widget.product!.colors![details.variantIndex!].name
                  : null;
              List<String> variationList = [];
              for (int index = 0;
                  index < widget.product!.choiceOptions!.length;
                  index++) {
                variationList.add(widget.product!.choiceOptions![index]
                    .options![details.variationIndex![index]]
                    .trim());
              }
              String variationType = '';
              if (variantName != null) {
                variationType = variantName;
                for (var variation in variationList) {
                  variationType = '$variationType-$variation';
                }
              } else {
                bool isFirst = true;
                for (var variation in variationList) {
                  if (isFirst) {
                    variationType = '$variationType$variation';
                    isFirst = false;
                  } else {
                    variationType = '$variationType-$variation';
                  }
                }
              }
              double? price = widget.product!.unitPrice;
              int? stock = widget.product!.currentStock;
              variationType = variationType.replaceAll(' ', '');
              for (Variation variation in widget.product!.variation!) {
                if (variation.type == variationType) {
                  price = variation.price;
                  variation = variation;
                  stock = variation.qty;
                  break;
                }
              }

              double priceWithDiscount = PriceConverter.convertWithDiscount(
                  context,
                  price,
                  widget.product!.discount,
                  widget.product!.discountType)!;
              double priceWithQuantity = priceWithDiscount * details.quantity!;

              double total = 0, avg = 0;
              for (var review in widget.product!.reviews!) {
                total += review.rating!;
              }
              avg = total / widget.product!.reviews!.length;
              // String ratting = widget.product!.reviews != null &&
              //         widget.product!.reviews!.isNotEmpty
              //     ? avg.toString()
              //     : "0";

              CartModelBody cart = CartModelBody(
                productId: widget.product!.id,
                variant: (widget.product!.colors != null &&
                        widget.product!.colors!.isNotEmpty)
                    ? widget.product!.colors![details.variantIndex!].name
                    : '',
                color: (widget.product!.colors != null &&
                        widget.product!.colors!.isNotEmpty)
                    ? widget.product!.colors![details.variantIndex!].code
                    : '',
                variation: variation,
                quantity: details.quantity,
              );

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall),
                                child: Icon(Icons.cancel,
                                    color: Theme.of(context).hintColor,
                                    size: 30)))),

                    // Product details
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.homePagePadding),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: .5,
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.20))),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CustomImage(
                                              image: (widget.product!.colors != null &&
                                                      widget.product!.colors!
                                                          .isNotEmpty &&
                                                      widget.product!.images !=
                                                          null &&
                                                      widget.product!.images!
                                                          .isNotEmpty)
                                                  ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/$colorWiseSelectedImage'
                                                  : '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}/${widget.product!.thumbnail}')),
                                    ),
                                    widget.product!.discount! > 0
                                        ? Container(
                                            width: 100,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeExtraSmall),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(Dimensions
                                                        .paddingSizeExtraSmall))),
                                            child: Padding(
                                                padding: const EdgeInsets.all(
                                                    5),
                                                child: Text(
                                                    PriceConverter
                                                        .percentageCalculation(
                                                            context,
                                                            widget.product!
                                                                .unitPrice,
                                                            widget.product!
                                                                .discount,
                                                            widget.product!
                                                                .discountType),
                                                    style: titilliumRegular
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: Dimensions
                                                                .fontSizeDefault))),
                                          )
                                        : const SizedBox(width: 93),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.product!.name ?? '',
                                            style: titilliumRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        // Row(
                                        //   children: [
                                        //     const Icon(Icons.star_rate_rounded,
                                        //         color: Colors.orange),
                                        //     Text(
                                        //         double.parse(ratting)
                                        //             .toStringAsFixed(1),
                                        //         style:
                                        //             titilliumSemiBold.copyWith(
                                        //                 fontSize: Dimensions
                                        //                     .fontSizeLarge),
                                        //         maxLines: 2,
                                        //         overflow:
                                        //             TextOverflow.ellipsis),
                                        //   ],
                                        // ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        Row(
                                          children: [
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeDefault),
                                            widget.product!.discount! > 0
                                                ? Text(
                                                    PriceConverter.convertPrice(
                                                        context,
                                                        widget.product!
                                                            .unitPrice),
                                                    style: titilliumRegular
                                                        .copyWith(
                                                            color: ColorResources
                                                                .getRed(
                                                                    context),
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeDefault),
                                            Text(
                                              PriceConverter.convertPrice(
                                                  context,
                                                  widget.product!.unitPrice,
                                                  discountType: widget
                                                      .product!.discountType,
                                                  discount:
                                                      widget.product!.discount),
                                              style: titilliumRegular.copyWith(
                                                  color:
                                                      ColorResources.getPrimary(
                                                          context),
                                                  fontSize: Dimensions
                                                      .fontSizeExtraLarge),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ]),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // Quantity
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.homePagePadding),
                      child: Row(children: [
                        Text(getTranslated('quantity', context)!,
                            style: robotoBold),
                        QuantityButton(
                            isIncrement: false,
                            quantity: details.quantity,
                            stock: stock,
                            minimumOrderQuantity:
                                widget.product!.minimumOrderQty,
                            digitalProduct:
                                widget.product!.productType == "digital"),
                        Text(details.quantity.toString(),
                            style: titilliumSemiBold),
                        QuantityButton(
                            isIncrement: true,
                            quantity: details.quantity,
                            stock: stock,
                            minimumOrderQuantity:
                                widget.product!.minimumOrderQty,
                            digitalProduct:
                                widget.product!.productType == "digital"),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated('total_price', context)!,
                                style: robotoBold),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text(
                              PriceConverter.convertPrice(
                                  context, priceWithQuantity),
                              style: titilliumBold.copyWith(
                                  color: ColorResources.getPrimary(context),
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                            widget.product!.taxModel == 'exclude'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: Dimensions.paddingSizeExtraSmall),
                                    child: Text(
                                      '(${getTranslated('tax', context)} : ${widget.product?.tax}%)',
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.hintTextColor,
                                          fontSize: Dimensions.fontSizeDefault),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: Dimensions.paddingSizeExtraSmall),
                                    child: Text(
                                      '(${getTranslated('tax', context)} ${widget.product!.taxModel})',
                                      style: titilliumRegular.copyWith(
                                          color: ColorResources.hintTextColor,
                                          fontSize: Dimensions.fontSizeDefault),
                                    ),
                                  ),
                          ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    (stock! < widget.product!.minimumOrderQty! &&
                            widget.product!.productType == "physical")
                        ? CustomButton(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(.10),
                            textColor: Theme.of(context).colorScheme.error,
                            buttonText: getTranslated('out_of_stock', context))
                        : Provider.of<CartController>(context).addToCartLoading
                            ? const Center(
                                child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ))
                            : Container(
                                color: Theme.of(context).colorScheme.onTertiary,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.homePagePadding,
                                      vertical: Dimensions.paddingSizeSmall),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                            isBuy: true,
                                            radius: 6,
                                            buttonText: getTranslated(
                                                stock <
                                                            widget.product!
                                                                .minimumOrderQty! &&
                                                        widget.product!
                                                                .productType ==
                                                            "physical"
                                                    ? 'out_of_stock'
                                                    : 'buy_now',
                                                context),
                                            onTap: stock <
                                                        widget.product!
                                                            .minimumOrderQty! &&
                                                    widget.product!
                                                            .productType ==
                                                        "physical"
                                                ? null
                                                : () {
                                                    if (stock! >=
                                                            widget.product!
                                                                .minimumOrderQty! ||
                                                        widget.product!
                                                                .productType ==
                                                            "digital") {
                                                      Provider.of<CartController>(
                                                              context,
                                                              listen: false)
                                                          .addToCartAPI(
                                                        cart,
                                                        context,
                                                        widget.product!
                                                            .choiceOptions!,
                                                        details.variationIndex,
                                                      )
                                                          .then((value) {
                                                        if (value.response!
                                                                .statusCode ==
                                                            200) {
                                                          _navigateToNextScreen(
                                                              context);
                                                        }
                                                      });
                                                    }
                                                  }),
                                      ),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeDefault),
                                      Expanded(
                                        child: CustomButton(
                                            radius: 6,
                                            buttonText: getTranslated(
                                                stock <
                                                            widget.product!
                                                                .minimumOrderQty! &&
                                                        widget.product!
                                                                .productType ==
                                                            "physical"
                                                    ? 'out_of_stock'
                                                    : 'add_to_cart',
                                                context),
                                            onTap: stock <
                                                        widget.product!
                                                            .minimumOrderQty! &&
                                                    widget.product!
                                                            .productType ==
                                                        "physical"
                                                ? null
                                                : () {
                                                    if (stock! >=
                                                            widget.product!
                                                                .minimumOrderQty! ||
                                                        widget.product!
                                                                .productType ==
                                                            "digital") {
                                                      Provider.of<CartController>(
                                                              context,
                                                              listen: false)
                                                          .addToCartAPI(
                                                        cart,
                                                        context,
                                                        widget.product!
                                                            .choiceOptions!,
                                                        Provider.of<ProductDetailsProvider>(
                                                                context,
                                                                listen: false)
                                                            .variationIndex,
                                                      );
                                                    }
                                                  }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                  ]);
            },
          ),
        ),
      ],
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CartScreen()));
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int? quantity;
  final bool isCartWidget;
  final int? stock;
  final int? minimumOrderQuantity;
  final bool digitalProduct;

  const QuantityButton({
    super.key,
    required this.isIncrement,
    required this.quantity,
    required this.stock,
    this.isCartWidget = false,
    required this.minimumOrderQuantity,
    required this.digitalProduct,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!isIncrement && quantity! > 1) {
          if (quantity! > minimumOrderQuantity!) {
            Provider.of<ProductDetailsProvider>(context, listen: false)
                .setQuantity(quantity! - 1);
          } else {
            showCustomSnackBar(
                '${getTranslated('minimum_quantity_is', context)}$minimumOrderQuantity',
                context,
                isToaster: true);
          }
        } else if (isIncrement && quantity! < stock! || digitalProduct) {
          Provider.of<ProductDetailsProvider>(context, listen: false)
              .setQuantity(quantity! + 1);
        }
      },
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(width: 1, color: Theme.of(context).primaryColor)),
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          color: isIncrement
              ? quantity! >= stock! && !digitalProduct
                  ? ColorResources.getLowGreen(context)
                  : ColorResources.getPrimary(context)
              : quantity! > 1
                  ? ColorResources.getPrimary(context)
                  : ColorResources.getTextTitle(context),
          size: isCartWidget ? 26 : 20,
        ),
      ),
    );
  }
}
