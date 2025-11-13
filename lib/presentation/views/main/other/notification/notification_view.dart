import 'package:eshop/presentation/views/main/other/notification/widgets/notification_card.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/strings.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(notifications),
      ),
      body: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return NotificationCard();
        },
      ),
    );
  }
}
