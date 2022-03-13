//
//  Router.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import UIKit
import Swinject
import SwinjectStoryboard

class Router {

    static let shared = Router()
    private init() {}

    var window: UIWindow?
    var container: Container?

    func configIntialVC() {
        if let container = container, let window = window {
            window.makeKeyAndVisible()
            let storyboard = SwinjectStoryboard.create(name: Constants.MAIN_STORYBOARD_ID, bundle: nil, container: container)
            let _ = storyboard.instantiateViewController(withIdentifier: Constants.CURRENCY_VC_ID) as! CurrencyConverterViewController
            window.rootViewController = storyboard.instantiateInitialViewController()
        }
    }
}
