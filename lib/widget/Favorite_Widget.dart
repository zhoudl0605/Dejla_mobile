import 'package:dejla/modules/UserProfile.dart';
import 'package:dejla/services/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class FavoriteWidget extends StatefulWidget {
  FavoriteWidget({Key key, this.path, this.unitID}) : super(key: key);
  final String path;
  final String unitID;

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    String path = widget.path;

    final textTheme = Theme.of(context).textTheme;
    var _profile = Provider.of<ProfileService>(context);

    return Builder(builder: (BuildContext context) {
      UserProfile profile = _profile.profile;
      if (profile == null) return Container();

      Widget favoriteWidget = InkWell(
        child: Icon(
          FontAwesome5.heart,
          size: textTheme.title.fontSize,
        ),
        onTap: () {
          _profile.addFavorite(path);
        },
      );

      if (profile.favorite == null)
        return InkWell(
          child: Icon(
            FontAwesome5.heart,
            size: textTheme.title.fontSize,
            color: Colors.red,
          ),
          onTap: () {
            _profile.addFavorite(path);
          },
        );

      for (final _data in profile.favorite) {
        // If the unit is in the favorite list
        if (_data == path) {
          return InkWell(
            child: Icon(
              FontAwesome.heart,
              size: textTheme.title.fontSize,
              color: Colors.red,
            ),
            onTap: () {
              _profile.removeFavorite(_data);
            },
          );
        }
      }
      return favoriteWidget;
    });
  }
}
