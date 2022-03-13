//
//  CurrencyConverterService.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import Alamofire
import RxSwift

class CurrencyConverterService: WebService<CurrencyConverterResponse> {
    let amount: String
    let sellCurrency: String
    let buyCurrency: String

    init(amount: String, sellCurrency: String, buyCurrency: String) {
        self.amount = amount
        self.sellCurrency = sellCurrency
        self.buyCurrency = buyCurrency
    }

    override var endpoint: String {
        
        return "currency/commercial/exchange/\(amount)-\(sellCurrency)/\(buyCurrency)/latest"
    }
}
