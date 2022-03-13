//
//  RealmManager.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import RealmSwift

// MARK: - RealmManaging Protocol

protocol RealmManaging {

    func getObjects() ->[AvailableCurrency]

    func addItem(item: AvailableCurrency)

    func updateUserBalance(sellValue: Double,
                           sellCurrency: String,
                           buyValue: Double,
                           buyCurrency: String,
                           comissionFee: Double,
                           success: () -> Void,
                           failure: (String) -> Void)

    func calculateCommissions(amount: Double) -> Double
    func checkExchangePosibilityWithCommissions(qty: String, fromCurrency: String, toCurrency: String) throws -> Error
    func decreaseCurrencyInDatabase(currency: String, minus: Double)


}

class RealmManager: RealmManaging {

    static let shared = RealmManager()

    func addItem(item: AvailableCurrency) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(item)
        }
    }

    func getObjects() -> [AvailableCurrency] {
        let realm = try! Realm()
        let realmResults = realm.objects(AvailableCurrency.self)
        return Array(realmResults)

    }

    /// Update user balance and currency data in database is updates.
    ///
    /// - Parameters:
    ///   - sellCurrency: from what currency exchange
    ///   - sellValue: from what amount currency exchange
    ///   - buyCurrency: to what currency exhange
    ///   - buyValue: to what amount currency exchange

    func updateUserBalance(sellValue: Double, sellCurrency: String, buyValue: Double, buyCurrency: String, comissionFee: Double, success: () -> Void, failure: (String) -> Void) {
        /// Add comission fee to current sell value
        let totalSellValue = sellValue + comissionFee

        let realm = try! Realm()
        let availableSellCurrency = realm.objects(AvailableCurrency.self).filter("currencyName = %@", sellCurrency).first
        guard availableSellCurrency?.currencyAmount ?? 0.0 >= totalSellValue else {
            failure("insufficient Balance")
            return
        }
        try! realm.write {
            availableSellCurrency?.currencyAmount -= sellValue
        }
        let availableBuyCurrency = realm.objects(AvailableCurrency.self).filter("currencyName = %@", buyCurrency).first
        try! realm.write {

            availableBuyCurrency?.currencyAmount += buyValue
        }

        AppPrefences.shared.setLeftFreeTimes(times: AppPrefences.shared.getLeftFreeTimes() - 1)
        success()

    }

    /// Check exchange posibility if we calculate and commsions.
    ///
    /// - Parameters:
    ///   - qty: how much exchange
    ///   - fromCurrency: from what currency
    ///   - toCurrency: to what currency
    /// - Throws: why is it inpossible
    func checkExchangePosibilityWithCommissions(qty: String, fromCurrency: String, toCurrency: String) throws -> Error {
        let quantity = Double(qty.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil))!
        if fromCurrency == toCurrency {
            throw ExchangeError.sameCurrency
        }
        let commissions = calculateCommissions(amount: quantity)
        let amount = quantity + commissions
        let realm = try! Realm()
        let available = realm.objects(AvailableCurrency.self).filter("currencyName = %@", fromCurrency).first!
        if available.currencyAmount < amount {
            throw ExchangeError.notEnough
        }
        throw ExchangeError.noError
    }

    /// Claculate 0.7% exchange commsions.
    ///
    /// - Parameter amount: what amount we exchange
    /// - Returns: commissions amount
    internal func calculateCommissions(amount: Double) -> Double {
        let percentage = 0.007
        let commissions = amount *  percentage
        return commissions
    }

    /// Decrease currency in database
    ///
    /// - Parameters:
    ///   - currency: what currency you want decrease
    ///   - minus: how much decrease?
    internal func decreaseCurrencyInDatabase(currency: String, minus: Double) {
        let realm = try! Realm()
        let curencyForIncrease = realm.objects(AvailableCurrency.self).filter("currencyName = %@", currency).first!
        try! realm.write {
            curencyForIncrease.currencyAmount -= minus
        }
    }
}

