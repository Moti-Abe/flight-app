import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/inbox_empty_state.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      title: const Text(
        "Inbox",
        style: TextStyle(
          color: Color(0xFF1E1E2D),
          fontWeight: FontWeight.w700,
          fontSize: 26,
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: "Notifications"),
          Tab(text: "Messages"),
        ],
        labelColor: const Color(0xFF2B6EF3),
        unselectedLabelColor: const Color(0xFF5E5E73),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        indicatorColor: const Color(0xFF2B6EF3),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    ),
    body: TabBarView(
      controller: _tabController,
      children: [
        InboxEmptyState(
          icon: Icons.notifications_none,
          title: "No notifications yet",
          message: "Turn on push notifications so you don't miss alerts about your trips and account.",
          primaryCta: "Turn on push notifications",
          onPrimary: () => Get.snackbar("Notifications", "Demo setup not connected yet"),
        ),
        InboxEmptyState(
          icon: Icons.chat_bubble_outline,
          title: "No messages yet",
          message: "Hotels and properties can message you here after you book a stay.",
        ),
      ],
    ),
  );
}
