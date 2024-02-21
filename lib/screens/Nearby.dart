import 'package:flutter/material.dart';

class NearBy extends StatefulWidget {
  const NearBy();

  @override
  State<NearBy> createState() => _NearByState();
}

class _NearByState extends State<NearBy> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Nearby'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserProfile(
              name: 'User',
              description: 'Some description about User',
              imageUrl: 'assets/user_image.jpg', // Provide image path here
            ),
            _buildUserProfile(
              name: 'User 1',
              description: 'Some description about User 1',
              imageUrl: 'assets/user1_image.jpg', // Provide image path here
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile({required String name, required String description, required String imageUrl}) {
    return SizedBox(
      height: 200,
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imageUrl), // Load user image here
            radius: 30,
          ),
          title: Text(
            name,
            style: TextStyle(fontSize: 24),
          ),
          subtitle: Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(Icons.message), // You can change the icon as needed
            onPressed: () {
              // Implement action when the message icon is pressed
            },
          ),
        ),
      ),
    );
  }
}
