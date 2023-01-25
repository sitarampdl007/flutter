import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/order_detail/simple_detail_model.dart';
import 'card_info_builder.dart';
import 'circle_image_loader.dart';

/// Widget [ProductDetailWidget] : The ProductDetailWidget for showing product detail orders
class ProductDetailWidget extends StatelessWidget {
  final SimpleOrderModel productModel;
  const ProductDetailWidget(this.productModel);

  @override
  Widget build(BuildContext context) {
    var _themeConst = Theme.of(context);
    return CardInfoBuilder(
        description: Column(
          children: [
            Column(
              children: productModel.orderDetails.orderItems
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
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Text(
                "Total",
                style: _themeConst.textTheme.headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "Rs. ${(productModel.orderDetails.orderTotal / 100).toStringAsFixed(2)}",
                style: _themeConst.textTheme.headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        title: "Orders",
        iconType: FontAwesomeIcons.shoppingBag);
  }
}
