//
//  MarketData.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/3/22.
//

import Foundation

//CoinGecko Market API info
/*
 URL:
    https://api.coingecko.com/api/v3/global
 
 JSON Response:
 {
   "data": {
     "active_cryptocurrencies": 12317,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 728,
     "total_market_cap": {
       "btc": 48215631.699206896,
       "eth": 677519880.125438,
       "ltc": 16449712758.52489,
       "bch": 6465820222.310118,
       "bnb": 4846051278.861668,
       "eos": 780614804888.2056,
       "xrp": 2949022891637.521,
       "xlm": 9248068737237.352,
       "link": 110784250465.5567,
       "dot": 95809951454.60732,
       "yfi": 77340003.3081791,
       "usd": 1775074234837.8074,
       "aed": 6519847664559.287,
       "ars": 186940286897682.53,
       "aud": 2486683744841.9385,
       "bdt": 152466642960941.25,
       "bhd": 669165709974.9211,
       "bmd": 1775074234837.8074,
       "brl": 9405408340711.62,
       "cad": 2249835589687.5303,
       "chf": 1633116223055.1226,
       "clp": 1452383489686641.8,
       "cny": 11291247207803.297,
       "czk": 37766479420409.23,
       "dkk": 11557827856391.256,
       "eur": 1553117177439.4531,
       "gbp": 1305116230867.5571,
       "hkd": 13833686034361.518,
       "huf": 550176963532875.8,
       "idr": 25525671429339196,
       "ils": 5661350761622.291,
       "inr": 132627776060743.66,
       "jpy": 204013423643873.72,
       "krw": 2132119782705692.2,
       "kwd": 536823275322.35254,
       "lkr": 359548860508158.4,
       "mmk": 3153038177447287,
       "mxn": 36540698357393.516,
       "myr": 7431348284148.4795,
       "ngn": 738501884661921.5,
       "nok": 15503072349257.047,
       "nzd": 2665025453216.091,
       "php": 90511038784528.17,
       "pkr": 313123095025389.6,
       "pln": 7045003376936.03,
       "rub": 135810485938881.98,
       "sar": 6659380924937.161,
       "sek": 16172145755371.791,
       "sgd": 2386525181141.215,
       "thb": 58804158680772.49,
       "try": 24059086367707.945,
       "twd": 49338186582242.45,
       "uah": 50136943361806.18,
       "vef": 177738183134.30957,
       "vnd": 40205431419076344,
       "zar": 27109111221866.484,
       "xdr": 1267541459464.5105,
       "xag": 79373793467.19109,
       "xau": 984402918.414004,
       "bits": 48215631699206.9,
       "sats": 4821563169920690
     },
     "total_volume": {
       "btc": 2399321.086578272,
       "eth": 33714952.5511181,
       "ltc": 818575663.094208,
       "bch": 321754133.5597198,
       "bnb": 241150693.46283516,
       "eos": 38845193889.56307,
       "xrp": 146750183692.48746,
       "xlm": 460205239450.2561,
       "link": 5512879927.841974,
       "dot": 4767724257.211406,
       "yfi": 3848617.019704001,
       "usd": 88331789749.38533,
       "aed": 324442663749.49335,
       "ars": 9302580023896.678,
       "aud": 123743120942.01656,
       "bdt": 7587091956777.252,
       "bhd": 33299229767.933502,
       "bmd": 88331789749.38533,
       "brl": 468034821166.09375,
       "cad": 111957010235.7561,
       "chf": 81267631527.75769,
       "clp": 72273953690844.55,
       "cny": 561878514595.8403,
       "czk": 1879347158707.9243,
       "dkk": 575144182780.4038,
       "eur": 77286694427.33246,
       "gbp": 64945595086.0765,
       "hkd": 688396137053.8865,
       "huf": 27378075189166.246,
       "idr": 1270216308510783,
       "ils": 281721876955.0987,
       "inr": 6599864163425.6045,
       "jpy": 10152178703111.84,
       "krw": 106099200061721.84,
       "kwd": 26713564851.378277,
       "lkr": 17891980925484.883,
       "mmk": 156902455061270.88,
       "mxn": 1818349464632.907,
       "myr": 369801037785.80164,
       "ngn": 36749557807334.28,
       "nok": 771468652041.5916,
       "nzd": 132617815858.13719,
       "php": 4504038135984.733,
       "pkr": 15581727711791.592,
       "pln": 350575623746.8479,
       "rub": 6758243150778.037,
       "sar": 331386160746.3222,
       "sek": 804763288556.4598,
       "sgd": 118758999705.40747,
       "thb": 2926230621252.92,
       "try": 1197235651831.127,
       "twd": 2455182007752.367,
       "uah": 2494929988162.7563,
       "vef": 8844662107.60595,
       "vnd": 2000715037823578.2,
       "zar": 1349011926231.5881,
       "xdr": 63075787760.661514,
       "xag": 3949823110.8039775,
       "xau": 48986160.64131668,
       "bits": 2399321086578.272,
       "sats": 239932108657827.2
     },
     "market_cap_percentage": {
       "btc": 39.29836721461367,
       "eth": 17.62164417524611,
       "usdt": 4.399983696255727,
       "bnb": 3.469607622865714,
       "usdc": 2.8558173967351648,
       "ada": 1.9008389207557028,
       "sol": 1.7271271303579836,
       "xrp": 1.6220696024263102,
       "dot": 1.126941097865356,
       "luna": 1.1051032029872236
     },
     "market_cap_change_percentage_24h_usd": -1.953853919074353,
     "updated_at": 1643913356
   }
 }
 */

struct MarketData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
   

    enum CodingKeys: String, CodingKey {
        case totalMarketCap                  = "total_market_cap"
        case totalVolume                     = "total_volume"
        case marketCapPercentage             = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String{
        if let usdMarketCap = totalMarketCap.first(where: {$0.key == "usd"}){
            return "$" + usdMarketCap.value.formattedWithAbbreviations()
        }
        return ""
    }
    var volume:    String{
        if let usdVolume = totalVolume.first(where: {$0.key == "usd"}){
            return usdVolume.value.formattedWithAbbreviations()
        }
        
        return ""
    }
    var btcDom:    String{
        if let btcDominance = marketCapPercentage.first(where: {$0.key == "btc"}){
            return btcDominance.value.asPercentString()
        }
        return ""
    }
    
}

struct GlobalData: Codable {
    let data: MarketData?
}

