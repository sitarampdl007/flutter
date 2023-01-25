import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lenden_delivery/core/network/api_manager.dart';
import 'package:lenden_delivery/core/services/service_locator.dart';

import '../../core/api/api_list.dart';
import '../../core/theme/assets.dart';

class PrivateImage extends StatefulWidget {
  final String fakeImageUrl;

  PrivateImage({@required this.fakeImageUrl});

  @override
  _PrivateImageState createState() => _PrivateImageState();
}

class _PrivateImageState extends State<PrivateImage> {
  Future _loadImage;
  double _mHeight, _mWidth;
  final ApiManager _apiManager = locator<ApiManager>();
  bool _isInit = true;

  Future<String> getImgUrl() async {
    if (widget.fakeImageUrl == null) {
      try {
        final realImgResponse = await _apiManager.dio
            .get(APIList.privateImageUrl + widget.fakeImageUrl,
                options: Options(
                  headers: {
                    "as": "SELF",
                  },
                ));
        return realImgResponse.data;
      } catch (error) {
        print(error);
        return "noImage";
      }
    } else if (widget.fakeImageUrl.isNotEmpty) {
      return widget.fakeImageUrl;
    } else {
      return 'noImage';
    }
  }

  Widget _buildImgWidget(data) {
    if (data == "noImage") {
      return Image.asset(AssetsSource.userPlaceholder);
    } else {
      return Center(
        child: FadeInImage(
            fadeInCurve: Curves.easeInBack,
            height: _mHeight * 0.25,
            width: _mWidth,
            fit: BoxFit.contain,
            placeholder: AssetImage(
              AssetsSource.imgPlaceholder,
            ),
            image: NetworkImage(
              data,
            ),
            imageErrorBuilder: (ctx, error, stack) {
              return Center(child: Icon(Icons.error));
            }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (_isInit) {
      _loadImage = getImgUrl();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    _mHeight = MediaQuery.of(context).size.height;
    _mWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _loadImage,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: SizedBox(
                    height: 24, width: 24, child: CircularProgressIndicator()),
              )
            : snapshot.hasError
                ? Center(child: Icon(Icons.error))
                : _buildImgWidget(snapshot.data);
      },
    );
  }
}
