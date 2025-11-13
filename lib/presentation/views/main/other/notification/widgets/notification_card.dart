import 'package:flutter/material.dart';

import '../../../../../../core/constant/strings.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.notifications),
        title: const Text(notificationTitle),
        subtitle: const Text(notificationMessage),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle tap
        },
      ),
    );
  }
}
