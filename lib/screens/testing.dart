import 'package:flutter/material.dart';

class TargetStepsScreen extends StatefulWidget {
  @override
  _TargetStepsScreenState createState() => _TargetStepsScreenState();
}

class _TargetStepsScreenState extends State<TargetStepsScreen> {
  int targetSteps = 1000;
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditing = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Target Steps'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Steps',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a value.';
                }
                final enteredSteps = int.tryParse(value);
                if (enteredSteps != null && enteredSteps >= 1000) {
                  return null; // Valid input
                }
                return 'Targeted steps must be more than 1000.';
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    targetSteps = int.parse(_textEditingController.text);
                    isEditing = false;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Target Steps'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isEditing = true;
                  _textEditingController.text = targetSteps.toString();
                });
                showEditDialog();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text(
                    'Target Steps: $targetSteps',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
