import 'package:flutter/material.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _gradientAppBar('Help & Support'),
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _supportTile(
            icon: Icons.call,
            title: 'Call Support',
            subtitle: '+91 98765 43210',
          ),
          _supportTile(
            icon: Icons.email,
            title: 'Email Us',
            subtitle: 'support@yourapp.com',
          ),
          _supportTile(
            icon: Icons.chat,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
          ),

          const SizedBox(height: 20),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _faqTile(
            'How do I track my order?',
            'Go to My Orders and select the order to track.',
          ),
          _faqTile(
            'How can I cancel an order?',
            'Orders can be cancelled before they are shipped.',
          ),
          _faqTile(
            'When will I get my refund?',
            'Refunds are processed within 5–7 working days.',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _gradientAppBar(String title) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _supportTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {},
      ),
    );
  }

  Widget _faqTile(String question, String answer) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(answer, style: const TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
