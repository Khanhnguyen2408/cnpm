import 'package:flutter/material.dart';
import 'package:music_app/components/infor_cart.dart';
import 'package:music_app/ui/discovery/discovery.dart';
import 'package:music_app/ui/home/home.dart';
import 'package:music_app/ui/signup_login_logout/login_page.dart';

class UserTab extends StatelessWidget {
  const UserTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.purple.shade100,
              child: const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('assets/user.png'),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Nguyen Quoc Khanh",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "khanh2408@gmail.com",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.purple.shade100, thickness: 1.5, indent: 50, endIndent: 50),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InforCard(
                    text: "Home",
                    icon: Icons.home,
                    color: Colors.purple.shade200,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MusicHomePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  InforCard(
                    text: "Album",
                    icon: Icons.album,
                    color: Colors.purple.shade200,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiscoveryTab(favoriteSongs: []),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 900,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyLoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'LOG OUT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
