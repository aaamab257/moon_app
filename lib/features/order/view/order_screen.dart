import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/paginated_list_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widget/order_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/widget/order_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  final bool isBacButtonExist;
  const OrderScreen({super.key, this.isBacButtonExist = true});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController scrollController = ScrollController();
  bool isGuestMode =
      !Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn();
  @override
  void initState() {
    if (!isGuestMode) {
      Provider.of<OrderProvider>(context, listen: false)
          .setIndex(0, notify: false);
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderList(1, 'ongoing');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: getTranslated('order', context),
          isBackButtonExist: widget.isBacButtonExist),
      body: isGuestMode
          ? const NotLoggedInWidget()
          : Consumer<OrderProvider>(builder: (context, orderProvider, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Text('أجمالي الطلبات'),
                        const Spacer(),
                        Text(
                          '${orderProvider.orderModel?.orders!.length}',
                        ),
                        // OrderTypeButton(text: getTranslated('RUNNING', context), index: 0),
                        // const SizedBox(width: Dimensions.paddingSizeSmall),
                        // OrderTypeButton(text: getTranslated('DELIVERED', context), index: 1),
                        // const SizedBox(width: Dimensions.paddingSizeSmall),
                        // OrderTypeButton(text: getTranslated('CANCELED', context), index: 2),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text('أجمالي قيمة الطلبات المستلمة هذا الشهر'),
                        Spacer(),
                        Text(
                          '3000 ج م ',
                        ),
                        // OrderTypeButton(text: getTranslated('RUNNING', context), index: 0),
                        // const SizedBox(width: Dimensions.paddingSizeSmall),
                        // OrderTypeButton(text: getTranslated('DELIVERED', context), index: 1),
                        // const SizedBox(width: Dimensions.paddingSizeSmall),
                        // OrderTypeButton(text: getTranslated('CANCELED', context), index: 2),
                      ],
                    ),
                  ),
                  Expanded(
                      child: orderProvider.orderModel != null
                          ? (orderProvider.orderModel!.orders != null &&
                                  orderProvider.orderModel!.orders!.isNotEmpty)
                              ? SingleChildScrollView(
                                  controller: scrollController,
                                  child: PaginatedListView(
                                    scrollController: scrollController,
                                    onPaginate: (int? offset) async {
                                      await Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .getOrderList(offset!,
                                              orderProvider.selectedType);
                                    },
                                    totalSize:
                                        orderProvider.orderModel?.totalSize,
                                    offset: orderProvider.orderModel?.offset !=
                                            null
                                        ? int.parse(
                                            orderProvider.orderModel!.offset!)
                                        : 1,
                                    itemView: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: orderProvider
                                          .orderModel?.orders!.length,
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (context, index) =>
                                          OrderWidget(
                                              orderModel: orderProvider
                                                  .orderModel?.orders![index]),
                                    ),
                                  ),
                                )
                              : const NoInternetOrDataScreen(
                                  isNoInternet: false,
                                  icon: Images.noOrder,
                                  message: 'no_order_found',
                                )
                          : const OrderShimmer())
                ],
              );
            }),
    );
  }
}
