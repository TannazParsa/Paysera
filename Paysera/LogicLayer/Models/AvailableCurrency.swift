//
//  AvailableCurrency.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import RealmSwift

///Realm database object to save availabe currency info
class AvailableCurrency: Object {
  @objc dynamic var currencyName = ""
  @objc dynamic var currencyAmount = 0.00

  override static func primaryKey() -> String? {
    return "currencyName"
  }

    convenience required init(currencyName: String, amount: Double) {
            self.init()
            self.currencyName = currencyName
            self.currencyAmount = amount
        }
}

class CurrencyCart: Object {

    var items = List<AvailableCurrency>()

    func addItem(item: AvailableCurrency) {
        let realm = try! Realm()
        let newItem = AvailableCurrency(currencyName: item.currencyName, amount: item.currencyAmount)
        do {
            try realm.write {
                items.append(newItem)
            }
        } catch _ {
          //  handleError(e)
        }
    }
}
