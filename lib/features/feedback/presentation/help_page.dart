import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction text
            const Text(
              'If you need help, please visit our website or email us at info@panna.app.uk.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Help form section
            const Text(
              'Help Form',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Simple help form (TextField and button)
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Theme.of(context).canvasColor,
                labelText: 'Describe your issue',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                child: Text('Submit',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
            ),

            const Spacer(), // Pushes the bottom content to the bottom

            // Long text about the UK Gambling Commission license
            const Text(
              'We are currently in the process of obtaining a license with the UK Gambling Commission. '
              'This means that while we are able to operate, we are still awaiting final approval to comply fully '
              'with all the regulations and legal requirements. Your safety and security are our top priority, and we '
              'are committed to providing a secure and fair experience for all users. For more information, please refer to our website.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
