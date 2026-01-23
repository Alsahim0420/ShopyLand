import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'Where is my order?',
      answer:
          'You can track your order status in the "My Orders" section of your profile. Orders typically ship within 1-2 business days.',
    ),
    FAQItem(
      question: 'How do I return an item?',
      answer:
          'To return an item, go to "My Orders", select the item you want to return, and click "Return Item". You have 30 days from delivery to return items.',
    ),
    FAQItem(
      question: 'Do you ship internationally?',
      answer:
          'Yes, we ship to most countries worldwide. Shipping costs and delivery times vary by location. Check the shipping options at checkout.',
    ),
    FAQItem(
      question: 'Can I change my delivery address?',
      answer:
          'You can change your delivery address before your order ships. Go to "My Orders" and select "Change Address" if the order is still processing.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support Center')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'How can we help you?',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 24),
            // FAQ Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._faqs.map((faq) => _buildFAQItem(faq)),
            const SizedBox(height: 24),
            // Contact Section
            const Text(
              'Still need help?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              icon: Icons.chat_bubble_outline,
              title: 'Live Chat',
              subtitle: 'Wait time: < 2 min',
              color: Colors.pink,
              isAvailable: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Live chat en desarrollo')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildContactOption(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'Response within 24h',
              color: Colors.grey,
              isAvailable: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email support en desarrollo')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildContactOption(
              icon: Icons.phone_outlined,
              title: 'Call Us',
              subtitle: 'Mon-Fri, 9am - 6pm',
              color: Colors.grey,
              isAvailable: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Call support en desarrollo')),
                );
              },
            ),
            const SizedBox(height: 24),
            // Priority Support Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink[400]!, Colors.purple[600]!],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Priority Support',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Join Premium to get instant help anytime.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(faq.question),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(faq.answer, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isAvailable) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isAvailable ? Colors.green : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
