class FacilityDashboardStats {
  const FacilityDashboardStats({
    required this.todayCheckins,
    required this.currentlyInside,
    required this.totalMembers,
    required this.activeMembers,
  });

  final int todayCheckins;
  final int currentlyInside;
  final int totalMembers;
  final int activeMembers;

  factory FacilityDashboardStats.fromJson(Map<String, dynamic> json) {
    return FacilityDashboardStats(
      todayCheckins: (json['today_checkins'] as num?)?.toInt() ?? 0,
      currentlyInside: (json['currently_inside'] as num?)?.toInt() ?? 0,
      totalMembers: (json['total_members'] as num?)?.toInt() ?? 0,
      activeMembers: (json['active_members'] as num?)?.toInt() ?? 0,
    );
  }
}

class LiveSessionMember {
  const LiveSessionMember({
    required this.sessionId,
    required this.memberId,
    this.userId,
    required this.userName,
    this.userEmail,
    this.userAvatar,
    required this.membershipType,
    required this.checkInAt,
    required this.checkInTime,
    required this.elapsedMinutes,
  });

  final String sessionId;
  final String memberId;
  final String? userId;
  final String userName;
  final String? userEmail;
  final String? userAvatar;
  final String membershipType;
  final String checkInAt;
  final String checkInTime;
  final int elapsedMinutes;

  factory LiveSessionMember.fromJson(Map<String, dynamic> json) {
    return LiveSessionMember(
      sessionId: json['session_id']?.toString() ?? '',
      memberId: json['member_id']?.toString() ?? '',
      userId: json['user_id']?.toString(),
      userName: json['user_name']?.toString() ?? 'Citizen Member',
      userEmail: json['user_email']?.toString(),
      userAvatar: json['user_avatar']?.toString(),
      membershipType: json['membership_type']?.toString() ?? 'Standard',
      checkInAt: json['check_in_at']?.toString() ?? '',
      checkInTime: json['check_in_time']?.toString() ?? '--',
      elapsedMinutes: (json['elapsed_minutes'] as num?)?.toInt() ?? 0,
    );
  }
}

class DailyCheckinRecord {
  const DailyCheckinRecord({
    required this.sessionId,
    required this.memberId,
    required this.userName,
    this.userEmail,
    required this.planName,
    required this.checkInTime,
    required this.checkOutTime,
    required this.durationText,
    required this.durationMinutes,
    required this.isCurrentlyInside,
  });

  final String sessionId;
  final String memberId;
  final String userName;
  final String? userEmail;
  final String planName;
  final String checkInTime;
  final String checkOutTime;
  final String durationText;
  final int durationMinutes;
  final bool isCurrentlyInside;

  factory DailyCheckinRecord.fromJson(Map<String, dynamic> json) {
    return DailyCheckinRecord(
      sessionId: json['session_id']?.toString() ?? '',
      memberId: json['member_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? 'Citizen',
      userEmail: json['user_email']?.toString(),
      planName: json['plan_name']?.toString() ?? 'Standard',
      checkInTime: json['check_in_time']?.toString() ?? '--',
      checkOutTime: json['check_out_time']?.toString() ?? '--',
      durationText: json['duration_text']?.toString() ?? '--',
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
      isCurrentlyInside: json['is_currently_inside'] as bool? ?? false,
    );
  }
}

class UnpaidMemberItem {
  const UnpaidMemberItem({
    required this.memberId,
    this.userId,
    required this.userName,
    this.userEmail,
    this.userPhone,
    this.userAvatar,
    required this.planName,
    required this.dueAmount,
    required this.dueDate,
    required this.dueDateFormatted,
    required this.membershipStatus,
  });

  final String memberId;
  final String? userId;
  final String userName;
  final String? userEmail;
  final String? userPhone;
  final String? userAvatar;
  final String planName;
  final double dueAmount;
  final String dueDate;
  final String dueDateFormatted;
  final String membershipStatus;

