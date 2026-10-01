import 'package:kds/app/orders_cycle/models/current_kds_orders.dart';
import 'package:kds/app/history_cycle/models/history_kds_orders.dart';
import 'package:kds/app/orders_cycle/models/status_msg_model.dart';
import 'package:kds/services/dio_client.dart';

class OrdersApis {
  Future<CurrentKdsOrders?> getCurrentKDSOrders(int branchId) async {
    String url = 'http://46.62.153.179:12000/get_KDS_orders/$branchId';

    try {
      final response = await Client.client.get(url);

      if (response.statusCode == 200) {
        CurrentKdsOrders currentKdsOrders = CurrentKdsOrders.fromJson(
          response.data,
        );
        return currentKdsOrders;
      } else {
        return null;
      }
    } catch (e) {
      throw 'getCurrentKDSOrders error >> $e';
    }
  }

  Future<StatusMsgModel?> prepareAcceptedOrder(
    int orderId,
    int branchId,
  ) async {
    String url =
        'http://46.62.153.179:12000/prepare_kds_order/$orderId/$branchId';

    try {
      final response = await Client.client.get(url);

      if (response.statusCode == 200) {
        StatusMsgModel statusMsgModel = StatusMsgModel.fromJson(response.data);
        return statusMsgModel;
      } else {
        return null;
      }
    } catch (e) {
      throw 'prepareAcceptedOrder error >> $e';
    }
  }

  Future<StatusMsgModel?> finishPreparedOrder(int orderId, int branchId) async {
    String url =
        'http://46.62.153.179:12000/finish_kds_order/$orderId/$branchId';

    try {
      final response = await Client.client.get(url);

      if (response.statusCode == 200) {
        StatusMsgModel statusMsgModel = StatusMsgModel.fromJson(response.data);
        return statusMsgModel;
      } else {
        return null;
      }
    } catch (e) {
      throw 'finishPreparedOrder error >> $e';
    }
  }

  Future<HistoryKdsOrders?> getHistoryKDSOrders(int branchId) async {
    String url = 'http://46.62.153.179:12000/get_KDS_history_orders/$branchId';

    try {
      final response = await Client.client.get(url);

      if (response.statusCode == 200) {
        HistoryKdsOrders historyKdsOrders = HistoryKdsOrders.fromJson(
          response.data,
        );
        return historyKdsOrders;
      } else {
        return null;
      }
    } catch (e) {
      throw 'getHistoryKDSOrders error >> $e';
    }
  }
}
