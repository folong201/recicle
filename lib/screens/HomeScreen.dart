import "package:flutter/material.dart";
import "package:recicle/screens/Home/DefaultHome.dart";
import "package:recicle/screens/Home/MessageScreen.dart";
import 'package:recicle/screens/Home/Dashboard.dart';
import "package:recicle/screens/Home/Settings.dart";
import "package:recicle/services/Auth_Services.dart";
import "package:recicle/services/helper_function.dart";

class HomeScreen extends StatefulWidget {
  // const HomeScreen({required Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? userEmail;
  final PageController _pageController = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setParams();
  }

  setParams() async {
    userEmail = await HelperFunction.getUserEmailSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Recicle")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('URL_DE_L_IMAGE'),
                    radius: 49,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "userEmail",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              selectedColor: Colors.blue,
              title: Text(userEmail ?? "No email found"),
              onTap: () {
                // TODO: Add functionality for Item 1
              },
            ),
            ListTile(
              selectedColor: Colors.blue,
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.pushNamed(context, "/editProfile");
              },
            ),
            ListTile(
              selectedColor: Colors.blue,
              title: const Text('Logout'),
              onTap: () {
                AuthService().signOut();
                Navigator.pushNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const DefaultHome(),
          const MessageScreen(),
          Dashboard(),
          // const SettingsScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_sharp),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'dashboard',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
