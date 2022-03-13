//
//  AppDelegate.swift
//  Paysera
//
//  Created by tanaz on 20/12/1400 AP.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    internal let container = Container()
    var assembler: Assembler!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13, *) {
            // do only pure app launch stuff, not interface stuff
        } else {
        assembler = Assembler([
            GeneralAssembly(),
            ServiceAssembly(),
            PayseraAssembly()
        ], container: container)
            /// setup router
            Router.shared.container = container
            Router.shared.window = window
            Router.shared.configIntialVC()
        }
        //check or this is first app launch
        let isLaunched = AppPrefences.shared.getOrAppLaunchedBefore();
        if !isLaunched {
          initFirstLaunch()
        }
        return true
    }

    /// init application data in first launched, add currency values to database and set
    /// free exchanges posibilitys times and save to UsersDefaults.
    private func initFirstLaunch() {
        AppPrefences.shared.setAppLaunched()
        AppPrefences.shared.setLeftFreeTimes(times: 5)
        RealmManager.shared.addItem(item: AvailableCurrency(currencyName: SupportedCurrency.EUR, amount: 800.0))
        RealmManager.shared.addItem(item: AvailableCurrency(currencyName: SupportedCurrency.USD, amount: 0.0))
        RealmManager.shared.addItem(item: AvailableCurrency(currencyName: SupportedCurrency.JPY, amount: 0.0))
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

