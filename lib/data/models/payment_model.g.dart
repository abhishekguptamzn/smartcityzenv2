// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) =>
    _PaymentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      payableType: json['payable_type'] as String?,
      payableId: json['payable_id'] as String?,
      amount: json['amount'] == null ? 0 : _toDouble(json['amount']),
      currency: json['currency'] as String? ?? 'INR',
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['payment_method'] as String?,
      transactionReference: json['transaction_reference'] as String?,
      invoiceNumber: json['invoice_number'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      notes: json['notes'] as String?,
      facilityName: json['facility_name'] as String?,
      facilityId: json['facility_id'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PaymentModelToJson(_PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'payable_type': instance.payableType,
      'payable_id': instance.payableId,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
      'transaction_reference': instance.transactionReference,
      'invoice_number': instance.invoiceNumber,
      'due_date': instance.dueDate?.toIso8601String(),
      'paid_at': instance.paidAt?.toIso8601String(),
      'notes': instance.notes,
      'facility_name': instance.facilityName,
      'facility_id': instance.facilityId,
      'user': instance.user,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
