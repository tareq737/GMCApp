// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PurchasesModel {
  int? id;
  String? applicant;
  String? insert_date;
  String? department;
  String? type;
  String? details;
  double? quantity;
  String? unit;
  String? warehouse_balance;
  String? supplier;
  String? real_supplier;
  bool? manager_check;
  String? manager_notes;
  String? manager_check_date;
  bool? manager2_check;
  String? manager2_notes;
  String? manager2_check_date;
  String? height;
  String? width;
  String? length;
  String? color;
  String? country;
  String? usage;
  String? last_purchased;
  String? purchase_date;
  String? required_date;
  String? expected_date;
  String? last_price;
  String? purchase_notes;
  String? buyer;
  String? price;
  String? offer_1;
  String? offer_2;
  String? offer_3;
  bool? received_check;
  String? received_check_date;
  String? received_check_notes;
  bool? archived;
  int? applicant_approve;
  String? bill;
  String? offer_1_image;
  String? offer_2_image;
  String? offer_3_image;
  String? datasheet_1;
  String? datasheet_2;
  String? datasheet_3;
  String? insert_offer_date;
  String? applicant_approve_date;
  int? purchase_handler;
  bool? non_compliant;
  PurchasesModel({
    this.id,
    this.applicant,
    this.insert_date,
    this.department,
    this.type,
    this.details,
    this.quantity,
    this.unit,
    this.warehouse_balance,
    this.supplier,
    this.real_supplier,
    this.manager_check,
    this.manager_notes,
    this.manager_check_date,
    this.manager2_check,
    this.manager2_notes,
    this.manager2_check_date,
    this.height,
    this.width,
    this.length,
    this.color,
    this.country,
    this.usage,
    this.last_purchased,
    this.purchase_date,
    this.required_date,
    this.expected_date,
    this.last_price,
    this.purchase_notes,
    this.buyer,
    this.price,
    this.offer_1,
    this.offer_2,
    this.offer_3,
    this.received_check,
    this.received_check_date,
    this.received_check_notes,
    this.archived,
    this.applicant_approve,
    this.bill,
    this.offer_1_image,
    this.offer_2_image,
    this.offer_3_image,
    this.datasheet_1,
    this.datasheet_2,
    this.datasheet_3,
    this.insert_offer_date,
    this.applicant_approve_date,
    this.purchase_handler,
    this.non_compliant,
  });

  PurchasesModel copyWith({
    int? id,
    String? applicant,
    String? insert_date,
    String? department,
    String? type,
    String? details,
    double? quantity,
    String? unit,
    String? warehouse_balance,
    String? supplier,
    String? real_supplier,
    bool? manager_check,
    String? manager_notes,
    String? manager_check_date,
    bool? manager2_check,
    String? manager2_notes,
    String? manager2_check_date,
    String? height,
    String? width,
    String? length,
    String? color,
    String? country,
    String? usage,
    String? last_purchased,
    String? purchase_date,
    String? required_date,
    String? expected_date,
    String? last_price,
    String? purchase_notes,
    String? buyer,
    String? price,
    String? offer_1,
    String? offer_2,
    String? offer_3,
    bool? received_check,
    String? received_check_date,
    String? received_check_notes,
    bool? archived,
    int? applicant_approve,
    String? bill,
    String? offer_1_image,
    String? offer_2_image,
    String? offer_3_image,
    String? datasheet_1,
    String? datasheet_2,
    String? datasheet_3,
    String? insert_offer_date,
    String? applicant_approve_date,
    int? purchase_handler,
    bool? non_compliant,
  }) {
    return PurchasesModel(
      id: id ?? this.id,
      applicant: applicant ?? this.applicant,
      insert_date: insert_date ?? this.insert_date,
      department: department ?? this.department,
      type: type ?? this.type,
      details: details ?? this.details,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      warehouse_balance: warehouse_balance ?? this.warehouse_balance,
      supplier: supplier ?? this.supplier,
      real_supplier: real_supplier ?? this.real_supplier,
      manager_check: manager_check ?? this.manager_check,
      manager_notes: manager_notes ?? this.manager_notes,
      manager_check_date: manager_check_date ?? this.manager_check_date,
      manager2_check: manager2_check ?? this.manager2_check,
      manager2_notes: manager2_notes ?? this.manager2_notes,
      manager2_check_date: manager2_check_date ?? this.manager2_check_date,
      height: height ?? this.height,
      width: width ?? this.width,
      length: length ?? this.length,
      color: color ?? this.color,
      country: country ?? this.country,
      usage: usage ?? this.usage,
      last_purchased: last_purchased ?? this.last_purchased,
      purchase_date: purchase_date ?? this.purchase_date,
      required_date: required_date ?? this.required_date,
      expected_date: expected_date ?? this.expected_date,
      last_price: last_price ?? this.last_price,
      purchase_notes: purchase_notes ?? this.purchase_notes,
      buyer: buyer ?? this.buyer,
      price: price ?? this.price,
      offer_1: offer_1 ?? this.offer_1,
      offer_2: offer_2 ?? this.offer_2,
      offer_3: offer_3 ?? this.offer_3,
      received_check: received_check ?? this.received_check,
      received_check_date: received_check_date ?? this.received_check_date,
      received_check_notes: received_check_notes ?? this.received_check_notes,
      archived: archived ?? this.archived,
      applicant_approve: applicant_approve ?? this.applicant_approve,
      bill: bill ?? this.bill,
      offer_1_image: offer_1_image ?? this.offer_1_image,
      offer_2_image: offer_2_image ?? this.offer_2_image,
      offer_3_image: offer_3_image ?? this.offer_3_image,
      datasheet_1: datasheet_1 ?? this.datasheet_1,
      datasheet_2: datasheet_2 ?? this.datasheet_2,
      datasheet_3: datasheet_3 ?? this.datasheet_3,
      insert_offer_date: insert_offer_date ?? this.insert_offer_date,
      applicant_approve_date:
          applicant_approve_date ?? this.applicant_approve_date,
      purchase_handler: purchase_handler ?? this.purchase_handler,
      non_compliant: non_compliant ?? this.non_compliant,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'applicant': applicant,
      'insert_date': insert_date,
      'department': department,
      'type': type,
      'details': details,
      'quantity': quantity,
      'unit': unit,
      'warehouse_balance': warehouse_balance,
      'supplier': supplier,
      'real_supplier': real_supplier,
      'manager_check': manager_check,
      'manager_notes': manager_notes,
      'manager_check_date': manager_check_date,
      'manager2_check': manager2_check,
      'manager2_notes': manager2_notes,
      'manager2_check_date': manager2_check_date,
      'height': height,
      'width': width,
      'length': length,
      'color': color,
      'country': country,
      'usage': usage,
      'last_purchased': last_purchased,
      'purchase_date': purchase_date,
      'required_date': required_date,
      'expected_date': expected_date,
      'last_price': last_price,
      'purchase_notes': purchase_notes,
      'buyer': buyer,
      'price': price,
      'offer_1': offer_1,
      'offer_2': offer_2,
      'offer_3': offer_3,
      'received_check': received_check,
      'received_check_date': received_check_date,
      'received_check_notes': received_check_notes,
      'archived': archived,
      'applicant_approve': applicant_approve,
      'insert_offer_date': insert_offer_date,
      'applicant_approve_date': applicant_approve_date,
      'purchase_handler': purchase_handler,
    };
  }

  factory PurchasesModel.fromMap(Map<String, dynamic> map) {
    return PurchasesModel(
      id: map['id'] != null ? map['id'] as int : null,
      applicant: map['applicant'] != null ? map['applicant'] as String : null,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      details: map['details'] != null ? map['details'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as double : null,
      unit: map['unit'] != null ? map['unit'] as String : null,
      warehouse_balance: map['warehouse_balance'] != null
          ? map['warehouse_balance'] as String
          : null,
      supplier: map['supplier'] != null ? map['supplier'] as String : null,
      real_supplier:
          map['real_supplier'] != null ? map['real_supplier'] as String : null,
      manager_check:
          map['manager_check'] != null ? map['manager_check'] as bool : null,
      manager_notes:
          map['manager_notes'] != null ? map['manager_notes'] as String : null,
      manager_check_date: map['manager_check_date'] != null
          ? map['manager_check_date'] as String
          : null,
      manager2_check:
          map['manager2_check'] != null ? map['manager2_check'] as bool : null,
      manager2_notes: map['manager2_notes'] != null
          ? map['manager2_notes'] as String
          : null,
      manager2_check_date: map['manager2_check_date'] != null
          ? map['manager2_check_date'] as String
          : null,
      height: map['height'] != null ? map['height'] as String : null,
      width: map['width'] != null ? map['width'] as String : null,
      length: map['length'] != null ? map['length'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      usage: map['usage'] != null ? map['usage'] as String : null,
      last_purchased: map['last_purchased'] != null
          ? map['last_purchased'] as String
          : null,
      purchase_date:
          map['purchase_date'] != null ? map['purchase_date'] as String : null,
      required_date:
          map['required_date'] != null ? map['required_date'] as String : null,
      expected_date:
          map['expected_date'] != null ? map['expected_date'] as String : null,
      last_price:
          map['last_price'] != null ? map['last_price'] as String : null,
      purchase_notes: map['purchase_notes'] != null
          ? map['purchase_notes'] as String
          : null,
      buyer: map['buyer'] != null ? map['buyer'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      offer_1: map['offer_1'] != null ? map['offer_1'] as String : null,
      offer_2: map['offer_2'] != null ? map['offer_2'] as String : null,
      offer_3: map['offer_3'] != null ? map['offer_3'] as String : null,
      received_check:
          map['received_check'] != null ? map['received_check'] as bool : null,
      received_check_date: map['received_check_date'] != null
          ? map['received_check_date'] as String
          : null,
      received_check_notes: map['received_check_notes'] != null
          ? map['received_check_notes'] as String
          : null,
      archived: map['archived'] != null ? map['archived'] as bool : null,
      applicant_approve: map['applicant_approve'] != null
          ? map['applicant_approve'] as int
          : null,
      bill: map['bill'] != null ? map['bill'] as String : null,
      offer_1_image:
          map['offer_1_image'] != null ? map['offer_1_image'] as String : null,
      offer_2_image:
          map['offer_2_image'] != null ? map['offer_2_image'] as String : null,
      offer_3_image:
          map['offer_3_image'] != null ? map['offer_3_image'] as String : null,
      datasheet_1:
          map['datasheet_1'] != null ? map['datasheet_1'] as String : null,
      datasheet_2:
          map['datasheet_2'] != null ? map['datasheet_2'] as String : null,
      datasheet_3:
          map['datasheet_3'] != null ? map['datasheet_3'] as String : null,
      insert_offer_date: map['insert_offer_date'] != null
          ? map['insert_offer_date'] as String
          : null,
      applicant_approve_date: map['applicant_approve_date'] != null
          ? map['applicant_approve_date'] as String
          : null,
      purchase_handler: map['purchase_handler'] != null
          ? map['purchase_handler'] as int
          : null,
      non_compliant:
          map['non_compliant'] != null ? map['non_compliant'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchasesModel.fromJson(String source) =>
      PurchasesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PurchasesModel(id: $id, applicant: $applicant, insert_date: $insert_date, department: $department, type: $type, details: $details, quantity: $quantity, unit: $unit, warehouse_balance: $warehouse_balance, supplier: $supplier, real_supplier: $real_supplier, manager_check: $manager_check, manager_notes: $manager_notes, manager_check_date: $manager_check_date, manager2_check: $manager2_check, manager2_notes: $manager2_notes, manager2_check_date: $manager2_check_date, height: $height, width: $width, length: $length, color: $color, country: $country, usage: $usage, last_purchased: $last_purchased, purchase_date: $purchase_date, required_date: $required_date, expected_date: $expected_date, last_price: $last_price, purchase_notes: $purchase_notes, buyer: $buyer, price: $price, offer_1: $offer_1, offer_2: $offer_2, offer_3: $offer_3, received_check: $received_check, received_check_date: $received_check_date, received_check_notes: $received_check_notes, archived: $archived, applicant_approve: $applicant_approve, bill: $bill, offer_1_image: $offer_1_image, offer_2_image: $offer_2_image, offer_3_image: $offer_3_image, datasheet_1: $datasheet_1, datasheet_2: $datasheet_2, datasheet_3: $datasheet_3, insert_offer_date: $insert_offer_date, applicant_approve_date: $applicant_approve_date, purchase_handler: $purchase_handler, non_compliant: $non_compliant)';
  }

  @override
  bool operator ==(covariant PurchasesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.applicant == applicant &&
        other.insert_date == insert_date &&
        other.department == department &&
        other.type == type &&
        other.details == details &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.warehouse_balance == warehouse_balance &&
        other.supplier == supplier &&
        other.real_supplier == real_supplier &&
        other.manager_check == manager_check &&
        other.manager_notes == manager_notes &&
        other.manager_check_date == manager_check_date &&
        other.manager2_check == manager2_check &&
        other.manager2_notes == manager2_notes &&
        other.manager2_check_date == manager2_check_date &&
        other.height == height &&
        other.width == width &&
        other.length == length &&
        other.color == color &&
        other.country == country &&
        other.usage == usage &&
        other.last_purchased == last_purchased &&
        other.purchase_date == purchase_date &&
        other.required_date == required_date &&
        other.expected_date == expected_date &&
        other.last_price == last_price &&
        other.purchase_notes == purchase_notes &&
        other.buyer == buyer &&
        other.price == price &&
        other.offer_1 == offer_1 &&
        other.offer_2 == offer_2 &&
        other.offer_3 == offer_3 &&
        other.received_check == received_check &&
        other.received_check_date == received_check_date &&
        other.received_check_notes == received_check_notes &&
        other.archived == archived &&
        other.applicant_approve == applicant_approve &&
        other.bill == bill &&
        other.offer_1_image == offer_1_image &&
        other.offer_2_image == offer_2_image &&
        other.offer_3_image == offer_3_image &&
        other.datasheet_1 == datasheet_1 &&
        other.datasheet_2 == datasheet_2 &&
        other.datasheet_3 == datasheet_3 &&
        other.insert_offer_date == insert_offer_date &&
        other.applicant_approve_date == applicant_approve_date &&
        other.purchase_handler == purchase_handler &&
        other.non_compliant == non_compliant;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        applicant.hashCode ^
        insert_date.hashCode ^
        department.hashCode ^
        type.hashCode ^
        details.hashCode ^
        quantity.hashCode ^
        unit.hashCode ^
        warehouse_balance.hashCode ^
        supplier.hashCode ^
        real_supplier.hashCode ^
        manager_check.hashCode ^
        manager_notes.hashCode ^
        manager_check_date.hashCode ^
        manager2_check.hashCode ^
        manager2_notes.hashCode ^
        manager2_check_date.hashCode ^
        height.hashCode ^
        width.hashCode ^
        length.hashCode ^
        color.hashCode ^
        country.hashCode ^
        usage.hashCode ^
        last_purchased.hashCode ^
        purchase_date.hashCode ^
        required_date.hashCode ^
        expected_date.hashCode ^
        last_price.hashCode ^
        purchase_notes.hashCode ^
        buyer.hashCode ^
        price.hashCode ^
        offer_1.hashCode ^
        offer_2.hashCode ^
        offer_3.hashCode ^
        received_check.hashCode ^
        received_check_date.hashCode ^
        received_check_notes.hashCode ^
        archived.hashCode ^
        applicant_approve.hashCode ^
        bill.hashCode ^
        offer_1_image.hashCode ^
        offer_2_image.hashCode ^
        offer_3_image.hashCode ^
        datasheet_1.hashCode ^
        datasheet_2.hashCode ^
        datasheet_3.hashCode ^
        insert_offer_date.hashCode ^
        applicant_approve_date.hashCode ^
        purchase_handler.hashCode ^
        non_compliant.hashCode;
  }
}
