import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/enums/event_action.dart';
import '../../utils/enums/facilitator_type.dart';
import '../../utils/enums/place_type.dart';
import '../../utils/enums/profile_type.dart';
import '../../utils/enums/request_type.dart';
import '../../utils/enums/usage_reason.dart';
import '../../utils/enums/verification_level.dart';
import '../model/app_profile.dart';

abstract class ProfileRepository {

  Future<String> insert(String userId, AppProfile profile);
  Future<AppProfile> retrieve(String profileId);
  Future<AppProfile?> retrieveSimple(String profileId);
  Future<AppProfile> retrieveFull(String profileId);
  Future<bool> remove({required String userId, required String profileId});

  Future<List<AppProfile>> retrieveByUserId(String userId);
  Future<Map<String,AppProfile>> retrieveAllProfiles();
  Future<List<AppProfile>> getWithParameters({
    bool needsPhone  = false, bool needsPosts = false,
    List<ProfileType>? profileTypes, FacilityType? facilityType, PlaceType? placeType,
    List<UsageReason>? usageReasons, Position? currentPosition, int maxDistance = 30,});

  Future<bool> followProfile({required String profileId, required String followedProfileId});
  Future<bool> unfollowProfile({required String profileId, required  String unfollowProfileId});
  Future<bool> blockProfile({required String profileId, required  String profileToBlock});
  Future<bool> unblockProfile({required String profileId, required  String profileToUnblock});

  Future<bool> updatePosition(String profileId, Position newPositionO);

  Future<bool> addPost(String profileId, String postId);
  Future<bool> removePost(String profileId, String postId);

  Future<bool> updateName(String profileId, String name);
  Future<bool> updateAboutMe(String profileId, String aboutMe);

  Future<bool> addEvent(String profileId, String eventId, EventAction eventAction);
  Future<bool> removeEvent(String profileId, String eventId, EventAction eventAction);

  Future<QuerySnapshot> handleSearch(String query);

  Future<bool> addFavoriteItem(String profileId, String itemId);
  Future<bool> addFavoriteItems(String profileId, List<String> itemIds);
  Future<bool> removeFavoriteItem(String profileId, String itemId);
  Future<bool> removeFavoriteItems(String profileId, List<String> itemIds);

  // Future<bool> addAllAppMediaItemIds(String profileId, List<String> itemIds);

  Future<Map<String, AppProfile>> getFollowers(String profileId);
  Future<Map<String, AppProfile>> getFollowed(String profileId);

  Future<bool> updatePhotoUrl(String profileId, String photoUrl);
  Future<bool> updateCoverImgUrl(String profileId, String coverImgUrl);
  Future<Map<String,AppProfile>> retrieveProfilesByInstrument({
    String selfProfileId = "",
    Position? currentPosition,
    String instrumentId = "",
    int maxDistance = 20,
    int maxProfiles = 10,
  });

  Future<Map<String,AppProfile>> retrieveProfilesByFacility({
    required String selfProfileId,
    required Position? currentPosition,
    FacilityType? facilityType,
    int maxDistance = 30,
    int maxProfiles = 30,
  });

  Future<Map<String, AppProfile>> retrieveProfilesByPlace({
    required String selfProfileId,
    required Position? currentPosition,
    PlaceType? placeType,
    int maxDistance = 30,
    int maxProfiles = 30,
  });



  Future<Map<String, AppProfile>> retrieveFromList(List<String> profileIds);
  Future<bool> hidePost(String profileId, String postId);
  Future<bool> addComment(String profileId, String commentId);
  Future<bool> removeComment(String profileId, String commentId);
  Future<bool> hideComment(String profileId, String commentId);
  Future<bool> addBand({required String profileId, required String bandId});
  Future<bool> removeBand({required String profileId, required String bandId});
  Future<bool> removeRequest(String profileId, String requestId, RequestType requestType);
  Future<bool> addRequest(String profileId, String requestId, RequestType requestType);
  // Future<bool> addToWallet(String profileId, double amount, {AppCurrency appCurrency = AppCurrency.appCoin});
  // Future<bool> subtractFromWallet(String profileId, double amount, {AppCurrency appCurrency = AppCurrency.appCoin});
  Future<bool> isAvailableName(String profileName);

  Future<bool> updateLastSpotifySync(String profileId);

  Future<bool> addBlogEntry(String profileId, String blogEntryId);
  Future<bool> removeBlogEntry(String profileId, String blogEntryId);
  Future<bool> removeAllFavoriteItems(String profileId);

  Future<bool> addChamberPreset({required String profileId, required String chamberPresetId});
  Future<bool> updateAddress(String profileId, String address);
  Future<bool> updatePhoneNumber(String profileId, String phoneNumber);
  Future<bool> updateType(String profileId, ProfileType type);
  Future<bool> updateVerificationLevel(String profileId, VerificationLevel verificationLevel);

  Future<AppProfile?> getByEmail(String email);


}
