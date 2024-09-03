import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 18, 32),
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: const Color.fromARGB(255, 20, 18, 32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for Univerx',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              
              SizedBox(height: 16),
              Text(
                '1. Introduction\n\n'
                'Welcome to Univerx! We value your privacy and are committed to protecting your personal information. '
                'This Privacy Policy explains how we handle your data and provides information on our practices regarding '
                'data collection, storage, and use.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Text(
                '2. Data Collection\n\n'
                'At Univerx, we do not collect any personal data from you. Your privacy is important to us, and we are dedicated '
                'to ensuring that your personal information remains private.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Text(
                '3. Data Storage\n\n'
                'All information generated or used within the Univerx app is stored locally on your device. We do not transmit '
                'or store any data on external servers. This means that your data remains private and secure on your device.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Text(
                '4. Changes to This Policy\n\n'
                'We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated '
                'effective date. Please review this policy periodically for any changes.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Text(
                '5. Contact Us\n\n'
                'If you have any questions or concerns about this Privacy Policy, please contact us at univerxapp@gmail.com.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
