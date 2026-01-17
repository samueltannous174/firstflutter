import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'User';
    final username = email.split('@')[0];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(username, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple.shade200,
              child: Text(
                username[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '@$username',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Stats Row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Following', value: '142'),
                _StatItem(label: 'Followers', value: '10.5k'),
                _StatItem(label: 'Likes', value: '45.2k'),
              ],
            ),
            const SizedBox(height: 24),

            // Edit Profile Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomButton(
                text: 'Edit Profile',
                onPressed: () {},
                color: Colors.grey[900],
                textColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Bio Section
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'about_me');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                         Text(
                          'About Me',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
                      ],
                    ),
                     SizedBox(height: 8),
                     Text(
                      'Creating awesome Flutter content! 🚀\nLover of mobile dev and coffee. ☕️\nCheck out my reels below! 👇',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
             const SizedBox(height: 24),
             const Divider(color: Colors.white24),
             
             // Placeholder for user's reels grid
             GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[900],
                  child: Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                );
              },
             ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
