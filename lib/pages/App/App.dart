import 'package:dejla/pages/App/Explore/Explore.dart';
import 'package:dejla/pages/App/Me/Me.dart';
import 'package:dejla/pages/App/Saved/Saved.dart';
import 'package:dejla/pages/App/components/Drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';

class APP extends StatefulWidget {
  APP({Key key}) : super(key: key);

  @override
  _APPState createState() => _APPState();
}

class _APPState extends State<APP> with TickerProviderStateMixin {
  TabController tabController;
  bool showalert = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  static List<Widget> _pageOptions = <Widget>[
    ExplorePage(),
    // HomePage(),
    SavedPage(),
    Me(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    void _onItemTapped(int index) {
      if (user == null) {
        setState(() {
          tabController.index = 0;
          showalert = true;
        });
      }
    }

    return Scaffold(
      drawer: SearchDrawer(),
      body: GFFloatingWidget(
        showblurness: showalert,
        verticalPosition: MediaQuery.of(context).size.height / 3,
        child: showalert == false
            ? Container()
            : GFAlert(
                title: 'Dear guest',
                content: 'Some features might require you login your account,' +
                    ' please choose the following two options to continue',
                bottombar: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GFButton(
                      onPressed: () {
                        setState(() {
                          showalert = false;
                        });
                        Navigator.of(context).pushNamed('/login');
                      },
                      shape: GFButtonShape.pills,
                      text: 'Login',
                    ),
                    SizedBox(width: 5),
                    GFButton(
                      onPressed: () {
                        setState(() {
                          showalert = false;
                        });
                        Navigator.of(context).pushNamed('/signup');
                      },
                      shape: GFButtonShape.pills,
                      text: 'Sign up',
                    )
                  ],
                ),
              ),
        body: TabBarView(
          controller: tabController,
          children: _pageOptions,
        ),
      ),
      bottomNavigationBar: TabBar(
        labelColor: GFColors.PRIMARY,
        controller: tabController,
        tabs: [
          Tab(
            icon: Icon(Icons.search),
            child: Text(
              "Explore",
            ),
          ),
          Tab(
            icon: Icon(Icons.favorite),
            child: Text(
              "Favorite",
            ),
          ),
          Tab(
            icon: Icon(Icons.person),
            child: Text(
              "Me",
            ),
          ),
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
