import 'package:enum_to_string/enum_to_string.dart';

import '../../utils/enums/user_role.dart';
import 'app_profile.dart';

class AppUser {

  String id;
  String name;
  String firstName;
  String lastName;
  int dateOfBirth;
  String homeTown;
  String phoneNumber;
  String countryCode;

  String password;
  String email;
  String photoUrl;
  UserRole userRole;
  bool isVerified;
  bool isBanned;

  String androidNotificationToken;
  List<AppProfile> profiles;

  // Wallet wallet = Wallet();
  List<String> orderIds = [];
  List<String>? releaseItemIds;
  List<String>? boughtItems;

  String couponCode = "";  ///If user has a coupon code to share
  String referralCode = ""; ///If user has used a referral coupon code

  int createdDate = 0;
  int lastTimeOn = 0;

  String fcmToken;
  String spotifyToken;
  String currentProfileId;

  String customerId; ///Customer Stripe Id for future references
  String subscriptionId; ///If is not empty, user has minimum a basic plan

  AppUser({
    this.id = "",
    this.name = "",
    this.firstName = "",
    this.lastName = "",
    this.dateOfBirth = 0,
    this.homeTown = "",
    this.phoneNumber = "",
    this.countryCode = "",
    this.password = "",
    this.email = "",
    this.photoUrl = "",
    this.userRole = UserRole.subscriber,
    this.isVerified = false,
    this.isBanned = false,
    this.androidNotificationToken = "",
    this.profiles = const [],
    this.orderIds = const [],
    this.referralCode = "",
    this.couponCode = "",
    this.createdDate = 0,
    this.lastTimeOn = 0,
    this.fcmToken = "",
    this.spotifyToken = "",
    this.currentProfileId = "",
    this.customerId = '',
    this.subscriptionId = '',
  });

  @override
  String toString() {
    return 'AppUser{id: $id, name: $name, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, homeTown: $homeTown, phoneNumber: $phoneNumber, countryCode: $countryCode, password: $password, email: $email, photoUrl: $photoUrl, userRole: $userRole, isVerified: $isVerified, isBanned: $isBanned, androidNotificationToken: $androidNotificationToken, profiles: $profiles, orderIds: $orderIds, releaseItemIds: $releaseItemIds, boughtItems: $boughtItems, referralCode: $referralCode, createdDate: $createdDate, lastTimeOn: $lastTimeOn, fcmToken: $fcmToken, spotifyToken: $spotifyToken, currentProfileId: $currentProfileId, customerId: $customerId, subscriptionId: $subscriptionId}';
  }

  AppUser.fromJSON(data) :
        id = data["id"] ?? "",
        name = data["name"] ?? "",
        firstName = data["firstName"] ?? "",
        lastName = data["lastName"] ?? "",
        dateOfBirth = int.tryParse(data["dateOfBirth"].toString()) ?? 0,
        homeTown = data["homeTown"] ?? "",
        phoneNumber = data["phoneNumber"] ?? "",
        countryCode = data["countryCode"] ?? "",
        password = data["password"] ?? "",
        email = data["email"] ?? "",
        photoUrl = data["photoUrl"] ?? "",
        userRole =  EnumToString.fromString(UserRole.values, data["userRole"] ?? UserRole.subscriber.name) ?? UserRole.subscriber,

        isVerified = data["isVerified"] ?? true,
        isBanned = data["isBanned"] ?? true,
        androidNotificationToken = data["androidNotificationToken"] ?? "",
        profiles = [],
        // wallet = Wallet.fromJSON(data["wallet"] ?? {}),
        orderIds = data["orderIds"]?.cast<String>() ?? [],
        releaseItemIds = data["releaseItemIds"]?.cast<String>() ?? [],
        boughtItems = data["boughtItems"]?.cast<String>() ?? [],
        referralCode = data["referralCode"] ?? "",
        couponCode = data["couponCode"] ?? "",
        createdDate = int.tryParse(data["createdDate"].toString()) ?? 0,
        lastTimeOn = int.tryParse(data["lastTimeOn"].toString()) ?? 0,
        fcmToken = data["fcmToken"] ?? "",
        spotifyToken = data["spotifyToken"] ?? "",
        currentProfileId = data["currentProfileId"] ?? "",
        customerId = data["customerId"] ?? "",
        subscriptionId = data["subscriptionId"] ?? "";

  ///DEPRECATED
  // AppUser.fromFbProfile(profile) :
  //   id = profile["id"],
  //   name = profile["name"],
  //   firstName = profile["first_name"],
  //   lastName = profile["last_name"],
  //   password = "",
  //   email = profile["email"],
  //   photoUrl = profile['picture']['data']['url'],
  //   userRole = UserRole.subscriber,
  //   dateOfBirth = 0,
  //   homeTown = "",
  //   phoneNumber = "",
  //   countryCode = "",
  //   isBanned = false,
  //   isVerified = false,
  //   androidNotificationToken = "",
  //   profiles = [],
  //   orderIds = [],
  //   referralCode = "",
  //   fcmToken = "",
  //   spotifyToken = "",
  //   currentProfileId = "",
  //   customerId = '',
  //   subscriptionId = '';


  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      //'id': id, //not needed at firebase
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'homeTown': homeTown,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'photoUrl': photoUrl,
      'userRole': userRole.name,
      'isVerified': isVerified,
      'isBanned': isBanned,
      'androidNotificationToken': androidNotificationToken,
      // 'wallet': wallet.toJSON(),
      'orderIds': orderIds,
      'releaseItemIds': releaseItemIds,
      'boughtItems': boughtItems,
      'referralCode': referralCode,
      'createdDate': createdDate,
      'lastTimeOn': lastTimeOn,
      'fcmToken': fcmToken,
      'spotifyToken': spotifyToken,
      'customerId': customerId,
      'subscriptionId': subscriptionId,
    };
  }

  Map<String, dynamic> toInvoiceJSON() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'homeTown': homeTown,
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'photoUrl': photoUrl
    };
  }

}
