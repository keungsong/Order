import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order/Providers/store_provider.dart';
import 'package:order/widgets/image_slide.dart';
import 'package:order/widgets/my_appbar.dart';
import 'package:provider/provider.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor-screen';
  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: Icon(CupertinoIcons.search))
                  ],
                  title: Text(
                    _store.selectedStore,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              ];
            },
            body: Column(
              children: [VendorHomeScreen()],
            )));
  }
}
