class CustomerEntity {
  int id;
  CustomerAddressEntity address;
  CustomerBasicInfoEntity basicInfo;
  CustomerPersonalInfoEntity personalInfo;
  CustomerShopBasicInfoEntity shopBasicInfo;
  CustomerDiscountsEntity discounts;
  CustomerMarketInfoEntity marketInfo;
  CustomerMethodsOfDealingEntity methodsOfDealing;
  CustomerActivityEntity activity;
  CustomerSpecialBrandsEntity specialBrands;
  String? notes;
  CustomerEntity({
    required this.id,
    CustomerAddressEntity? address,
    CustomerBasicInfoEntity? basicInfo,
    CustomerPersonalInfoEntity? personalInfo,
    CustomerShopBasicInfoEntity? shopBasicInfo,
    CustomerDiscountsEntity? discounts,
    CustomerMarketInfoEntity? marketInfo,
    CustomerMethodsOfDealingEntity? methodsOfDealing,
    CustomerActivityEntity? activity,
    CustomerSpecialBrandsEntity? specialBrands,
    this.notes,
  })  : address = address ?? CustomerAddressEntity(),
        basicInfo = basicInfo ?? CustomerBasicInfoEntity(),
        personalInfo = personalInfo ?? CustomerPersonalInfoEntity(),
        shopBasicInfo = shopBasicInfo ?? CustomerShopBasicInfoEntity(),
        discounts = discounts ?? CustomerDiscountsEntity(),
        marketInfo = marketInfo ?? CustomerMarketInfoEntity(),
        methodsOfDealing = methodsOfDealing ?? CustomerMethodsOfDealingEntity(),
        activity = activity ?? CustomerActivityEntity(),
        specialBrands = specialBrands ?? CustomerSpecialBrandsEntity();
}

class CustomerAddressEntity {
  String? address;
  String? governate;
  String? region;
  String? shopCoordinates;
  CustomerAddressEntity({
    this.address,
    this.governate,
    this.region,
    this.shopCoordinates,
  });
}

class CustomerBasicInfoEntity {
  String? customerName;
  String? shopName;
  String? telNumber;
  String? mobileNumber;
  CustomerBasicInfoEntity({
    this.customerName,
    this.shopName,
    this.telNumber,
    this.mobileNumber,
  });
}

class CustomerPersonalInfoEntity {
  String? clientPlaceOfBirth;
  int clientYearOfBirth;
  String? clientMaritalStatus;
  int clientNumberOfChildren;
  CustomerPersonalInfoEntity({
    this.clientPlaceOfBirth,
    this.clientYearOfBirth = 1900,
    this.clientMaritalStatus,
    this.clientNumberOfChildren = 0,
  });
}

class CustomerShopBasicInfoEntity {
  int shopSpace;
  int numberOfWarehouses;
  int numberOfWorkers;
  bool shopStatus;
  CustomerShopBasicInfoEntity({
    this.shopSpace = 0,
    this.numberOfWarehouses = 0,
    this.numberOfWorkers = 0,
    this.shopStatus = false,
  });
}

class CustomerDiscountsEntity {
  double staticDiscount;
  double monthDiscount;
  double yearDiscount;
  String? giftOnQuantity;
  String? giftOnValue;
  CustomerDiscountsEntity({
    this.staticDiscount = 0.0,
    this.monthDiscount = 0.0,
    this.yearDiscount = 0.0,
    this.giftOnQuantity,
    this.giftOnValue,
  });
}

class CustomerMarketInfoEntity {
  String? clientActivityOld;
  String? responsible;
  int customerSize;
  String? clientTradeType;
  String? clientSpread;
  String? paintProffesion;
  String? dependenceOnCompany;
  bool? isDirectCustomer;
  String? credFinance;
  String? credDeals;
  String? credComplains;
  CustomerMarketInfoEntity({
    this.clientActivityOld,
    this.responsible,
    this.customerSize = 0,
    this.clientTradeType,
    this.clientSpread,
    this.paintProffesion,
    this.dependenceOnCompany,
    this.isDirectCustomer,
    this.credFinance,
    this.credDeals,
    this.credComplains,
  });
}

class CustomerMethodsOfDealingEntity {
  bool methodCash;
  bool methodPayments;
  bool methodOffers;
  bool methodCustody;
  CustomerMethodsOfDealingEntity({
    this.methodCash = false,
    this.methodPayments = false,
    this.methodOffers = false,
    this.methodCustody = false,
  });
}

class CustomerActivityEntity {
  bool activityPaints;
  bool activityPlumping;
  bool activityElectrical;
  bool activityHaberdashery;
  CustomerActivityEntity({
    this.activityPaints = false,
    this.activityPlumping = false,
    this.activityElectrical = false,
    this.activityHaberdashery = false,
  });
}

class CustomerSpecialBrandsEntity {
  String? specialItemsOil;
  String? specialItemsWater;
  String? specialItemsAcrylic;
  CustomerSpecialBrandsEntity({
    this.specialItemsOil,
    this.specialItemsWater,
    this.specialItemsAcrylic,
  });
}
