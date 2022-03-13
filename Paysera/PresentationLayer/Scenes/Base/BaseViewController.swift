//
//  BaseViewController.swift
//  Paysera
//
//  Created by tanaz on 21/12/1400 AP.
//

import Foundation
import UIKit
import RxSwift

@objc protocol BaseVCProtocol {
    @objc optional func setupView()
    @objc optional func setupApiBindings()
    @objc optional func setupTapBindings()
    @objc optional func setupViewBindings()

}

class BaseViewController: UIViewController, BaseVCProtocol {


    // MARK: - Properties
    public let disposeBag = DisposeBag()
    public var realmManaging: RealmManaging!



    // MARK: - BaseVCProtocol
    func setupView() {}
    func setupApiBindings() {}
    func setupTapBindings() {}
    func setupViewBindings() {}

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupApiBindings()
        setupTapBindings()
        setupViewBindings()
    }
}
