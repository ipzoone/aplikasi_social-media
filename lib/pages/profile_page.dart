import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({super.key});

  @override
  State<ProfilePage1> createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  File? _profileImage;
  File? _backgroundImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  Future<void> _pickBackgroundImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _backgroundImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _TopPortion(
              profileImage: _profileImage,
              backgroundImage: _backgroundImage,
              onPickProfile: _pickProfileImage,
              onPickBackground: _pickBackgroundImage,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Saif Ali",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'follow',
                        elevation: 0,
                        label: const Text("Follow"),
                        icon: const Icon(Icons.person_add_alt_1),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'message',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("Message"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ======================= INFO ROW ======================= */

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _InfoItem("Posts", 1),
        _InfoItem("Followers", 4000000),
        _InfoItem("Following", 0),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final int value;
  const _InfoItem(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(title),
      ],
    );
  }
}

/* ======================= TOP PORTION ======================= */

class _TopPortion extends StatelessWidget {
  final File? profileImage;
  final File? backgroundImage;
  final VoidCallback onPickProfile;
  final VoidCallback onPickBackground;

  const _TopPortion({
    required this.profileImage,
    required this.backgroundImage,
    required this.onPickProfile,
    required this.onPickBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: onPickBackground,
          child: Container(
            margin: const EdgeInsets.only(bottom: 50),
            decoration: BoxDecoration(
              image: backgroundImage != null
                  ? DecorationImage(
                      image: FileImage(backgroundImage!),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1503264116251-35a269479413",
                      ),
                      fit: BoxFit.cover,
                    ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: onPickProfile,
            child: CircleAvatar(
              radius: 75,
              backgroundImage: profileImage != null
                  ? FileImage(profileImage!)
                  : const NetworkImage(
                      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80",
                    ) as ImageProvider,
            ),
          ),
        ),
      ],
    );
  }
}
