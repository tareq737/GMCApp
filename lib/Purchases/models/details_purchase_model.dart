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
  String? WarehouseAmount;
  String? Quantity;
  String? Unit;
  String? RequiredDate;
  String? Supplier;
  String? IDMaintenance;
  String? LastPurchase;
  String? LastPrice;
  String? Notes;
  int? Approved;
  String? ApprovedDate;
  String? ManagerNote;
  String? RealSupplier;
  String? Buyer;
  String? ExpectedDate;
  String? BuyDate;
  String? Price;
  String? Offer1;
  String? Offer2;
  String? Offer3;
  int? Received;
  String? ReceivedDate;
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
    this.WarehouseAmount,
    this.Quantity,
    this.Unit,
    this.RequiredDate,
    this.Supplier,
    this.IDMaintenance,
    this.LastPurchase,
    this.LastPrice,
    this.Notes,
    this.Approved,
    this.ApprovedDate,
    this.ManagerNote,
    this.RealSupplier,
    this.Buyer,
    this.ExpectedDate,
    this.BuyDate,
    this.Price,
    this.Offer1,
    this.Offer2,
    this.Offer3,
    this.Received,
    this.ReceivedDate,
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
    String? WarehouseAmount,
    String? Quantity,
    String? Unit,
    String? RequiredDate,
    String? Supplier,
    String? IDMaintenance,
    String? LastPurchase,
    String? LastPrice,
    String? Notes,
    int? Approved,
    String? ApprovedDate,
    String? ManagerNote,
    String? RealSupplier,
    String? Buyer,
    String? ExpectedDate,
    String? BuyDate,
    String? Price,
    String? Offer1,
    String? Offer2,
    String? Offer3,
    int? Received,
    String? ReceivedDate,
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
      WarehouseAmount: WarehouseAmount ?? this.WarehouseAmount,
      Quantity: Quantity ?? this.Quantity,
      Unit: Unit ?? this.Unit,
      RequiredDate: RequiredDate ?? this.RequiredDate,
      Supplier: Supplier ?? this.Supplier,
      IDMaintenance: IDMaintenance ?? this.IDMaintenance,
      LastPurchase: LastPurchase ?? this.LastPurchase,
      LastPrice: LastPrice ?? this.LastPrice,
      Notes: Notes ?? this.Notes,
      Approved: Approved ?? this.Approved,
      ApprovedDate: ApprovedDate ?? this.ApprovedDate,
      ManagerNote: ManagerNote ?? this.ManagerNote,
      RealSupplier: RealSupplier ?? this.RealSupplier,
      Buyer: Buyer ?? this.Buyer,
      ExpectedDate: ExpectedDate ?? this.ExpectedDate,
      BuyDate: BuyDate ?? this.BuyDate,
      Price: Price ?? this.Price,
      Offer1: Offer1 ?? this.Offer1,
      Offer2: Offer2 ?? this.Offer2,
      Offer3: Offer3 ?? this.Offer3,
      Received: Received ?? this.Received,
      ReceivedDate: ReceivedDate ?? this.ReceivedDate,
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
      'WarehouseAmount': WarehouseAmount,
      'Quantity': Quantity,
      'Unit': Unit,
      'RequiredDate': RequiredDate,
      'Supplier': Supplier,
      'IDMaintenance': IDMaintenance,
      'LastPurchase': LastPurchase,
      'LastPrice': LastPrice,
      'Notes': Notes,
      'Approved': Approved,
      'ApprovedDate': ApprovedDate,
      'ManagerNote': ManagerNote,
      'RealSupplier': RealSupplier,
      'Buyer': Buyer,
      'ExpectedDate': ExpectedDate,
      'BuyDate': BuyDate,
      'Price': Price,
      'Offer1': Offer1,
      'Offer2': Offer2,
      'Offer3': Offer3,
      'Received': Received,
      'ReceivedDate': ReceivedDate,
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
      WarehouseAmount: map['WarehouseAmount'] != null
          ? map['WarehouseAmount'] as String
          : null,
      Quantity: map['Quantity'] != null ? map['Quantity'] as String : null,
      Unit: map['Unit'] != null ? map['Unit'] as String : null,
      RequiredDate:
          map['RequiredDate'] != null ? map['RequiredDate'] as String : null,
      Supplier: map['Supplier'] != null ? map['Supplier'] as String : null,
      IDMaintenance:
          map['IDMaintenance'] != null ? map['IDMaintenance'] as String : null,
      LastPurchase:
          map['LastPurchase'] != null ? map['LastPurchase'] as String : null,
      LastPrice: map['LastPrice'] != null ? map['LastPrice'] as String : null,
      Notes: map['Notes'] != null ? map['Notes'] as String : null,
      Approved: map['Approved'] != null ? map['Approved'] as int : null,
      ApprovedDate:
          map['ApprovedDate'] != null ? map['ApprovedDate'] as String : null,
      ManagerNote:
          map['ManagerNote'] != null ? map['ManagerNote'] as String : null,
      RealSupplier:
          map['RealSupplier'] != null ? map['RealSupplier'] as String : null,
      Buyer: map['Buyer'] != null ? map['Buyer'] as String : null,
      ExpectedDate:
          map['ExpectedDate'] != null ? map['ExpectedDate'] as String : null,
      BuyDate: map['BuyDate'] != null ? map['BuyDate'] as String : null,
      Price: map['Price'] != null ? map['Price'] as String : null,
      Offer1: map['Offer1'] != null ? map['Offer1'] as String : null,
      Offer2: map['Offer2'] != null ? map['Offer2'] as String : null,
      Offer3: map['Offer3'] != null ? map['Offer3'] as String : null,
      Received: map['Received'] != null ? map['Received'] as int : null,
      ReceivedDate:
          map['ReceivedDate'] != null ? map['ReceivedDate'] as String : null,
      Archived: map['Archived'] != null ? map['Archived'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailsPurchaseModel.fromJson(String source) =>
      DetailsPurchaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DetailsPurchaseModel(Pur_ID: $Pur_ID, Section: $Section, Applicant: $Applicant, Insert_Date: $Insert_Date, Item: $Item, Specifications: $Specifications, Height: $Height, Width: $Width, Length: $Length, Color: $Color, Country: $Country, Usage: $Usage, WarehouseAmount: $WarehouseAmount, Quantity: $Quantity, Unit: $Unit, RequiredDate: $RequiredDate, Supplier: $Supplier, IDMaintenance: $IDMaintenance, LastPurchase: $LastPurchase, LastPrice: $LastPrice, Notes: $Notes, Approved: $Approved, ApprovedDate: $ApprovedDate, ManagerNote: $ManagerNote, RealSupplier: $RealSupplier, Buyer: $Buyer, ExpectedDate: $ExpectedDate, BuyDate: $BuyDate, Price: $Price, Offer1: $Offer1, Offer2: $Offer2, Offer3: $Offer3, Received: $Received, ReceivedDate: $ReceivedDate, Archived: $Archived)';
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
        other.WarehouseAmount == WarehouseAmount &&
        other.Quantity == Quantity &&
        other.Unit == Unit &&
        other.RequiredDate == RequiredDate &&
        other.Supplier == Supplier &&
        other.IDMaintenance == IDMaintenance &&
        other.LastPurchase == LastPurchase &&
        other.LastPrice == LastPrice &&
        other.Notes == Notes &&
        other.Approved == Approved &&
        other.ApprovedDate == ApprovedDate &&
        other.ManagerNote == ManagerNote &&
        other.RealSupplier == RealSupplier &&
        other.Buyer == Buyer &&
        other.ExpectedDate == ExpectedDate &&
        other.BuyDate == BuyDate &&
        other.Price == Price &&
        other.Offer1 == Offer1 &&
        other.Offer2 == Offer2 &&
        other.Offer3 == Offer3 &&
        other.Received == Received &&
        other.ReceivedDate == ReceivedDate &&
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
        WarehouseAmount.hashCode ^
        Quantity.hashCode ^
        Unit.hashCode ^
        RequiredDate.hashCode ^
        Supplier.hashCode ^
        IDMaintenance.hashCode ^
        LastPurchase.hashCode ^
        LastPrice.hashCode ^
        Notes.hashCode ^
        Approved.hashCode ^
        ApprovedDate.hashCode ^
        ManagerNote.hashCode ^
        RealSupplier.hashCode ^
        Buyer.hashCode ^
        ExpectedDate.hashCode ^
        BuyDate.hashCode ^
        Price.hashCode ^
        Offer1.hashCode ^
        Offer2.hashCode ^
        Offer3.hashCode ^
        Received.hashCode ^
        ReceivedDate.hashCode ^
        Archived.hashCode;
  }
}
