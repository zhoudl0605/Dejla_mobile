import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String url;

  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<FirebaseUser>(context) != null)
      url = Provider.of<FirebaseUser>(context).photoUrl;
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProfileAvatar(
                    url != null ? url : "http://????",
                    radius: 18,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    onTap: () {},
                    cacheImage: true,
                    errorWidget: (context, url, error) => Container(
                      child: Icon(
                        AntDesign.user,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                    placeHolder: (context, url) => Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Spacer(),
                  // Expanded(child: Container()),
                  // Replace the child of paddGlobalKeying for different page
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Home",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Spacer(),
                  // Expanded(child: Container()),
                ],
              ),
              // Disable and hide the leading button
              automaticallyImplyLeading: false,
              centerTitle: true,
              pinned: true,
              floating: true,
              // bottom: 
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildListView("aaa:"),
            _buildListView("bbb:"),
            _buildListView("ccc:"),
            _buildListView("ddd:"),
            _buildListView("eee:"),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(String s) {
    return ListView.separated(
        itemCount: 20,
        separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey,
              height: 1,
            ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              color: Colors.white, child: ListTile(title: Text("$s$index")));
        });
  }
}
