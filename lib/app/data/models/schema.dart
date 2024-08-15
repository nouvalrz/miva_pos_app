import 'package:powersync/powersync.dart';

// Definisikan nama tabel sebagai konstanta
const usersTable = 'users';
const receiptsTable = 'receipts';
const receiptProductsTable = 'receipt_products';
const receiptAdditionalFeesTable = 'receipt_additional_fees';
const receiptDiscountsTable = 'receipt_discounts';
const categoriesTable = 'categories';
const paymentMethodsTable = 'payment_methods';
const businessPrefsTable = 'business_prefs';
const businessTable = 'business';
const productsTable = 'products';
const expensesTable = 'expenses';

const schema = Schema([
  Table(usersTable, [
    Column.text('email'),
    Column.text('business_id'),
    Column.text('auth_user_id'),
    Column.text('role'),
    Column.text('created_at'),
    Column.text('name')
  ], indexes: [
    Index("users_auth_user_id_idx", [IndexedColumn('auth_user_id')])
  ]),
  Table(receiptsTable, [
    Column.text('business_id'),
    Column.text('user_id'),
    Column.text('payment_method_id'),
    Column.text('receipt_number'),
    Column.integer('total_product_price'),
    Column.integer('total_bill'),
    Column.integer('cash_given'),
    Column.integer('cash_change'),
    Column.integer('total_profit'),
    Column.text('created_at'),
    Column.integer('is_archived'),
    Column.text('old_receipt_of'),
    Column.integer('total_discount_price'),
    Column.integer('total_additional_fee_price'),
    Column.integer('total_item'),
  ], indexes: [
    Index("receipts_business_id_idx", [IndexedColumn('business_id')]),
    Index("receipts_receipt_number_idx", [IndexedColumn('receipt_number')]),
    Index(
        "receipts_payment_method_id_idx", [IndexedColumn('payment_method_id')]),
    Index("receipts_business_id_receipt_number_idx",
        [IndexedColumn('business_id'), IndexedColumn('receipt_number')])
  ]),
  Table(receiptProductsTable, [
    Column.text('business_id'),
    Column.text('receipt_id'),
    Column.text('product_id'),
    Column.integer('product_cost_price'),
    Column.integer('product_sale_price'),
    Column.integer('quantity'),
    Column.text('created_at'),
    Column.text('product_name')
  ], indexes: [
    Index("receipt_products_business_id_idx", [IndexedColumn('business_id')]),
    Index("receipt_products_product_id_idx", [IndexedColumn('product_id')]),
    Index("receipt_products_receipt_id_idx", [IndexedColumn('receipt_id')]),
  ]),
  Table(receiptAdditionalFeesTable, [
    Column.text('business_id'),
    Column.text('receipt_id'),
    Column.text('name'),
    Column.integer('amount'),
    Column.text('created_at')
  ], indexes: [
    Index("receipt_additional_fees_business_id_idx",
        [IndexedColumn('business_id')]),
    Index("receipt_additional_fees_receipt_id_idx",
        [IndexedColumn('receipt_id')]),
  ]),
  Table(receiptDiscountsTable, [
    Column.text('business_id'),
    Column.text('receipt_id'),
    Column.text('name'),
    Column.integer('amount'),
    Column.text('created_at')
  ], indexes: [
    Index("receipt_discounts_business_id_idx", [IndexedColumn('business_id')]),
    Index("receipt_discounts_receipt_id_idx", [IndexedColumn('receipt_id')]),
  ]),
  Table(categoriesTable, [
    Column.text('business_id'),
    Column.text('name'),
    Column.text('created_at')
  ], indexes: [
    Index("categories_business_id_idx", [IndexedColumn('business_id')]),
  ]),
  Table(paymentMethodsTable, [
    Column.text('name'),
    Column.text('business_id')
  ], indexes: [
    Index("payment_methods_business_id_idx", [IndexedColumn('business_id')]),
  ]),
  Table(businessPrefsTable, [
    Column.text('business_id'),
    Column.text('footer_message'),
    Column.integer('receipt_show_logo'),
    Column.integer('receipt_show_address'),
    Column.integer('receipt_show_user_name'),
    Column.integer('receipt_show_footer_message')
  ]),
  Table(businessTable, [
    Column.text('name'),
    Column.text('address'),
    Column.text('logo_url'),
    Column.text('created_at')
  ]),
  Table(productsTable, [
    Column.text('business_id'),
    Column.text('category_id'),
    Column.text('barcode_number'),
    Column.text('name'),
    Column.integer('sale_price'),
    Column.integer('cost_price'),
    Column.integer('stock'),
    Column.text('unit'),
    Column.text('image_url'),
    Column.text('created_at')
  ], indexes: [
    Index("products_business_id_idx", [IndexedColumn('business_id')]),
    Index("products_barcode_number_idx", [IndexedColumn('barcode_number')]),
    Index("products_category_id_idx", [IndexedColumn('category_id')]),
  ]),
  Table(expensesTable, [
    Column.text('business_id'),
    Column.text('name'),
    Column.integer('amount'),
    Column.text('description'),
    Column.text('created_at')
  ], indexes: [
    Index("expenses_business_id_idx", [IndexedColumn('business_id')]),
  ]),
  Table('product_stock_managements', [
    Column.text('user_id'),
    Column.text('product_id'),
    Column.text('created_at'),
    Column.integer('adjustment_amount'),
    Column.text('notes'),
    Column.integer('before'),
    Column.integer('after'),
    Column.text('business_id')
  ])
]);
