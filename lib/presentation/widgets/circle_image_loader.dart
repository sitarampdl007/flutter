import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lenden_delivery/core/network/api_manager.dart';
import 'package:lenden_delivery/core/services/service_locator.dart';

import '../../core/api/api_list.dart';
import '../../core/theme/assets.dart';
import '../../core/utilities/prefs_helper.dart';

/// Widget [CircleImageLoader] : The CircleImageLoader helps get the private image url and display them
class CircleImageLoader extends StatefulWidget {
  final String fakeImageUrl;
  final double radius;
  final String type;

  const CircleImageLoader(
      {@required this.fakeImageUrl, @required this.radius, this.type});

  @override
  _CircleImageLoaderState createState() => _CircleImageLoaderState();
}

class _CircleImageLoaderState extends State<CircleImageLoader> {
  final ApiManager _apiManager = locator<ApiManager>();
  Future _loadImage;
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
        if (widget.type == "profilePicture") {
          //save to shared
          PrefsHelper.setProfilePicPrefs(realImgResponse.data);
        }
        return realImgResponse.data;
      } catch (error) {
        print(error);
        return "noImage";
      }
    } else if (widget.fakeImageUrl.isNotEmpty) {
      return widget.fakeImageUrl;
    } else {
      return widget.type == 'profilePicture' ? 'userAvatar' : 'noImage';
    }
  }

  Widget _buildImgWidget(data, double radius) {
    if (data == "userAvatar") {
      return Image.asset(AssetsSource.userPlaceholder);
    } else if (data == "noImage") {
      return Image.asset(AssetsSource.imgPlaceholder);
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: FadeInImage(
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            fadeInCurve: Curves.easeInBack,
            image: NetworkImage(
              data,
            ),
            placeholder: AssetImage(
              AssetsSource.imgPlaceholder,
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
    return FutureBuilder(
      future: _loadImage,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return CircleAvatar(
          child: snapshot.connectionState == ConnectionState.waiting
              ? CircularProgressIndicator(
                  strokeWidth: 2,
                )
              : snapshot.hasError
                  ? Icon(Icons.error)
                  : _buildImgWidget(snapshot.data, widget.radius),
          radius: widget.radius,
        );
      },
    );
  }
}
