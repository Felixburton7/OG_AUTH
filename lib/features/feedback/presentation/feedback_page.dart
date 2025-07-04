import 'package:flutter/material.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/feedback/data/datasource/feedback_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _mainObjective = '';
  String _featureRequest = '';
  bool _isSubmitting = false;
  double _npsValue = 5.0;
  final List<String> _issuesExperienced = [];
  String _mostUsedFeature = '';
  final TextEditingController _objectiveController = TextEditingController();

  // Obtain an instance of FeedbackSupabaseRepository via dependency injection
  final FeedbackSupabaseRepository _feedbackRepository =
      getIt<FeedbackSupabaseRepository>();

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Save the feedback text from the form
    _formKey.currentState!.save();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      // Prepare the data
      final feedbackData = {
        'user_id': userId,
        'issues_experienced': _issuesExperienced,
        'most_used_feature': _mostUsedFeature,
        'feature_request': _featureRequest,
        'nps_score': _npsValue.round(),
        'main_objective': _mainObjective,
      };

      // Submit feedback using the repository
      await _feedbackRepository.submitFeedback(feedbackData);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );

      // Optionally, navigate back after submission
      Navigator.pop(context);
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List of features for multiple-choice questions
    final List<String> features = [
      'Articles',
      'Live',
      'Leagues',
      'Chats',
      'Profile',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'We value your feedback. Please answer the questions below:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Make the scrollable content flexible
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. UX/UI Question - Multiple-choice (Checkboxes)
                      const Text(
                        'Have you experienced any issues with these features when using the product?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10.0,
                        children: features.map((feature) {
                          return FilterChip(
                            label: Text(feature),
                            selected: _issuesExperienced.contains(feature),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _issuesExperienced.add(feature);
                                } else {
                                  _issuesExperienced.remove(feature);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const Divider(height: 32),

                      // 2. Product Features Question - Single-choice (Radio Buttons)
                      const Text(
                        'Which of these features do you use the most?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: features.map((feature) {
                          return RadioListTile<String>(
                            title: Text(feature),
                            value: feature,
                            groupValue: _mostUsedFeature,
                            onChanged: (value) {
                              setState(() {
                                _mostUsedFeature = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const Divider(height: 32),

                      // 3. Product Roadmap Question - Open-ended
                      const Text(
                        'Which feature would you like us to add to the product next?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your feature request here',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your feature request';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _featureRequest = value!.trim();
                        },
                      ),
                      const Divider(height: 32),

                      // 4. General Product-related Question - NPS (Slider)
                      const Text(
                        'How likely are you to recommend this product to a friend or colleague?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _npsValue,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: _npsValue.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            _npsValue = value;
                          });
                        },
                      ),
                      const Divider(height: 32),

                      // 5. Market and Customer Research Question - Open-ended
                      const Text(
                        'Additional feedback:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _objectiveController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your objective here',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your main objective';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _mainObjective = value!.trim();
                        },
                      ),
                      const Divider(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Submit button
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitFeedback,
                    child: const Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }
}
