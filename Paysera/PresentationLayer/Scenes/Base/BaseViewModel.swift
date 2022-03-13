//
//  BaseViewModel.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import RxSwift


@objc protocol BaseVMProtocol {
    @objc optional func setupBindings()
}


class BaseViewModel: BaseVMProtocol {

    public let disposeBag = DisposeBag()

    // MARK: - Init & Deinit

    init() {
        setupBindings()
    }

    deinit {
       // Logger.info(message: "Deallocated VM >>> \(self)")
    }

    // MARK: - Functions

    func setupBindings() {}

}
