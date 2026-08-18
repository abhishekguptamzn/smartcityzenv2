import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartcityzenv2/data/models/facility_model.dart';
import 'package:smartcityzenv2/data/models/facility_operations_models.dart';
import 'package:smartcityzenv2/features/facility_management/widgets/facility_analytics_dashboard_widget.dart';
import 'package:smartcityzenv2/features/facility_management/widgets/payment_detail_modal.dart';

void main() {
  group('Payment Refund & Models Unit Tests', () {
    test('RecentPaymentRecord parses refund fields accurately', () {
      final json = {
        'id': 'pay-999',
        'invoice_number': 'INV-202608-REF01',
        'member_id': 'mem-101',
        'member_name': 'Ananya Roy',
        'member_email': 'ananya@example.com',
        'amount': 2200.0,
        'payment_method': 'UPI',
        'status': 'refunded',
        'date': '18 Aug 2026, 02:00 PM',
        'paid_at': '2026-08-18T14:00:00Z',
        'refund_reason': 'Citizen relocated to Mumbai',
        'refunded_amount': 2200.0,
        'refunded_at': '2026-08-18T14:30:00Z',
      };

      final record = RecentPaymentRecord.fromJson(json);

      expect(record.id, 'pay-999');
      expect(record.status, 'refunded');
      expect(record.refundReason, 'Citizen relocated to Mumbai');
      expect(record.refundedAmount, 2200.0);
      expect(record.refundedAt, '2026-08-18T14:30:00Z');
    });

    test('FacilityDashboardStats parses totalRefundsAllTime', () {
      final json = {
        'today_checkins': 15,
        'currently_inside': 6,
        'total_members': 80,
        'active_members': 65,
        'total_earnings_all_time': 150000.0,
        'total_earnings_this_month': 35000.0,
        'total_earnings_today': 4500.0,
        'total_refunds_all_time': 5000.0,
        'total_renewals_this_month': 12,
        'recent_payments': [
          {
            'id': 'pay-refund-1',
            'invoice_number': 'INV-202608-001',
            'member_id': 'm-1',
            'member_name': 'Karan Singh',
            'amount': 1500.0,
            'payment_method': 'CASH',
            'status': 'refunded',
            'date': '18 Aug 2026',
            'refund_reason': 'Duplicate fee charge',
            'refunded_amount': 1500.0,
          }
        ],
      };

      final stats = FacilityDashboardStats.fromJson(json);

      expect(stats.totalRefundsAllTime, 5000.0);
      expect(stats.recentPayments.length, 1);
      expect(stats.recentPayments[0].status, 'refunded');
      expect(stats.recentPayments[0].refundReason, 'Duplicate fee charge');
    });
  });

  group('Facility Analytics & Refund UI Widget Tests', () {
    testWidgets('FacilityAnalyticsDashboardWidget renders Net Revenue and Total Refunds when present', (tester) async {
      final stats = FacilityDashboardStats(
        todayCheckins: 10,
        currentlyInside: 3,
        totalMembers: 45,
        activeMembers: 40,
        totalEarningsAllTime: 120000.0,
        totalEarningsThisMonth: 28000.0,
        totalEarningsToday: 2500.0,
        totalRefundsAllTime: 4500.0,
        totalRenewalsThisMonth: 7,
        recentPayments: const [
          RecentPaymentRecord(
            id: 'p-1',
            invoiceNumber: 'INV-001',
            memberId: 'm-1',
            memberName: 'Priya Patel',
            amount: 2500.0,
            paymentMethod: 'UPI',
            status: 'refunded',
            date: '18 Aug 2026',
            refundReason: 'Accidental duplicate pass',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FacilityAnalyticsDashboardWidget(
                kind: FacilityKind.gym,
                facilityId: 'gym-1',
                stats: stats,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Total Refunds is displayed in revenue card
      expect(find.textContaining('Total Refunds'), findsOneWidget);
      expect(find.textContaining('4,500'), findsWidgets);

      // Verify Recent payment with REFUNDED badge
      expect(find.text('REFUNDED'), findsOneWidget);
      expect(find.textContaining('Accidental duplicate pass'), findsOneWidget);
    });

    testWidgets('PaymentDetailModal displays refund banner for refunded invoice', (tester) async {
      final paymentData = {
        'id': 'pay-refunded-99',
        'invoice_number': 'INV-202608-9999',
        'amount': 3000.0,
        'currency': 'INR',
        'status': 'refunded',
        'payment_method': 'UPI',
        'paid_at_formatted': '18 Aug 2026, 11:00 AM',
        'refund_reason': 'Citizen relocated abroad',
        'refunded_at_formatted': '18 Aug 2026, 01:30 PM',
        'download_url': 'https://example.com/inv.pdf',
        'user': {
          'id': 'usr-1',
          'name': 'Vikram Malhotra',
          'email': 'vikram@example.com',
        },
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            singlePaymentDetailProvider((FacilityKind.gym, 'gym-1', 'pay-refunded-99'))
                .overrideWith((ref) => paymentData),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PaymentDetailModal(
                kind: FacilityKind.gym,
                facilityId: 'gym-1',
                paymentId: 'pay-refunded-99',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify REFUNDED INVOICE banner is rendered
      expect(find.text('REFUNDED INVOICE'), findsOneWidget);
      expect(find.text('Reason: Citizen relocated abroad'), findsOneWidget);
      expect(find.text('Refunded on: 18 Aug 2026, 01:30 PM'), findsOneWidget);

      // Verify "Issue Refund" button is NOT rendered for already refunded invoice
      expect(find.text('Issue Refund'), findsNothing);
    });

    testWidgets('PaymentDetailModal displays Issue Refund button for paid invoice', (tester) async {
      final paymentData = {
        'id': 'pay-paid-11',
        'invoice_number': 'INV-202608-1111',
        'amount': 1500.0,
        'currency': 'INR',
        'status': 'paid',
        'payment_method': 'UPI',
        'paid_at_formatted': '18 Aug 2026, 10:00 AM',
        'download_url': 'https://example.com/inv.pdf',
        'user': {
          'id': 'usr-2',
          'name': 'Sneha Gupta',
          'email': 'sneha@example.com',
        },
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            singlePaymentDetailProvider((FacilityKind.gym, 'gym-1', 'pay-paid-11'))
                .overrideWith((ref) => paymentData),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PaymentDetailModal(
                kind: FacilityKind.gym,
                facilityId: 'gym-1',
                paymentId: 'pay-paid-11',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify "Issue Refund" action button is rendered for paid invoice
      expect(find.text('Issue Refund'), findsOneWidget);
      expect(find.text('Email Invoice'), findsOneWidget);
      expect(find.text('View PDF'), findsOneWidget);
    });
  });
}
