// To parse this JSON data, do
//
//     final statusMsgModel = statusMsgModelFromJson(jsonString);

import 'dart:convert';

StatusMsgModel statusMsgModelFromJson(String str) => StatusMsgModel.fromJson(json.decode(str));

String statusMsgModelToJson(StatusMsgModel data) => json.encode(data.toJson());

class StatusMsgModel {
  int? status;
  String? message;
  String? messageAr;

  StatusMsgModel({this.status, this.message, this.messageAr});

  factory StatusMsgModel.fromJson(Map<String, dynamic> json) =>
      StatusMsgModel(status: json["status"], message: json["message"], messageAr: json["message_ar"]);

  Map<String, dynamic> toJson() => {"status": status, "message": message, "message_ar": messageAr};
}
