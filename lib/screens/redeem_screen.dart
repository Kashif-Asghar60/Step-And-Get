import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_n_get/screens/data_details.dart';
import 'package:intl/intl.dart';

import '../provider/pointsprovider.dart';
import '../provider/userauth.dart';

class RedeemScreen extends StatefulWidget {
  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  List<Redemption> redemptions = [];
  String? selectedOption;
  int availablePoints = 0;

  @override
  void initState() {
    super.initState();
    _fetchRedemptions();
    _fetchAvailablePoints();
    Future.delayed(Duration(seconds: 2), () {
      // Fetch the current user ID from UserProvider
      String? userId = context.read<UserProvider>().userId;
      print("ussrrr zaa  $userId");

      if (userId != null) {
        // Call fetchPoints with the user ID
        context.read<PointsProvider>().fetchTotalPoints(userId);
      }
    });
  }

  void _fetchAvailablePoints() {
    // Fetch the user's available points from your PointsProvider
    availablePoints = context.read<PointsProvider>().points;
  }

  Future<void> _fetchRedemptions() async {
    final userId = context.read<UserProvider>().userId;
    if (userId != null) {
      final redemptionsQuery = FirebaseFirestore.instance
          .collection('redemptions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true);

      final snapshots = await redemptionsQuery.get();

      setState(() {
        redemptions = snapshots.docs.map((doc) {
          return Redemption.fromDocument(doc);
        }).toList();
      });
    }
  }

  Widget build(BuildContext context) {
    final pointsProvider = context.watch<PointsProvider>();
    var streamuserid = context.read<UserProvider>().userId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Redeem',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        //  crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            'Points', // Replace with the actual points value
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<int>(
            stream: context
                .read<PointsProvider>()
                .streamTotalPoints(streamuserid!), // Use the stream here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final points = snapshot.data ?? 0;
                return Text(
                  '$points',
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  _showRedemptionBottomSheet(context);
                },
                child: const Text(
                  'Choose Redemption',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: redemptions.length,
              itemBuilder: (context, index) {
                final redemption = redemptions[index];
                return Card(
                  child: ListTile(
                    title: Text(redemption.phoneNumber),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          redemption.option,
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          /*  isRedeemed ? 'Redeemed' : 'Pending', */
                          "Points : ${redemption.points}",
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Text(
                          redemption.isredeemed ? 'Redeemed' : 'Pending',
                          style: TextStyle(
                            color: redemption.isredeemed
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(DateFormat('yyyy-MM-dd ')
                            .format(redemption.timestamp.toDate())),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showRedemptionBottomSheet(BuildContext context) {
  bool loading = false;
  TextEditingController phoneNumberController = TextEditingController();
  String? selectedOption;
  int? selectedPoints;
  int availablePoints =
      context.read<PointsProvider>().points; // Fetch available points

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Redemption",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DataDetails()),
                    );
                  },
                  child: Text(
                    ' See Data Table',
                    style: TextStyle(
                      color: Colors.pink,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedOption,
                  hint: Text("Select an option"),
                  items: ["Airtime", "Data", "Mobile Money"].map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
                DropdownButton<int>(
                  value: selectedPoints,
                  hint: Text("Select Points"),
                  items: _buildDropdownItems(availablePoints),
                  onChanged: (value) {
                    setState(() {
                      selectedPoints = value;
                    });
                  },
                ),
                TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Phone Number"),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () async {
                          setState(() {
                            loading = true;
                          });
                          if (selectedOption != null &&
                              selectedPoints != null) {
                            final int? redemptionPoints = selectedPoints;
                            if (redemptionPoints! <= availablePoints) {
                              String phoneNumber = phoneNumberController.text;
                              final userId =
                                  context.read<UserProvider>().userId;
                              if (userId != null) {
                                // Add the redemption to Firestore
                                await FirebaseFirestore.instance
                                    .collection('redemptions')
                                    .add({
                                  'userId': userId,
                                  'option': selectedOption,
                                  'phoneNumber': phoneNumber,
                                  'points': redemptionPoints.toString(),
                                  'isRedeemed': false,
                                  'timestamp': FieldValue
                                      .serverTimestamp(), // Add a timestamp
                                });

                                // Update the points in your PointsProvider
                                await context
                                    .read<PointsProvider>()
                                    .updatePoints(userId, -redemptionPoints);

                                // Update the state of the _RedeemScreenState class
                                setState(() {
                                  // Update the availablePoints variable
                                  availablePoints -= redemptionPoints!;
                                });
                                Navigator.of(context).pop();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Not enough available points for redemption."),
                                ),
                              );
                            }
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text("Submit"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.pinkAccent),
                  ),
                  child: Text("Cancel"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

List<DropdownMenuItem<int>> _buildDropdownItems(int availablePoints) {
  final List<int> redemptionOptions = [600, 1500, 3000, 6000];
  List<DropdownMenuItem<int>> items = [];
  for (int option in redemptionOptions) {
    if (availablePoints >= option) {
      items.add(DropdownMenuItem(
        value: option,
        child: Text("$option Points"),
      ));
    }
  }

  return items;
}

class Redemption {
  final String id;
  final String userId;
  final String phoneNumber;
  final String points;
  final String
      option; // Add the selected option (e.g., airtime, data, mobile money)
  final bool isredeemed;
  final Timestamp timestamp; // Add a timestamp

  Redemption({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.points,
    required this.option,
    required this.isredeemed,
    required this.timestamp, // Initialize the timestamp
  });

  factory Redemption.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Redemption(
      id: doc.id,
      userId: data['userId'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      points: data['points'] ?? '',
      option: data['option'] ?? '', // Retrieve the selected option
      isredeemed: data['isRedeemed'] ?? false,
      timestamp: data['timestamp'] ?? Timestamp.now(), // Retrieve the timestamp
    );
  }
}
