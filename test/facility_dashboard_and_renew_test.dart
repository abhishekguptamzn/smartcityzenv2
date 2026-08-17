import 'package:flutter_test/flutter_test.dart';
import 'package:smartcityzenv2/data/models/facility_operations_models.dart';

void main() {
  group('FacilityDashboardStats Model Tests', () {
    test('parses full analytics payload including trends, methods, and recent payments', () {
      final json = {
        'facility_id': 'gym-123',
        'facility_name': 'Downtown Fit Hub',
        'facility_type': 'Gym',
        'today_checkins': 12,
        'currently_inside': 4,
        'total_members': 50,
        'active_members': 42,
        'expiring_soon_members': 5,
        'expired_members': 3,
        'total_earnings_all_time': 125000.0,
        'total_earnings_this_month': 24500.0,
        'total_earnings_today': 3500.0,
        'total_renewals_this_month': 8,
        'monthly_earnings_trend': [
          {'month': 'Jul', 'year': '2026', 'earnings': 18000.0, 'count': 6},
          {'month': 'Aug', 'year': '2026', 'earnings': 24500.0, 'count': 8},
        ],
        'weekly_earnings_trend': [
          {'day': 'Sun', 'date': '16 Aug', 'earnings': 2000.0, 'count': 1},
          {'day': 'Mon', 'date': '17 Aug', 'earnings': 3500.0, 'count': 2},
        ],
        'payment_methods_breakdown': [
          {'method': 'UPI / QR', 'amount': 15000.0, 'count': 5, 'percentage': 61.2},
          {'method': 'Cash at Desk', 'amount': 9500.0, 'count': 3, 'percentage': 38.8},
        ],
        'plan_distribution': [
          {
            'plan_id': 'plan-1',
            'plan_name': 'Monthly Unlimited',
            'amount': 2500.0,
            'interval': 'month',
            'interval_count': 1,
            'member_count': 30,
          },
        ],
        'recent_payments': [
          {
            'id': 'pay-1',
            'invoice_number': 'INV-202608-ABC123',
            'member_id': 'mem-1',
            'member_name': 'Rahul Sharma',
            'member_email': 'rahul@example.com',
            'amount': 2500.0,
            'payment_method': 'UPI',
            'status': 'paid',
            'date': '17 Aug 2026, 10:30 AM',
            'paid_at': '2026-08-17T10:30:00Z',
          },
        ],
      };

      final stats = FacilityDashboardStats.fromJson(json);

      expect(stats.todayCheckins, 12);
      expect(stats.currentlyInside, 4);
      expect(stats.totalMembers, 50);
      expect(stats.activeMembers, 42);
      expect(stats.expiringSoonMembers, 5);
      expect(stats.expiredMembers, 3);
      expect(stats.totalEarningsAllTime, 125000.0);
      expect(stats.totalEarningsThisMonth, 24500.0);
      expect(stats.totalEarningsToday, 3500.0);
      expect(stats.totalRenewalsThisMonth, 8);

      expect(stats.monthlyEarningsTrend.length, 2);
      expect(stats.monthlyEarningsTrend[0].month, 'Jul');
      expect(stats.monthlyEarningsTrend[1].earnings, 24500.0);

      expect(stats.weeklyEarningsTrend.length, 2);
      expect(stats.weeklyEarningsTrend[1].day, 'Mon');

      expect(stats.paymentMethodsBreakdown.length, 2);
      expect(stats.paymentMethodsBreakdown[0].method, 'UPI / QR');
      expect(stats.paymentMethodsBreakdown[0].percentage, 61.2);

      expect(stats.planDistribution.length, 1);
      expect(stats.planDistribution[0].planName, 'Monthly Unlimited');
      expect(stats.planDistribution[0].memberCount, 30);

      expect(stats.recentPayments.length, 1);
      expect(stats.recentPayments[0].memberName, 'Rahul Sharma');
      expect(stats.recentPayments[0].invoiceNumber, 'INV-202608-ABC123');
    });
  });
}
