//
//  CurrencyConverterViewModel.swift
//  Paysera
//
//  Created by tanaz on 20/12/1400 AP.
//

import Foundation
import RxSwift
import RxCocoa

protocol CurrencyConverterViewModeling {
    var sellCurrency: BehaviorRelay<String> { get }
    var buyCurrency: BehaviorRelay<String> { get }
    var amount: BehaviorRelay<String> { get }
    var supportedCurrency: BehaviorRelay<[AvailableCurrency]> { get }
    var apiConvertSuccess: PublishSubject<CurrencyConverterResponse> { get }
    var shouldUpdateBalance: BehaviorRelay<Bool> { get }


    func onTapSubmit()
    func onAmountTextFieldEditingChanged()
    func calcuteComissionFee(sellValue: Double) -> Double?
}
class CurrencyConverterViewModel:BaseViewModel, CurrencyConverterViewModeling {

    var shouldUpdateBalance = BehaviorRelay<Bool>(value: false)
    var supportedCurrency = BehaviorRelay<[AvailableCurrency]>(value: [])
    var apiConvertSuccess = PublishSubject<CurrencyConverterResponse>()
    var sellCurrency = BehaviorRelay<String>(value: SupportedCurrency.EUR)
    var buyCurrency = BehaviorRelay<String>(value: SupportedCurrency.USD)
    var amount = BehaviorRelay<String>(value: "100")


    // MARK: - Properties

    var realmManager: RealmManaging?
    var currencyNetwork: CurrencyServicing

    init(realmManager: RealmManaging, currencyNetwork: CurrencyServicing) {
        self.realmManager = realmManager
        self.currencyNetwork = currencyNetwork
    }

    // MARK: - Functions

    func onTapSubmit() {
        convertCurrency(shouldUpdateBalance: true)
    }
    func onAmountTextFieldEditingChanged() {
        convertCurrency()
    }

    // MARK: - APIs

    private func convertCurrency(shouldUpdateBalance: Bool = false) {
        currencyNetwork.convertCurrency(amount: amount.value, sellCurrency: sellCurrency.value, buyCurrency: buyCurrency.value)
            .subscribe(onNext: { [weak self] apiResult in
                self?.apiConvertSuccess.onNext(apiResult!)

            }, onError: { [weak self] error in

            }).disposed(by: self.disposeBag)
    }

    // MARK: - Calcute Comission Fee

    func calcuteComissionFee(sellValue: Double) -> Double? {

            let transactionCount = AppPrefences.shared.getLeftFreeTimes() >= 5
        if transactionCount {
            return sellValue * Constants.comissionFee
        } else {
            return 0.0
        }
    }

}
