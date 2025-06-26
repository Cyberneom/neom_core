import 'package:cloud_firestore/cloud_firestore.dart';
import '../../app_config.dart';
import '../../domain/model/user_subscription.dart';

import '../../utils/enums/cancellation_reason.dart';
import '../../utils/enums/subscription_status.dart';
import 'constants/app_firestore_collection_constants.dart';
import 'constants/app_firestore_constants.dart';

class UserSubscriptionFirestore {

  final userSubscriptionsReference = FirebaseFirestore.instance.collection(AppFirestoreCollectionConstants.userSubscriptions);

  // Insert a new subscription
  Future<void> insert(UserSubscription subscription) async {
    try {
      await userSubscriptionsReference.doc(subscription.subscriptionId).set(subscription.toJSON());
      AppConfig.logger.d("Subscription inserted successfully: ${subscription.subscriptionId}");
    } catch (e) {
      AppConfig.logger.d("Error inserting subscription: $e");
    }
  }

  // Get a subscription by its ID
  Future<UserSubscription?> getById(String subscriptionId) async {
    try {
      DocumentSnapshot doc = await userSubscriptionsReference.doc(subscriptionId).get();
      if (doc.exists) {
        AppConfig.logger.d("Subscription retrieved: $subscriptionId");
        return UserSubscription.fromJSON(doc.data() as Map<String, dynamic>);
      } else {
        AppConfig.logger.d("Subscription not found: $subscriptionId");
      }
    } catch (e) {
      AppConfig.logger.d("Error getting subscription: $e");
    }
    return null;
  }

  // Get all subscriptions by User ID
  Future<List<UserSubscription>> getByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await userSubscriptionsReference
          .where(AppFirestoreConstants.userId, isEqualTo: userId)
          .get();

      List<UserSubscription> subscriptions = querySnapshot.docs.map((doc) {
        return UserSubscription.fromJSON(doc.data() as Map<String, dynamic>);
      }).toList();

      AppConfig.logger.d("${subscriptions.length} Subscriptions retrieved for user: $userId");
      return subscriptions;
    } catch (e) {
      AppConfig.logger.e("Error getting subscriptions for user: $e");
      return [];
    }
  }


  // Get all subscriptions
  Future<List<UserSubscription>> getAll() async {
    try {
      QuerySnapshot querySnapshot = await userSubscriptionsReference.get();
      List<UserSubscription> subscriptions = querySnapshot.docs.map((doc) {
        return UserSubscription.fromJSON(doc.data() as Map<String, dynamic>);
      }).toList();
      AppConfig.logger.d("All subscriptions retrieved.");
      return subscriptions;
    } catch (e) {
      AppConfig.logger.d("Error getting all subscriptions: $e");
      return [];
    }
  }

  // Update a subscription by its ID
  Future<void> update(String subscriptionId, Map<String, dynamic> updates) async {
    try {
      await userSubscriptionsReference.doc(subscriptionId).update(updates);
      AppConfig.logger.d("Subscription updated successfully: $subscriptionId");
    } catch (e) {
      AppConfig.logger.d("Error updating subscription: $e");
    }
  }

  // Remove a subscription by its ID
  Future<void> remove(String subscriptionId) async {
    try {
      await userSubscriptionsReference.doc(subscriptionId).delete();
      AppConfig.logger.d("Subscription removed successfully: $subscriptionId");
    } catch (e) {
      AppConfig.logger.d("Error removing subscription: $e");
    }
  }

  // Update a subscription by its ID
  Future<void> cancel(String subscriptionId) async {
    try {
      await userSubscriptionsReference.doc(subscriptionId).update({
        AppFirestoreConstants.status: SubscriptionStatus.cancelled.name,
        AppFirestoreConstants.endReason: CancellationReason.userCancelled.name,
      });
      AppConfig.logger.d("Subscription cancelled successfully: $subscriptionId");
    } catch (e) {
      AppConfig.logger.d("Error cancelling subscription: $e");
    }
  }
}
