import 'package:evseye_core/evseye_core.dart';

import '../../../core/demo/demo_data.dart';
import '../domain/entities/rental.dart';
import '../domain/rentals_repository.dart';

class RentalsRepositoryImpl implements RentalsRepository {
  const RentalsRepositoryImpl();

  @override
  Future<Result<RentalsOverview>> getRentals() async {
    return Result.ok(
      RentalsOverview(
        plan: RentalPlan(
          name: 'Weekly plan',
          weeklyRent: Demo.weeklyRent,
          nextDebitDate: Demo.nextWeekday(DateTime.monday),
          autoDebitEnabled: true,
          mandateStatus: 'active',
          mandateRef: 'NACH/HDFC/0044219',
        ),
        invoices: _invoices(),
      ),
    );
  }

  static List<RentalInvoice> _invoices() {
    final DateTime nextMonday = Demo.nextWeekday(DateTime.monday);

    RentalInvoice past(int weeksAgo, InvoiceStatus status, {num? amount}) {
      final DateTime due = nextMonday.subtract(Duration(days: 7 * weeksAgo));
      return RentalInvoice(
        id: 'INV-${2140 - weeksAgo}',
        periodLabel: _weekLabel(due),
        amount: amount ?? Demo.weeklyRent,
        dueDate: due,
        paidOn: status == InvoiceStatus.paid ? due : null,
        status: status,
        items: _items(amount ?? Demo.weeklyRent),
      );
    }

    return [
      RentalInvoice(
        id: 'INV-2141',
        periodLabel: _weekLabel(nextMonday),
        amount: Demo.weeklyRent,
        dueDate: nextMonday,
        paidOn: null,
        status: InvoiceStatus.due,
        items: _items(Demo.weeklyRent),
      ),
      past(1, InvoiceStatus.paid),
      past(2, InvoiceStatus.paid),

      past(3, InvoiceStatus.failed),
      past(4, InvoiceStatus.paid),
      past(5, InvoiceStatus.paid),

      past(6, InvoiceStatus.paid, amount: 1250),
      past(7, InvoiceStatus.paid),
      past(8, InvoiceStatus.paid),
    ];
  }

  static List<InvoiceLineItem> _items(num total) {
    final num insurance = 120;
    final num maintenance = 80;
    return [
      InvoiceLineItem(label: 'Vehicle rent', amount: total - insurance - maintenance),
      InvoiceLineItem(label: 'Insurance', amount: insurance),
      InvoiceLineItem(label: 'Maintenance cover', amount: maintenance),
    ];
  }

  static String _weekLabel(DateTime monday) {
    const List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final DateTime sunday = monday.add(const Duration(days: 6));
    final String from = '${monday.day} ${months[monday.month - 1]}';
    final String to = '${sunday.day} ${months[sunday.month - 1]}';
    return '$from – $to';
  }
}
