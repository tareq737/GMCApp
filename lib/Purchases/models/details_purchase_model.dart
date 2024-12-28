// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DetailsPurchaseModel {
  int? Pur_ID;
  String? Section;
  String? Applicant;
  String? Insert_Date;
  String? Item;
  String? Specifications;
  String? Height;
  String? Width;
  String? Length;
  String? Color;
  String? Country;
  String? Usage;
  String? Warehouse_Amount;
  String? Quantity;
  String? Unit;
  String? Required_Date;
  String? Supplier;
  String? ID_Maintenance;
  String? Last_Purchase;
  String? Last_Price;
  String? Notes;
  int? Approved;
  String? Approved_Date;
  String? Manager_Note;
  String? Real_Supplier;
  String? Buyer;
  String? Expected_Date;
  String? Buy_Date;
  String? Price;
  String? Offer1;
  String? Offer2;
  String? Offer3;
  int? Received;
  String? Received_Date;
  int? Archived;
  DetailsPurchaseModel({
    this.Pur_ID,
    this.Section,
    this.Applicant,
    this.Insert_Date,
    this.Item,
    this.Specifications,
    this.Height,
    this.Width,
    this.Length,
    this.Color,
    this.Country,
    this.Usage,
    this.Warehouse_Amount,
    this.Quantity,
    this.Unit,
    this.Required_Date,
    this.Supplier,
    this.ID_Maintenance,
    this.Last_Purchase,
    this.Last_Price,
    this.Notes,
    this.Approved,
    this.Approved_Date,
    this.Manager_Note,
    this.Real_Supplier,
    this.Buyer,
    this.Expected_Date,
    this.Buy_Date,
    this.Price,
    this.Offer1,
    this.Offer2,
    this.Offer3,
    this.Received,
    this.Received_Date,
    this.Archived,
  });

  DetailsPurchaseModel copyWith({
    int? Pur_ID,
    String? Section,
    String? Applicant,
    String? Insert_Date,
    String? Item,
    String? Specifications,
    String? Height,
    String? Width,
    String? Length,
    String? Color,
    String? Country,
    String? Usage,
    String? Warehouse_Amount,
    String? Quantity,
    String? Unit,
    String? Required_Date,
    String? Supplier,
    String? ID_Maintenance,
    String? Last_Purchase,
    String? Last_Price,
    String? Notes,
    int? Approved,
    String? Approved_Date,
    String? Manager_Note,
    String? Real_Supplier,
    String? Buyer,
    String? Expected_Date,
    String? Buy_Date,
    String? Price,
    String? Offer1,
    String? Offer2,
    String? Offer3,
    int? Received,
    String? Received_Date,
    int? Archived,
  }) {
    return DetailsPurchaseModel(
      Pur_ID: Pur_ID ?? this.Pur_ID,
      Section: Section ?? this.Section,
      Applicant: Applicant ?? this.Applicant,
      Insert_Date: Insert_Date ?? this.Insert_Date,
      Item: Item ?? this.Item,
      Specifications: Specifications ?? this.Specifications,
      Height: Height ?? this.Height,
      Width: Width ?? this.Width,
      Length: Length ?? this.Length,
      Color: Color ?? this.Color,
      Country: Country ?? this.Country,
      Usage: Usage ?? this.Usage,
      Warehouse_Amount: Warehouse_Amount ?? this.Warehouse_Amount,
      Quantity: Quantity ?? this.Quantity,
      Unit: Unit ?? this.Unit,
      Required_Date: Required_Date ?? this.Required_Date,
      Supplier: Supplier ?? this.Supplier,
      ID_Maintenance: ID_Maintenance ?? this.ID_Maintenance,
      Last_Purchase: Last_Purchase ?? this.Last_Purchase,
      Last_Price: Last_Price ?? this.Last_Price,
      Notes: Notes ?? this.Notes,
      Approved: Approved ?? this.Approved,
      Approved_Date: Approved_Date ?? this.Approved_Date,
      Manager_Note: Manager_Note ?? this.Manager_Note,
      Real_Supplier: Real_Supplier ?? this.Real_Supplier,
      Buyer: Buyer ?? this.Buyer,
      Expected_Date: Expected_Date ?? this.Expected_Date,
      Buy_Date: Buy_Date ?? this.Buy_Date,
      Price: Price ?? this.Price,
      Offer1: Offer1 ?? this.Offer1,
      Offer2: Offer2 ?? this.Offer2,
      Offer3: Offer3 ?? this.Offer3,
      Received: Received ?? this.Received,
      Received_Date: Received_Date ?? this.Received_Date,
      Archived: Archived ?? this.Archived,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Pur_ID': Pur_ID,
      'Section': Section,
      'Applicant': Applicant,
      'Insert_Date': Insert_Date,
      'Item': Item,
      'Specifications': Specifications,
      'Height': Height,
      'Width': Width,
      'Length': Length,
      'Color': Color,
      'Country': Country,
      'Usage': Usage,
      'Warehouse_Amount': Warehouse_Amount,
      'Quantity': Quantity,
      'Unit': Unit,
      'Required_Date': Required_Date,
      'Supplier': Supplier,
      'ID_Maintenance': ID_Maintenance,
      'Last_Purchase': Last_Purchase,
      'Last_Price': Last_Price,
      'Notes': Notes,
      'Approved': Approved,
      'Approved_Date': Approved_Date,
      'Manager_Note': Manager_Note,
      'Real_Supplier': Real_Supplier,
      'Buyer': Buyer,
      'Expected_Date': Expected_Date,
      'Buy_Date': Buy_Date,
      'Price': Price,
      'Offer1': Offer1,
      'Offer2': Offer2,
      'Offer3': Offer3,
      'Received': Received,
      'Received_Date': Received_Date,
      'Archived': Archived,
    };
  }

  factory DetailsPurchaseModel.fromMap(Map<String, dynamic> map) {
    return DetailsPurchaseModel(
      Pur_ID: map['Pur_ID'] != null ? map['Pur_ID'] as int : null,
      Section: map['Section'] != null ? map['Section'] as String : null,
      Applicant: map['Applicant'] != null ? map['Applicant'] as String : null,
      Insert_Date:
          map['Insert_Date'] != null ? map['Insert_Date'] as String : null,
      Item: map['Item'] != null ? map['Item'] as String : null,
      Specifications: map['Specifications'] != null
          ? map['Specifications'] as String
          : null,
      Height: map['Height'] != null ? map['Height'] as String : null,
      Width: map['Width'] != null ? map['Width'] as String : null,
      Length: map['Length'] != null ? map['Length'] as String : null,
      Color: map['Color'] != null ? map['Color'] as String : null,
      Country: map['Country'] != null ? map['Country'] as String : null,
      Usage: map['Usage'] != null ? map['Usage'] as String : null,
      Warehouse_Amount: map['Warehouse_Amount'] != null
          ? map['Warehouse_Amount'] as String
          : null,
      Quantity: map['Quantity'] != null ? map['Quantity'] as String : null,
      Unit: map['Unit'] != null ? map['Unit'] as String : null,
      Required_Date:
          map['Required_Date'] != null ? map['Required_Date'] as String : null,
      Supplier: map['Supplier'] != null ? map['Supplier'] as String : null,
      ID_Maintenance: map['ID_Maintenance'] != null
          ? map['ID_Maintenance'] as String
          : null,
      Last_Purchase:
          map['Last_Purchase'] != null ? map['Last_Purchase'] as String : null,
      Last_Price:
          map['Last_Price'] != null ? map['Last_Price'] as String : null,
      Notes: map['Notes'] != null ? map['Notes'] as String : null,
      Approved: map['Approved'] != null ? map['Approved'] as int : null,
      Approved_Date:
          map['Approved_Date'] != null ? map['Approved_Date'] as String : null,
      Manager_Note:
          map['Manager_Note'] != null ? map['Manager_Note'] as String : null,
      Real_Supplier:
          map['Real_Supplier'] != null ? map['Real_Supplier'] as String : null,
      Buyer: map['Buyer'] != null ? map['Buyer'] as String : null,
      Expected_Date:
          map['Expected_Date'] != null ? map['Expected_Date'] as String : null,
      Buy_Date: map['Buy_Date'] != null ? map['Buy_Date'] as String : null,
      Price: map['Price'] != null ? map['Price'] as String : null,
      Offer1: map['Offer1'] != null ? map['Offer1'] as String : null,
      Offer2: map['Offer2'] != null ? map['Offer2'] as String : null,
      Offer3: map['Offer3'] != null ? map['Offer3'] as String : null,
      Received: map['Received'] != null ? map['Received'] as int : null,
      Received_Date:
          map['Received_Date'] != null ? map['Received_Date'] as String : null,
      Archived: map['Archived'] != null ? map['Archived'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailsPurchaseModel.fromJson(String source) =>
      DetailsPurchaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DetailsPurchaseModel(Pur_ID: $Pur_ID, Section: $Section, Applicant: $Applicant, Insert_Date: $Insert_Date, Item: $Item, Specifications: $Specifications, Height: $Height, Width: $Width, Length: $Length, Color: $Color, Country: $Country, Usage: $Usage, Warehouse_Amount: $Warehouse_Amount, Quantity: $Quantity, Unit: $Unit, Required_Date: $Required_Date, Supplier: $Supplier, ID_Maintenance: $ID_Maintenance, Last_Purchase: $Last_Purchase, Last_Price: $Last_Price, Notes: $Notes, Approved: $Approved, Approved_Date: $Approved_Date, Manager_Note: $Manager_Note, Real_Supplier: $Real_Supplier, Buyer: $Buyer, Expected_Date: $Expected_Date, Buy_Date: $Buy_Date, Price: $Price, Offer1: $Offer1, Offer2: $Offer2, Offer3: $Offer3, Received: $Received, Received_Date: $Received_Date, Archived: $Archived)';
  }

  @override
  bool operator ==(covariant DetailsPurchaseModel other) {
    if (identical(this, other)) return true;

    return other.Pur_ID == Pur_ID &&
        other.Section == Section &&
        other.Applicant == Applicant &&
        other.Insert_Date == Insert_Date &&
        other.Item == Item &&
        other.Specifications == Specifications &&
        other.Height == Height &&
        other.Width == Width &&
        other.Length == Length &&
        other.Color == Color &&
        other.Country == Country &&
        other.Usage == Usage &&
        other.Warehouse_Amount == Warehouse_Amount &&
        other.Quantity == Quantity &&
        other.Unit == Unit &&
        other.Required_Date == Required_Date &&
        other.Supplier == Supplier &&
        other.ID_Maintenance == ID_Maintenance &&
        other.Last_Purchase == Last_Purchase &&
        other.Last_Price == Last_Price &&
        other.Notes == Notes &&
        other.Approved == Approved &&
        other.Approved_Date == Approved_Date &&
        other.Manager_Note == Manager_Note &&
        other.Real_Supplier == Real_Supplier &&
        other.Buyer == Buyer &&
        other.Expected_Date == Expected_Date &&
        other.Buy_Date == Buy_Date &&
        other.Price == Price &&
        other.Offer1 == Offer1 &&
        other.Offer2 == Offer2 &&
        other.Offer3 == Offer3 &&
        other.Received == Received &&
        other.Received_Date == Received_Date &&
        other.Archived == Archived;
  }

  @override
  int get hashCode {
    return Pur_ID.hashCode ^
        Section.hashCode ^
        Applicant.hashCode ^
        Insert_Date.hashCode ^
        Item.hashCode ^
        Specifications.hashCode ^
        Height.hashCode ^
        Width.hashCode ^
        Length.hashCode ^
        Color.hashCode ^
        Country.hashCode ^
        Usage.hashCode ^
        Warehouse_Amount.hashCode ^
        Quantity.hashCode ^
        Unit.hashCode ^
        Required_Date.hashCode ^
        Supplier.hashCode ^
        ID_Maintenance.hashCode ^
        Last_Purchase.hashCode ^
        Last_Price.hashCode ^
        Notes.hashCode ^
        Approved.hashCode ^
        Approved_Date.hashCode ^
        Manager_Note.hashCode ^
        Real_Supplier.hashCode ^
        Buyer.hashCode ^
        Expected_Date.hashCode ^
        Buy_Date.hashCode ^
        Price.hashCode ^
        Offer1.hashCode ^
        Offer2.hashCode ^
        Offer3.hashCode ^
        Received.hashCode ^
        Received_Date.hashCode ^
        Archived.hashCode;
  }
}
