import 'package:enum_to_string/enum_to_string.dart';

import '../../utils/enums/product_type.dart';
import 'app_release_item.dart';
import 'event.dart';
import 'price.dart';
import 'review.dart';
import 'subscription_plan.dart';

class AppProduct {

  String id;
  String name;
  String description;
  ProductType type;
  Price? regularPrice;
  Price? salePrice;
  int qty;
  String imgUrl;
  bool isAvailable;  
  int numberOfSales;
  
  double reviewStars =  10.0;
  List<String>? reviewIds;
  Review? lastReview;

  int createdTime;
  int updatedTime;

  String? ownerEmail;

  @override
  String toString() {
    return 'AppProduct{id: $id, name: $name, description: $description, type: $type, regularPrice: $regularPrice, salePrice: $salePrice, qty: $qty, imgUrl: $imgUrl, isAvailable: $isAvailable, numberOfSales: $numberOfSales, reviewStars: $reviewStars, reviewIds: $reviewIds, lastReview: $lastReview, createdTime: $createdTime, updatedTime: $updatedTime, ownerEmail: $ownerEmail}';
  }

  AppProduct({
    this.id = "",
    this.name = "",
    this.description = "",
    this.type = ProductType.service,
    this.regularPrice,
    this.salePrice,
    this.qty = 0,
    this.imgUrl = "",
    this.isAvailable = true,    
    this.numberOfSales = 0,
    this.reviewStars = 10.0,
    this.lastReview,
    this.reviewIds,
    this.createdTime = 0,
    this.updatedTime = 0,
    this.ownerEmail
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'id': id,
      'name': name,      
      'description': description,
      'type': type.name,
      'regularPrice': regularPrice?.toJSON() ?? Price().toJSON(),
      'salePrice': salePrice?.toJSON() ?? Price().toJSON(),
      'qty': qty,
      'imgUrl': imgUrl,
      'isAvailable': isAvailable,      
      'numberOfSales': numberOfSales,      
      'reviewStars': reviewStars,
      'lastReview': lastReview?.toJSON() ?? Review().toJSON(),
      'reviewIds': reviewIds,
      'createdTime': DateTime.now().millisecondsSinceEpoch,
      'updatedTime': DateTime.now().millisecondsSinceEpoch,
      'ownerEmail': ownerEmail
    };
  }

  AppProduct.fromJSON(data) :
    id = data["id"] ?? "",
    name = data["name"] ?? "",
    description = data["description"] ?? "",
    type = EnumToString.fromString(ProductType.values, data["type"] ?? ProductType.service.name) ?? ProductType.service,
    regularPrice = Price.fromJSON(data["regularPrice"] ?? {}),
    salePrice = Price.fromJSON(data["salePrice"] ?? data["regularPrice"] ?? {}),
    qty = data["qty"] ?? 0,
    imgUrl = data["imgUrl"] ?? "",
    isAvailable = data["isAvailable"] ?? true,    
    numberOfSales = data["numberOfSales"] ?? 0,
    reviewStars = (data["reviewStars"] ?? 10).toDouble(),
    lastReview = Review.fromJSON(data["lastReview"] ?? {}),
    reviewIds = data["reviewIds"]?.cast<String>(),
    createdTime = data["createdTime"] ?? 0,
    updatedTime = data["updatedTime"] ?? 0,
    ownerEmail = data["ownerEmail"] ?? '';

  AppProduct.clone(AppProduct product) :
        id = product.id,
        name = product.name,
        description = product.description,
        type =  product.type,
        regularPrice = product.regularPrice,
        salePrice = product.salePrice,
        qty = product.qty,
        imgUrl = product.imgUrl,
        isAvailable = product.isAvailable,
        numberOfSales = product.numberOfSales,
        reviewStars = product.reviewStars,
        lastReview = product.lastReview,
        reviewIds = product.reviewIds,
        createdTime = product.createdTime,
        updatedTime = product.updatedTime,
        ownerEmail = product.ownerEmail;

  AppProduct.fromReleaseItem(AppReleaseItem releaseItem) :
        id = releaseItem.id,
        name = releaseItem.name,
        description = releaseItem.description,
        type =  releaseItem.physicalPrice != null ? ProductType.physical : ProductType.digital,
        regularPrice = releaseItem.physicalPrice ?? releaseItem.digitalPrice,
        salePrice = releaseItem.salePrice,
        qty = 1,
        imgUrl = releaseItem.imgUrl,
        ownerEmail = releaseItem.ownerEmail,
        numberOfSales = 0,
        createdTime = releaseItem.createdTime,
        isAvailable = true,
        updatedTime = 0;

  AppProduct.fromEvent(Event event) :
        id = event.id,
        name = event.name,
        description = event.description,
        type =  ProductType.event,
        regularPrice = event.coverPrice,
        salePrice = event.coverPrice,
        qty = 1,
        imgUrl = event.imgUrl,
        ownerEmail = event.ownerEmail,
        numberOfSales = 0,
        createdTime = event.createdTime,
        isAvailable = true,
        updatedTime = 0;

  AppProduct.fromSubscriptionPlan(SubscriptionPlan plan) :
        id = plan.priceId,
        name = plan.name,
        description = '${plan.name}Msg',
        type =  ProductType.subscription,
        regularPrice = plan.price,
        salePrice = plan.price,
        qty = 1,
        imgUrl = plan.imgUrl,
        numberOfSales = 0,
        createdTime = 0,
        isAvailable = true,
        updatedTime = 0;

}
