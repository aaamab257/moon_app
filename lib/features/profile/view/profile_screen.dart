import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/logout_confirm_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/views/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/domain/model/user_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/basewidget/show_custom_snakbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _manteqaController = TextEditingController();
  final TextEditingController _shoptNameController = TextEditingController();
  final TextEditingController _goveNameController = TextEditingController();
  final TextEditingController _hayNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  //String url = "https://wa.me/?text=";

  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  _updateUserAccount() async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel!
                .fName ==
            _firstNameController.text &&
        Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel!
                .lName ==
            _lastNameController.text &&
        Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel!
                .phone ==
            _phoneController.text &&
        file == null &&
        _passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty) {
      showCustomSnackBar(
          getTranslated('change_something_to_update', context), context);
    } else if (firstName.isEmpty || lastName.isEmpty) {
      showCustomSnackBar(getTranslated('name_is_required', context), context);
    } else if (email.isEmpty) {
      showCustomSnackBar(getTranslated('email_is_required', context), context);
    } else if (phoneNumber.isEmpty) {
      showCustomSnackBar(
          getTranslated('phone_must_be_required', context), context);
    } else if ((password.isNotEmpty && password.length < 8) ||
        (confirmPassword.isNotEmpty && confirmPassword.length < 8)) {
      showCustomSnackBar(
          getTranslated('minimum_password_is_8_character', context), context);
    } else if (password != confirmPassword) {
      showCustomSnackBar(
          getTranslated('confirm_password_not_matched', context), context);
    } else {
      UserInfoModel updateUserInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
      updateUserInfoModel.method = 'put';
      updateUserInfoModel.fName = _firstNameController.text;
      updateUserInfoModel.lName = _lastNameController.text;
      updateUserInfoModel.phone = _phoneController.text;
      String pass = _passwordController.text;

      await Provider.of<ProfileProvider>(context, listen: false)
          .updateUserInfo(
        updateUserInfoModel,
        pass,
        file,
        Provider.of<AuthController>(context, listen: false).getUserToken(),
      )
          .then((response) {
        if (response.isSuccess) {
          Provider.of<ProfileProvider>(context, listen: false)
              .getUserInfo(context);
          showCustomSnackBar(
              getTranslated('profile_info_updated_successfully', context),
              context,
              isError: false);

          _passwordController.clear();
          _confirmPasswordController.clear();
          setState(() {});
        } else {
          showCustomSnackBar(response.message ?? '', context, isError: false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      key: _scaffoldKey,
      floatingActionButton:
          Provider.of<AuthController>(context, listen: false).isLoggedIn()
              ? FloatingActionButton(
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/whats_app.png',
                            ),
                            fit: BoxFit.contain)),
                  ),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    String phone = '';
                    String message = "";

                    var whatsappUrl = "whatsapp://send?phone=+20$phone" +
                        "&text=${Uri.encodeComponent(message)}";
                    try {
                      launchUrl(Uri.parse(whatsappUrl));
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                )
              : const SizedBox(),
      appBar: CustomAppBar(
          title: getTranslated('profile', context), isBackButtonExist: false),
      body: Provider.of<AuthController>(context, listen: false).isLoggedIn()
          ? Consumer<ProfileProvider>(
              builder: (context, profile, child) {
                _firstNameController.text = profile.userInfoModel!.fName ?? '';
                _lastNameController.text = profile.userInfoModel!.lName ?? '';
                _emailController.text = profile.userInfoModel!.email ?? '';
                _phoneController.text = profile.userInfoModel!.phone ?? '';

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 55),
                      child: Column(
                        children: [
                          const SizedBox(height: Dimensions.marginSizeDefault),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                  color: ColorResources.getIconBg(context),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Dimensions.marginSizeDefault),
                                    topRight: Radius.circular(
                                        Dimensions.marginSizeDefault),
                                  )),
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  CustomTextField(
                                      labelText:
                                          getTranslated('first_name', context),
                                      inputType: TextInputType.name,
                                      focusNode: _fNameFocus,
                                      nextFocus: _lNameFocus,
                                      hintText:
                                          profile.userInfoModel!.fName ?? '',
                                      controller: _firstNameController),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  CustomTextField(
                                      hintText:
                                          getTranslated('shop_name', context),
                                      labelText:
                                          getTranslated('shop_name', context),
                                      inputType: TextInputType.name,
                                      required: true,
                                      capitalization: TextCapitalization.words,
                                      controller: _shoptNameController,
                                      validator: (value) =>
                                          ValidateCheck.validateEmptyText(
                                              value, "shop_name")),
                                  // CustomTextField(
                                  //     labelText:
                                  //         getTranslated('last_name', context),
                                  //     inputType: TextInputType.name,
                                  //     focusNode: _lNameFocus,
                                  //     nextFocus: _emailFocus,
                                  //     hintText: profile.userInfoModel!.lName,
                                  //     controller: _lastNameController),
                                  // const SizedBox(
                                  //     height: Dimensions.paddingSizeDefault),
                                  // CustomTextField(
                                  //     isEnabled: false,
                                  //     labelText:
                                  //         getTranslated('email', context),
                                  //     inputType: TextInputType.emailAddress,
                                  //     focusNode: _emailFocus,
                                  //     readOnly: true,
                                  //     nextFocus: _phoneFocus,
                                  //     hintText:
                                  //         profile.userInfoModel!.email ?? '',
                                  //     controller: _emailController),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),

                                  CustomTextField(
                                      isEnabled: false,
                                      labelText:
                                          getTranslated('phone', context),
                                      inputType: TextInputType.phone,
                                      focusNode: _phoneFocus,
                                      hintText:
                                          profile.userInfoModel!.phone ?? "",
                                      nextFocus: _addressFocus,
                                      controller: _phoneController,
                                      isAmount: true),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  CustomTextField(
                                      hintText:
                                          getTranslated('government', context),
                                      labelText:
                                          getTranslated('government', context),
                                      inputType: TextInputType.name,
                                      required: true,
                                      capitalization: TextCapitalization.words,
                                      controller: _goveNameController,
                                      validator: (value) =>
                                          ValidateCheck.validateEmptyText(
                                              value, "government")),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  CustomTextField(
                                      hintText: getTranslated('hay', context),
                                      labelText: getTranslated('hay', context),
                                      inputType: TextInputType.name,
                                      required: true,
                                      capitalization: TextCapitalization.words,
                                      controller: _hayNameController,
                                      validator: (value) =>
                                          ValidateCheck.validateEmptyText(
                                              value, "hay")),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  CustomTextField(
                                      hintText:
                                          getTranslated('manteqa', context),
                                      labelText:
                                          getTranslated('manteqa', context),
                                      inputType: TextInputType.name,
                                      required: true,
                                      capitalization: TextCapitalization.words,
                                      controller: _manteqaController,
                                      validator: (value) =>
                                          ValidateCheck.validateEmptyText(
                                              value, "manteqa")),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  CustomTextField(
                                      hintText: getTranslated(
                                          'shop_address', context),
                                      labelText: getTranslated(
                                          'shop_address', context),
                                      inputType: TextInputType.name,
                                      required: true,
                                      capitalization: TextCapitalization.words,
                                      controller: _hayNameController,
                                      validator: (value) =>
                                          ValidateCheck.validateEmptyText(
                                              value, "shop_address")),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  // CustomTextField(
                                  //     isPassword: true,
                                  //     labelText:
                                  //         getTranslated('password', context),
                                  //     hintText: getTranslated(
                                  //         'enter_7_plus_character', context),
                                  //     controller: _passwordController,
                                  //     focusNode: _passwordFocus,
                                  //     nextFocus: _confirmPasswordFocus,
                                  //     inputAction: TextInputAction.next),
                                  // const SizedBox(
                                  //     height: Dimensions.paddingSizeDefault),
                                  // CustomTextField(
                                  //     labelText: getTranslated(
                                  //         'confirm_password', context),
                                  //     hintText: getTranslated(
                                  //         'enter_7_plus_character', context),
                                  //     isPassword: true,
                                  //     controller: _confirmPasswordController,
                                  //     focusNode: _confirmPasswordFocus,
                                  //     inputAction: TextInputAction.done),
                                  ListTile(
                                    leading: SizedBox(
                                        width: 30,
                                        child: Image.asset(
                                          Images.contactUs,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    title: Text(
                                        getTranslated('contact_us', context)!,
                                        style: titilliumRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeLarge)),
                                    onTap: () =>
                                        launchUrlString("tel://21213123123"),
                                  ),
                                  // const SizedBox(
                                  //     height: Dimensions.paddingSizeDefault),
                                  ListTile(
                                    leading: SizedBox(
                                        width: 30,
                                        child: Image.asset(
                                          Images.logOut,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    title: Text(
                                        Provider.of<AuthController>(context,
                                                    listen: false)
                                                .isLoggedIn()
                                            ? getTranslated('sign_in', context)!
                                            : getTranslated(
                                                'sign_out', context)!,
                                        style: titilliumRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeLarge)),
                                    onTap: () {
                                      if (Provider.of<AuthController>(context,
                                              listen: false)
                                          .isLoggedIn()) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AuthScreen()));
                                      } else {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (_) =>
                                                const LogoutCustomBottomSheet());
                                      }
                                    },
                                  ),
                                  // InkWell(
                                  //   onTap: () => showModalBottomSheet(
                                  //       backgroundColor: Colors.transparent,
                                  //       context: context,
                                  //       builder: (_) =>
                                  //           DeleteAccountBottomSheet(
                                  //               customerId: Provider.of<
                                  //                           ProfileProvider>(
                                  //                       context,
                                  //                       listen: false)
                                  //                   .userID)),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.start,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.center,
                                  //     children: [
                                  //       Container(
                                  //           alignment: Alignment.center,
                                  //           height: Dimensions.iconSizeSmall,
                                  //           child: Image.asset(Images.delete)),
                                  //       const SizedBox(
                                  //         width: Dimensions.paddingSizeDefault,
                                  //       ),
                                  //       Text(
                                  //         getTranslated(
                                  //             'delete_account', context)!,
                                  //         style: textRegular.copyWith(),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.marginSizeLarge,
                                vertical: Dimensions.marginSizeSmall),
                            child:
                                !Provider.of<ProfileProvider>(context).isLoading
                                    ? CustomButton(
                                        onTap: _updateUserAccount,
                                        buttonText: getTranslated(
                                            'update_profile', context))
                                    : Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor))),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          : const NotLoggedInWidget(),
    );
  }
}
