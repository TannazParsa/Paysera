//
//  PayseraAssembly.swift
//  Paysera
//
//  Created by tanaz on 20/12/1400 AP.
//

import Foundation
import Swinject


final class PayseraAssembly: Assembly {

    func assemble(container: Container) {

        // MARK: - ViewModel

        container.register(CurrencyConverterViewModeling.self, factory: { resolver in
            CurrencyConverterViewModel(realmManager: resolver.resolve(RealmManaging.self)!, currencyNetwork: resolver.resolve(CurrencyServicing.self)!
            )
        }).inObjectScope(.weak)


        // MARK: - ViewController

        container.storyboardInitCompleted(CurrencyConverterViewController.self) { resolver, controller in
            controller.realmManaging = resolver.resolve(RealmManaging.self)
            controller.viewModel = resolver.resolve(CurrencyConverterViewModeling.self)!
        }
    }
}
