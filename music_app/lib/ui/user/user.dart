import 'package:flutter/material.dart';
import 'package:music_app/components/infor_cart.dart';
import 'package:music_app/ui/discovery/discovery.dart';
import 'package:music_app/ui/home/home.dart';
import 'package:music_app/ui/setting.dart';
import 'package:music_app/ui/signup_login_logout/login_page.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  String userName = "Nguyen Quoc Khanh";
  String email = "khanh2408@gmail.com";
  String phone = "0123456789";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF3E5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage('assets/user.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        final updatedInfo = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingPage(
                              name: userName,
                              email: email,
                              phone: phone,
                            ),
                          ),
                        );
                        if (updatedInfo != null) {
                          setState(() {
                            userName = updatedInfo['name'];
                            email = updatedInfo['email'];
                            phone = updatedInfo['phone'];
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.deepPurple,
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 25),
              Divider(
                color: Colors.deepPurple.shade100,
                thickness: 1,
                indent: 40,
                endIndent: 40,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    InforCard(
                      text: "Home",
                      icon: Icons.home_rounded,
                      color: Colors.deepPurple.shade100,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MusicHomePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    InforCard(
                      text: "Album yêu thích",
                      icon: Icons.favorite_border_rounded,
                      color: Colors.deepPurple.shade100,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FavoriteAlbumPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyLoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Đăng xuất',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
