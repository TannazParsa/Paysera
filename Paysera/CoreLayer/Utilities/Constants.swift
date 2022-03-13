//
//  Constants.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
struct Constants {
    static let comissionFee = 0.007
    static let requestTime = 5.0

    // MARK: - General

    static let EMPTY_STRING = ""

    // MARK: - Storyboards Ids

    static let MAIN_STORYBOARD_ID = "Main"

    // MARK: - VC Ids

    static let CURRENCY_VC_ID = "CurrencyConverterViewController"
}
// MARK: - Error

extension Constants {
    struct Error {
        static let invalidUrl = "Invalid Url"
        static let invalidData = "Invalid Data"
        static let invalidResponse = "Invalid Response"
    }
}
/// Currency exhange erros
///
/// - sameCurrency: exchange with same currency is inposible
/// - notEnough: not enough currency in database for make exchange.
public enum ExchangeError: Error {
  case sameCurrency
  case notEnough
  case noError
}

