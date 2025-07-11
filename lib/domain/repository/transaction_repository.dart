import '../../utils/enums/transaction_status.dart';
import '../model/app_transaction.dart';

abstract class TransactionRepository {

  Future<String> insert(AppTransaction transaction);
  Future<bool> remove(AppTransaction transaction);
  Future<AppTransaction?> retrieve(String transactionId);
  Future<bool> updateStatus(String transactionId, TransactionStatus status);
  Future<Map<String, AppTransaction>> retrieveFromList(List<String> transactionIds, {TransactionStatus? status});
  Future<List<AppTransaction>> retrieveByOrderId(String orderId);

}