  factory UnpaidMemberItem.fromJson(Map<String, dynamic> json) {
    return UnpaidMemberItem(
      memberId: json['member_id']?.toString() ?? '',
      userId: json['user_id']?.toString(),
      userName: json['user_name']?.toString() ?? 'Citizen Member',
      userEmail: json['user_email']?.toString(),
      userPhone: json['user_phone']?.toString(),
      userAvatar: json['user_avatar']?.toString(),
      planName: json['plan_name']?.toString() ?? 'Membership Plan',
      dueAmount: (json['due_amount'] as num?)?.toDouble() ?? 0.0,
      dueDate: json['due_date']?.toString() ?? '',
      dueDateFormatted: json['due_date_formatted']?.toString() ?? '',
      membershipStatus: json['membership_status']?.toString() ?? 'active',
    );
  }
}

class CollectionTransaction {
  const CollectionTransaction({
    required this.paymentId,
    required this.invoiceNumber,
    required this.date,
    required this.memberId,
    required this.memberName,
    required this.planName,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.paidAt,
  });

  final String paymentId;
  final String invoiceNumber;
  final String date;
  final String memberId;
  final String memberName;
  final String planName;
  final double amount;
  final String paymentMethod;
  final String status;
  final String? paidAt;

  factory CollectionTransaction.fromJson(Map<String, dynamic> json) {
    return CollectionTransaction(
      paymentId: json['payment_id']?.toString() ?? '',
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      memberId: json['member_id']?.toString() ?? '',
      memberName: json['member_name']?.toString() ?? 'Citizen',
      planName: json['plan_name']?.toString() ?? 'Membership Plan',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method']?.toString() ?? 'UPI',
      status: json['status']?.toString() ?? 'paid',
      paidAt: json['paid_at']?.toString(),
    );
  }
}

class FacilityEnquiryItem {
  const FacilityEnquiryItem({
    required this.id,
    required this.enquiryNumber,
    required this.name,
    required this.email,
    this.phone,
    required this.subject,
    required this.message,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.timeFormatted,
    required this.dateFormatted,
    this.messagesCount = 0,
  });

  final String id;
  final String enquiryNumber;
  final String name;
  final String email;
  final String? phone;
  final String subject;
  final String message;
  final String status;
  final String priority;
  final String createdAt;
  final String timeFormatted;
  final String dateFormatted;
  final int messagesCount;

  factory FacilityEnquiryItem.fromJson(Map<String, dynamic> json) {
    return FacilityEnquiryItem(
      id: json['id']?.toString() ?? '',
      enquiryNumber: json['enquiry_number']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Citizen',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      subject: json['subject']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'new',
      priority: json['priority']?.toString() ?? 'medium',
      createdAt: json['created_at']?.toString() ?? '',
      timeFormatted: json['time_formatted']?.toString() ?? '',
      dateFormatted: json['date_formatted']?.toString() ?? '',
      messagesCount: (json['messages_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class EnquiryMessage {
  const EnquiryMessage({
    required this.id,
    required this.senderType,
    required this.message,
    required this.createdAt,
    required this.time,
  });

  final dynamic id;
  final String senderType;
  final String message;
  final String createdAt;
  final String time;

  bool get isOwner => senderType == 'owner';

  factory EnquiryMessage.fromJson(Map<String, dynamic> json) {
    return EnquiryMessage(
      id: json['id'],
      senderType: json['sender_type']?.toString() ?? 'citizen',
      message: json['message']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
    );
  }
}

class FacilityCommunicationItem {
  const FacilityCommunicationItem({
    required this.id,
    required this.title,
    required this.subject,
    required this.message,
    required this.channel,
    required this.recipientsCount,
    required this.targetFilter,
    required this.dateFormatted,
    required this.timeFormatted,
  });

  final String id;
  final String title;
  final String subject;
  final String message;
  final String channel;
  final int recipientsCount;
  final String targetFilter;
  final String dateFormatted;
  final String timeFormatted;

  factory FacilityCommunicationItem.fromJson(Map<String, dynamic> json) {
    return FacilityCommunicationItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      channel: json['channel']?.toString() ?? 'email',
      recipientsCount: (json['recipients_count'] as num?)?.toInt() ?? 0,
      targetFilter: json['target_filter']?.toString() ?? 'selected',
      dateFormatted: json['date_formatted']?.toString() ?? '',
      timeFormatted: json['time_formatted']?.toString() ?? '',
    );
  }
}
