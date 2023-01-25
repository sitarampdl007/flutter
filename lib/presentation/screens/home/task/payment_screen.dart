import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/assets.dart';
import '../../../../features/order_detail/order_detail_provider.dart';
import '../../../widgets/circle_image_loader.dart';
import '../../../widgets/task_buttons.dart';

class PaymentScreen extends StatefulWidget {
  final FullOrderDetail loadedOrder;
  final Function changeScreen;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const PaymentScreen(
      {Key key, this.loadedOrder, this.changeScreen, this.scaffoldKey})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  //vars
  final _imagePicker = ImagePicker();
  File _storedImage;
  var _signatureImage;
  final SignatureController _controller = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 5,
      exportBackgroundColor: Colors.white);

  //UI
  ThemeData _themeConst;
  MediaQueryData _mediaConst;
  double _mHeight, _mWidth;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  /// FUNC [_takePicture] : Taking picture using image picker
  Future<void> _takePicture() async {
    final image =
        await _imagePicker.getImage(source: ImageSource.camera, maxWidth: 600);
    if (image != null) {
      setState(() {
        _storedImage = File(image.path);
      });
    }
  }

  /// FUNC [_getSignImage] : Get sign image from signature
  Future<void> _getSignImage(Uint8List pngData) async {
    if (pngData != null) {
      setState(() {
        _signatureImage = pngData;
      });
    }
  }

  /// FUNC [_signatureDialog] : Dialog for signature
  void _signatureDialog() {
    showDialog(
        context: context,
        builder: (dCtx) {
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            title: Text(
              "Please sign within the box!",
              style: _themeConst.textTheme.subtitle1.copyWith(
                  color: LendenAppTheme.grey, fontWeight: FontWeight.w400),
            ),
            content: Container(
              height: _mHeight * 0.39,
              width: _mWidth * 0.5,
              child: Column(children: [
                Signature(
                  controller: _controller,
                  height: _mHeight * 0.32,
                  width: _mWidth * 0.65,
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: _mHeight * 0.005,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(
                      onPressed: () async {
                        if (_controller.isNotEmpty) {
                          final Uint8List data = await _controller.toPngBytes();
                          _getSignImage(data);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Done",
                        style: _themeConst.textTheme.subtitle2.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                      color: LendenAppTheme.greenColor,
                    ),
                    FlatButton(
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _signatureImage = null;
                        });
                      },
                      child: Text(
                        "Clear",
                        style: _themeConst.textTheme.subtitle2.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                      color: LendenAppTheme.greenColor,
                    )
                  ],
                ),
              ]),
            ),
          );
        });
  }

  void _finishPayment() async {
    try {
      setState(() {
        _isLoading = true;
      });
      //save signature temporarily
      File signature;
      if (_signatureImage != null) {
        String dir = (await getTemporaryDirectory()).path;
        String fileName = "SIGN_" + DateTime.now().toIso8601String();
        String filePath = "$dir/$fileName.png";
        signature = await File(filePath).create();
        // save file
        await signature.writeAsBytes(_signatureImage);
      }
      final response = await widget.changeScreen(
          "DELIVERED", widget.loadedOrder, _storedImage, signature);
      _showCompleteDialog();
    } catch (error) {
      print(error);
      widget.scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Sorry, couldnot proceed to update the order. Please try again!",
          textAlign: TextAlign.center,
          style: _themeConst.textTheme.subtitle1.copyWith(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: 4),
        backgroundColor: _themeConst.errorColor,
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  /// FUNC [_signatureDialog] : Dialog for complete payment
  void _showCompleteDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(AssetsSource.doneLottie,
                height: 100, width: 100, fit: BoxFit.contain, repeat: false),
            Text(
              "Delivery successfully completed!",
              style: _themeConst.textTheme.subtitle1.copyWith(
                  color: LendenAppTheme.grey, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        content: Container(
          height: _mHeight * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Thank you for your service. Please proceed to ongoing tasks.",
                textAlign: TextAlign.center,
                style: _themeConst.textTheme.subtitle2.copyWith(
                    color: LendenAppTheme.grey, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: _mHeight * 0.005,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(dCtx).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Okay",
                    style: _themeConst.textTheme.subtitle2.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  color: LendenAppTheme.greenColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    _themeConst = Theme.of(context);
    _mediaConst = MediaQuery.of(context);
    _mHeight = _mediaConst.size.height;
    _mWidth = _mediaConst.size.width;
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Validate Delivery".toUpperCase(),
                  style: _themeConst.textTheme.subtitle2.copyWith(
                      color: LendenAppTheme.grey, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: _mHeight * 0.012,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: _takePicture,
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        alignment: Alignment.center,
                        child: _storedImage == null
                            ? const Text(
                                "No Image Taken",
                                textAlign: TextAlign.center,
                              )
                            : Image.file(
                                _storedImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    ),
                    InkWell(
                      onTap: _signatureDialog,
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        alignment: Alignment.center,
                        child: _signatureImage == null
                            ? Text(
                                "Customer Sign",
                                textAlign: TextAlign.center,
                              )
                            : Image.memory(
                                _signatureImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _mHeight * 0.012,
                ),
                Divider(
                  height: _mHeight * 0.02,
                  thickness: 2,
                ),
                Text(
                  "Ordered Items".toUpperCase(),
                  style: _themeConst.textTheme.subtitle2.copyWith(
                      color: LendenAppTheme.grey, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: _mHeight * 0.012,
                ),
                Column(
                  children: widget
                      .loadedOrder.simpleOrderModel.orderDetails.orderItems
                      .map((prod) => ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            leading: CircleImageLoader(
                              radius: 20,
                              fakeImageUrl: prod.productImage.contains("[")
                                  ? jsonDecode(prod.productImage)[0]
                                  : prod.productImage,
                            ),
                            title: Text(
                              prod.productName,
                              style: _themeConst.textTheme.subtitle1,
                            ),
                            trailing: Text(
                              "x ${prod.quantity}",
                              style: _themeConst.textTheme.subtitle1,
                            ),
                          ))
                      .toList(),
                ),
                Divider(
                  height: _mHeight * 0.02,
                  thickness: 2,
                ),
                SizedBox(
                  height: _mHeight * 0.012,
                ),
                Text(
                  "Transaction value".toUpperCase(),
                  style: _themeConst.textTheme.subtitle2.copyWith(
                      color: LendenAppTheme.grey, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: _mHeight * 0.012,
                ),
                ListTile(
                  title: Text(
                    "Payment Mode",
                    style: _themeConst.textTheme.subtitle2
                        .copyWith(color: LendenAppTheme.grey),
                  ),
                  trailing: Text(
                    "COD",
                    style: _themeConst.textTheme.subtitle2
                        .copyWith(color: LendenAppTheme.grey),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    "Total",
                    style: _themeConst.textTheme.headline6
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "Rs. ${(widget.loadedOrder.simpleOrderModel.orderDetails.orderTotal / 100).toStringAsFixed(2)}",
                    style: _themeConst.textTheme.headline6
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        TaskButtons(
          title: "Complete Payment",
          onTap: _finishPayment,
          btnColor: LendenAppTheme.greenColor,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
