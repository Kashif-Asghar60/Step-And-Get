import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PointsProvider extends ChangeNotifier {
  int _points = 0;
  Map<String, int> _dailyPoints = {}; // Store points earned per day

  int get points => _points;

  Map<String, int> get dailyPoints => _dailyPoints;

  void addPoints(int amount) {
    _points += amount;
    notifyListeners();
  }

  Future<void> fetchTotalPoints(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> totalPointsDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('points')
              .doc('totalpoints')
              .get();

      if (totalPointsDoc.exists) {
        final pointsData = totalPointsDoc.data();
        if (pointsData != null && pointsData.containsKey('points')) {
          _points = pointsData['points'];
          notifyListeners();
        }
      }
    } catch (error) {
      print('Error fetching total points: $error');
    }
  }

  Future<int> fetchDailyPoints(String userId, DateTime date) async {
    try {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final DocumentSnapshot<Map<String, dynamic>> dailyPointsDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('points')
              .doc('daily_points')
              .collection(formattedDate)
              .doc('points')
              .get();

      if (dailyPointsDoc.exists) {
        final dailyPointsData = dailyPointsDoc.data();
        if (dailyPointsData != null && dailyPointsData.containsKey('points')) {
          // Return the fetched points as a Future<int>
          return dailyPointsData['points'];
        }
      }
      // Return 0 if no data was found
      return 0;
    } catch (error) {
      print('Error fetching daily points: $error');
      // Return 0 in case of an error
      return 0;
    }
  }
//
  Stream<int> streamDailyPoints(String userId, DateTime date) {
  try {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    Stream<DocumentSnapshot<Map<String, dynamic>>> dailyPointsStream =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('points')
            .doc('daily_points')
            .collection(formattedDate)
            .doc('points')
            .snapshots();

    return dailyPointsStream.map((dailyPointsDoc) {
      if (dailyPointsDoc.exists) {
        final dailyPointsData = dailyPointsDoc.data();
        if (dailyPointsData != null &&
            dailyPointsData.containsKey('points')) {
          return dailyPointsData['points'];
        }
      }
      return 0; // Data not found
    });
  } catch (error) {
    print('Error fetching daily points: $error'); // Log the error
    return Stream<int>.value(0);
  }
}

  Stream<int> streamTotalPoints(String userId) {
    try {
      // Create a stream that listens to changes in the total points document
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Replace 'userId' with the actual user ID
          .collection('points')
          .doc('totalpoints')
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final totalPointsData = snapshot.data() as Map<String, dynamic>;
          if (totalPointsData.containsKey('points')) {
            return totalPointsData['points'] as int;
          }
        }
        return 0; // Return 0 if data is missing or not in the expected format
      });
    } catch (error) {
      print('Error streaming total points: $error');
      return Stream<int>.value(
          0); // Return a stream with a default value in case of an error
    }
  }

  Future<void> updatePoints(String userId, int additionalPoints) async {
    try {
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Reference to the daily points document
      DocumentReference dailyPointsDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('points')
          .doc('daily_points')
          .collection(formattedDate)
          .doc('points');

      // Check if the daily points document exists
      bool dailyPointsDocExists = (await dailyPointsDocRef.get()).exists;

      // Update the daily points document or create it if it doesn't exist
      await dailyPointsDocRef
          .set({'points': additionalPoints}, SetOptions(merge: true));

      // Update the total points under .collection('users').doc(userId).collection('points').totalpoints
      final DocumentReference totalPointsDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('points')
          .doc('totalpoints');

      // Fetch the current total points
      DocumentSnapshot<Object?> totalPointsDoc = await totalPointsDocRef.get();

      if (totalPointsDoc.exists) {
        final totalPointsData = totalPointsDoc.data() as Map<String, dynamic>;
        if (totalPointsData.containsKey('points')) {
          final currentTotalPoints = totalPointsData['points'] as int;
          final newTotalPoints = currentTotalPoints + additionalPoints;

          // Update the total points
          await totalPointsDocRef
              .set({'points': newTotalPoints}, SetOptions(merge: true));
        }
      } else {
        // Create the 'totalpoints' document if it doesn't exist
        await totalPointsDocRef.set({'points': additionalPoints});
      }

      notifyListeners();
    } catch (error) {
      print('Error updating points: $error');
    }
  }
}
