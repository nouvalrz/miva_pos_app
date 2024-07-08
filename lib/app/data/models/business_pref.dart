import 'package:powersync/sqlite3.dart' as Sqlite;

class BusinessPref {
  final String id;
  final String businessId;
  final String footerMessage;
  final int receiptShowLogo;
  final int receiptShowAddress;
  final int receiptShowUserName;
  final int receiptShowFooterMessage;

  BusinessPref({
    required this.id,
    required this.businessId,
    required this.footerMessage,
    required this.receiptShowLogo,
    required this.receiptShowAddress,
    required this.receiptShowUserName,
    required this.receiptShowFooterMessage,
  });

  factory BusinessPref.fromRow(Sqlite.Row row) {
    return BusinessPref(
      id: row["id"],
      businessId: row["business_id"],
      footerMessage: row["footer_message"],
      receiptShowLogo: row["receipt_show_logo"],
      receiptShowAddress: row["receipt_show_address"],
      receiptShowUserName: row["receipt_show_user_name"],
      receiptShowFooterMessage: row["receipt_show_footer_message"],
    );
  }
}
