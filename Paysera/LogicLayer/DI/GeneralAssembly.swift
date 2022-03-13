//
//  GeneralAssembly.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import Swinject


final class GeneralAssembly: Assembly {

    func assemble(container: Container) {


        // MARK: - RealmManager

        container.register(RealmManaging.self,  factory: { resolver in
            RealmManager()
        }).inObjectScope(.container)
    }
}
