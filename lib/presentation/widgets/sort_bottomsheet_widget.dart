import 'package:flutter/material.dart';
import 'package:lenden_delivery/features/order/order_provider.dart';
import 'package:provider/provider.dart';

class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  // vars
  Sort _sortingValue;

  @override
  Widget build(BuildContext context) {
    double _mHeight = MediaQuery.of(context).size.height;
    final historyProvider = Provider.of<OrderProvider>(context, listen: false);
    _sortingValue = historyProvider.historySorting;
    return Container(
      height: _mHeight * 0.2,
      color: Color(0xFF737373),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Column(
          children: [
            RadioListTile(
              title: Text("Newest to Oldest"),
              groupValue: _sortingValue,
              value: Sort.NewToOld,
              onChanged: (Sort value) {
                setState(() {
                  _sortingValue = value;
                });
                print(value);
                historyProvider.toggleSorting(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: Text("Oldest to Newest"),
              groupValue: _sortingValue,
              value: Sort.OldToNew,
              onChanged: (Sort value) {
                setState(() {
                  _sortingValue = value;
                });
                historyProvider.toggleSorting(value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
