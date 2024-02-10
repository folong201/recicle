import "package:flutter/material.dart";
import "package:recicle/screens/Home/DefaultHome.dart";
import "package:recicle/screens/Home/MessageScreen.dart";
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(userEmail ?? "No email found"),
              onTap: () {
                // TODO: Add functionality for Item 1
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // TODO: Add functionality for Item 2
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                AuthService().signOut();
                Navigator.pushNamed(context, "/login");
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const DefaultHome(),
          const MessageScreen(),
          Dashboard(),
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
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
