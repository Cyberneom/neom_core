import 'dart:async';
import '../../utils/enums/itemlist_type.dart';
import '../../utils/enums/owner_type.dart';
import '../model/app_media_item.dart';
import '../model/app_release_item.dart';
import '../model/item_list.dart';
import '../model/neom/chamber_preset.dart';


abstract class ItemlistRepository {

  Future<bool> addAppMediaItem(AppMediaItem appMediaItem, String itemlistId);
  Future<bool> deleteItem({required String itemlistId, required AppMediaItem appMediaItem});
  Future<bool> updateItem(String itemlistId, AppMediaItem appMediaItem);

  Future<Itemlist> retrieve(String itemlistId);
  Future<String> insert(Itemlist itemlist);
  Future<bool> delete(itemlistId);

  Future<bool> update(Itemlist itemlist);

  Future<Map<String, Itemlist>> fetchAll({bool onlyPublic = false,
    int maxLength = 100, String ownerId = '', String excludeFromProfileId = '',
    OwnerType ownerType = OwnerType.profile, ItemlistType? itemlistType});

  Future<Map<String, Itemlist>> getByOwnerId(String ownerId, {bool onlyPublic = false, bool excludeMyFavorites = true,
    int maxLength = 100, OwnerType ownerType = OwnerType.profile, ItemlistType? itemlistType});

  Future<bool> addReleaseItem(String itemlistId, AppReleaseItem releaseItem);
  Future<bool> deleteReleaseItem(String itemlistId, AppReleaseItem releaseItem);

  Future<bool> addPreset(String chamberId, ChamberPreset preset);
  Future<bool> deletePreset(ChamberPreset preset, String chamberId);
  Future<bool> updatePreset(String chamberId, ChamberPreset preset);

}
