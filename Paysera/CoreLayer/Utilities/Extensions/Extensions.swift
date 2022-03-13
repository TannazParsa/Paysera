//
//  Extensions.swift
//  Paysera
//
//  Created by tanaz on 22/12/1400 AP.
//

import Foundation
import UIKit

// MARK: - String

extension String {
   
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }

    var isNumeric : Bool {
        return NumberFormatter().number(from: self) != nil
    }
}

// MARK: - Double

extension Double {
    func round(to places: Int = 2) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
// MARK: - UIViewController

extension UIViewController {

    func showAlert(withTitle: String = "", message: String, actionTitle: String = "OK") {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        present(alert, animated: true)
    }

}
