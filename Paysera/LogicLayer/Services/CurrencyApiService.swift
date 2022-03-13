//
//  CurrencyApiService.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import Alamofire
import RxSwift

protocol CurrencyServicing {

    func convertCurrency(amount: String, sellCurrency: String, buyCurrency: String) -> Observable<CurrencyConverterResponse?>
}
class CurrencyApiService: CurrencyServicing {
    
    func convertCurrency(amount: String, sellCurrency: String, buyCurrency: String) -> Observable<CurrencyConverterResponse?> {
        return CurrencyConverterService(amount: amount,
                                        sellCurrency: sellCurrency,
                                        buyCurrency: buyCurrency).request()
    }

}
