//
//  ServiceAssembly.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import Swinject


final class ServiceAssembly: Assembly {

    func assemble(container: Container) {

        // MARK: - Service

        container.register(CurrencyServicing.self, factory: { resolver in
            CurrencyApiService()
        }).inObjectScope(.transient)
    }
}
