import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({super.key, required this.imageUrl, required this.onEdit});
  final String? imageUrl; final VoidCallback onEdit;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Stack(children: [
        CircleAvatar(radius: 42, backgroundColor: const Color(0xFFE6EAF2), backgroundImage: imageUrl != null ? AssetImage(imageUrl!) as ImageProvider : null, child: imageUrl == null ? const Icon(Icons.person, size: 36, color: Color(0xFF98A2B3)) : null),
        PositionedDirectional(bottom: 0, start: 0, child: FloatingActionButton.small(onPressed: onEdit, heroTag: null, child: const Icon(Icons.edit))),
      ]),
    );
  }
}


