import 'package:kds/app/orders_cycle/models/current_kds_orders.dart';
import 'package:kds/app/orders_cycle/models/history_kds_orders.dart';
import 'package:kds/app/orders_cycle/models/status_msg_model.dart';
import 'package:kds/services/dio_client.dart';

class OrdersApis {
  Future<CurrentKdsOrders?> getCurrentKDSOrders(int posId) async {
    String url = 'http://157.180.26.238:10000/get_KDS_orders';

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

  Future<StatusMsgModel?> prepareAcceptedOrder(int orderId) async {
    String url = 'http://157.180.26.238:10000/prepare_kds_order/$orderId';

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

  Future<StatusMsgModel?> finishPreparedOrder(int orderId) async {
    String url = 'http://157.180.26.238:10000/finish_kds_order/$orderId';

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

  Future<HistoryKdsOrders?> getHistoryKDSOrders(int posId) async {
    String url = 'http://157.180.26.238:10000/get_KDS_history_orders';

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
