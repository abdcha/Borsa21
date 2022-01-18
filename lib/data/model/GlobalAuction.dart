class GlobalAuction {
  late Data data;

  GlobalAuction({required this.data});

  GlobalAuction.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late String baseCurrencyCode;
  late String baseCurrencyName;
  late String amount;
  late String updatedDate;
  late Rates rates;
  late String status;

  Data.fromJson(Map<String, dynamic> json) {
    baseCurrencyCode = json['base_currency_code'];
    baseCurrencyName = json['base_currency_name'];
    amount = json['amount'];
    updatedDate = json['updated_date'];
    rates = (json['rates'] != null ? new Rates.fromJson(json['rates']) : null)!;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_currency_code'] = this.baseCurrencyCode;
    data['base_currency_name'] = this.baseCurrencyName;
    data['amount'] = this.amount;
    data['updated_date'] = this.updatedDate;
    if (this.rates != null) {
      data['rates'] = this.rates.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Rates {
  late PLN cNY;
  late PLN cAD;
  late PLN qAR;
  late PLN sAR;
  late PLN jOD;
  late PLN eUR;
  late PLN tRY;
  late PLN gBP;
  late PLN jPY;
  late PLN sEK;
  late PLN nOK;
  late PLN dKK;
  late PLN aZN;
  late PLN aED;
  late PLN lBP;
  late PLN eGP;
  late PLN bHD;
  late PLN kWD;
  late PLN sYP;
  late PLN iRR;

  Rates.fromJson(Map<String, dynamic> json) {
    cNY = (json['CNY'] != null ? new PLN.fromJson(json['CNY']) : null)!;
    cAD = (json['CAD'] != null ? new PLN.fromJson(json['CAD']) : null)!;
    eUR = (json['EUR'] != null ? new PLN.fromJson(json['EUR']) : null)!;
    gBP = (json['GBP'] != null ? new PLN.fromJson(json['GBP']) : null)!;
    jPY = (json['JPY'] != null ? new PLN.fromJson(json['JPY']) : null)!;
    dKK = (json['DKK'] != null ? new PLN.fromJson(json['DKK']) : null)!;
    nOK = (json['NOK'] != null ? new PLN.fromJson(json['NOK']) : null)!;
    sEK = (json['SEK'] != null ? new PLN.fromJson(json['SEK']) : null)!;
    eGP = (json['EGP'] != null ? new PLN.fromJson(json['EGP']) : null)!;
    lBP = (json['LBP'] != null ? new PLN.fromJson(json['LBP']) : null)!;
    aZN = (json['AZN'] != null ? new PLN.fromJson(json['AZN']) : null)!;
    bHD = (json['BHD'] != null ? new PLN.fromJson(json['BHD']) : null)!;
    jOD = (json['JOD'] != null ? new PLN.fromJson(json['JOD']) : null)!;
    kWD = (json['KWD'] != null ? new PLN.fromJson(json['KWD']) : null)!;
    tRY = (json['TRY'] != null ? new PLN.fromJson(json['TRY']) : null)!;
    iRR = (json['IRR'] != null ? new PLN.fromJson(json['IRR']) : null)!;
    aED = (json['AED'] != null ? new PLN.fromJson(json['AED']) : null)!;
    sYP = (json['SYP'] != null ? new PLN.fromJson(json['SYP']) : null)!;
    qAR = (json['QAR'] != null ? new PLN.fromJson(json['QAR']) : null)!;
    sAR = (json['SAR'] != null ? new PLN.fromJson(json['SAR']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.cNY != null) {
      data['CNY'] = this.cNY.toJson();
    }
    if (this.cAD != null) {
      data['CAD'] = this.cAD.toJson();
    }

    if (this.eUR != null) {
      data['EUR'] = this.eUR.toJson();
    }

    if (this.gBP != null) {
      data['GBP'] = this.gBP.toJson();
    }

    if (this.jPY != null) {
      data['JPY'] = this.jPY.toJson();
    }

    if (this.dKK != null) {
      data['DKK'] = this.dKK.toJson();
    }

    if (this.nOK != null) {
      data['NOK'] = this.nOK.toJson();
    }
    if (this.sEK != null) {
      data['SEK'] = this.sEK.toJson();
    }

    if (this.eGP != null) {
      data['EGP'] = this.eGP.toJson();
    }

    if (this.lBP != null) {
      data['LBP'] = this.lBP.toJson();
    }

    if (this.aZN != null) {
      data['AZN'] = this.aZN.toJson();
    }

    if (this.bHD != null) {
      data['BHD'] = this.bHD.toJson();
    }

    if (this.jOD != null) {
      data['JOD'] = this.jOD.toJson();
    }
    if (this.kWD != null) {
      data['KWD'] = this.kWD.toJson();
    }

    if (this.tRY != null) {
      data['TRY'] = this.tRY.toJson();
    }

    if (this.iRR != null) {
      data['IRR'] = this.iRR.toJson();
    }

    if (this.aED != null) {
      data['AED'] = this.aED.toJson();
    }

    if (this.sYP != null) {
      data['SYP'] = this.sYP.toJson();
    }

    if (this.qAR != null) {
      data['QAR'] = this.qAR.toJson();
    }

    if (this.sAR != null) {
      data['SAR'] = this.sAR.toJson();
    }
    return data;
  }
}

class PLN {
  late String currencyName;
  late String rate;
  late String rateForAmount;

  PLN(
      {required this.currencyName,
      required this.rate,
      required this.rateForAmount});

  PLN.fromJson(Map<String, dynamic> json) {
    currencyName = json['currency_name'];
    rate = json['rate'];
    rateForAmount = json['rate_for_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_name'] = this.currencyName;
    data['rate'] = this.rate;
    data['rate_for_amount'] = this.rateForAmount;
    return data;
  }
}
