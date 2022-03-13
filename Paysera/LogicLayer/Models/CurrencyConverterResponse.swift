//
//  CurrencyConverterResponse.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
struct CurrencyConverterResponse: Decodable {

    let amount: String
    let currency: String

    enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
}
