import 'package:flutter/material.dart';

class StepsScreen extends StatefulWidget {
  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  int targetSteps = 1000;
  // Target number of steps
  final int currentSteps = 500;
  // Current number of steps
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Step Tracker',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TODAY'S STEPS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 26),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[100],
                  ),
                ),
                Container(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    value: currentSteps / targetSteps,
                    strokeWidth: 20,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Text(
                  currentSteps.toString(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 26),
            Text('Daily Goal:'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' $targetSteps',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' Steps',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: Colors.blueAccent,
                    size: 18,
                  ),
                  onTap: () {
                    setState(() {
                      isEditing = true;
                      _textEditingController.text = targetSteps.toString();
                    });
                    showEditDialog();
                  },
                )
              ],
            ),
            SizedBox(height: 46),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.black12, width: 2)),
              height: 150,
              child: Center(
                child: Text(' AdMob Ad'),
              ),
            )
          ],
        ),
      ),
    );
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
}
