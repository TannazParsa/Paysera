//
//  CurrencyConverterViewController.swift
//  Paysera
//
//  Created by tanaz on 20/12/1400 AP.
//

import UIKit
import RxSwift
class CurrencyConverterViewController: BaseViewController {

    @IBOutlet weak var sellMenuButton: UIButton!
    @IBOutlet weak var receiveMenuButton: UIButton!
    @IBOutlet weak var sellTextField: UITextField!
    @IBOutlet weak var recieveLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    // MARK: - Properties
    var currencyMenu = UIMenu()
    var menuItems = [UIAction]()
    var viewModel: CurrencyConverterViewModeling!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.supportedCurrency.accept(RealmManager.shared.getObjects())
        customizeNavigationBar()

    }

    override func setupView() {
        setupSellMenuView()
        registerCollectionNib()
        setupButtons()
    }

    func setupButtons() {
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        sellMenuButton.setTitle(viewModel.sellCurrency.value, for: .normal)
        sellMenuButton.menu = currencyMenu
        sellMenuButton.showsMenuAsPrimaryAction = true
        /// buy button
        setupBuyMenuView()
        receiveMenuButton.setTitle(viewModel.buyCurrency.value, for: .normal)
        receiveMenuButton.menu = currencyMenu
        receiveMenuButton.showsMenuAsPrimaryAction = true
    }

    func setupSellMenuView() {
        menuItems = []
        for item in SupportedCurrency.currency {
            let action = UIAction(title: item, image: nil, handler: { (_) in
                self.sellMenuButton.setTitle(item, for: .normal)
                self.viewModel.sellCurrency.accept(item)

            })
            menuItems.append(action)
        }
        currencyMenu = UIMenu(title: "Currency", options: .displayInline, children: menuItems)
    }

    func setupBuyMenuView() {
        menuItems = []
        for item in SupportedCurrency.currency {
            let action = UIAction(title: item, image: nil, handler: { (_) in
                self.receiveMenuButton.setTitle(item, for: .normal)
                self.viewModel.buyCurrency.accept(item)
            })
            menuItems.append(action)
        }
        currencyMenu = UIMenu(title: "Currency", options: .displayInline, children: menuItems)
    }

    // MARK: Navigation Bar Customisation

    func customizeNavigationBar() {

        if #available(iOS 15, *) {
            // Navigation Bar background color
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 18/255, green: 157/255, blue: 228/255, alpha: 1)

            // setup title font color
            let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = titleAttribute

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }

    override func setupViewBindings() {
        setupTextField()
    }

    private func setupTextField() {
        sellTextField.rx.text.orEmpty.bind(to: viewModel.amount).disposed(by: disposeBag)
    }

    private func registerCollectionNib() {
        collectionView.register(UINib(nibName: "BalanceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BalanceCollectionViewCell")
    }


    override func setupTapBindings() {
        sellTextField.rx.controlEvent([.editingChanged])
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.viewModel.onAmountTextFieldEditingChanged()
            }.disposed(by: disposeBag)
        submitButton.rx.tap.asObservable().bind { [weak self] in
            //  self?.dismissKeyboard()
            self?.viewModel.onTapSubmit()
        }.disposed(by: self.disposeBag)
    }

    override func setupApiBindings() {
        viewModel.apiConvertSuccess
            .subscribe(onNext: { [weak self] apiResult in
                self?.recieveLabel.text =  "+" + apiResult.amount
                if self?.viewModel.shouldUpdateBalance.value ?? false {
                    let isPossible = try? RealmManager.shared.checkExchangePosibilityWithCommissions(qty: apiResult.amount, fromCurrency: (self?.viewModel.sellCurrency.value)! , toCurrency: apiResult.currency)

                    let comissionFee = self?.viewModel.calcuteComissionFee(sellValue: self?.viewModel.amount.value.doubleValue ?? 0.0)
                    RealmManager.shared.updateUserBalance(sellValue: ((self?.viewModel.amount.value.doubleValue)!), sellCurrency: self?.viewModel.sellCurrency.value ?? "", buyValue: apiResult.amount.doubleValue, buyCurrency: apiResult.currency, comissionFee: comissionFee ?? 0.0) {
                        /// Show success alert
                        if let sellAmount = self?.viewModel.amount.value,
                           let sellCurrency = self?.viewModel.sellCurrency.value,
                           let comission = comissionFee {
                        self?.showAlert(withTitle: "Currency Converted",
                                        message: "You have converted \(sellAmount) \(sellCurrency) to \(apiResult.amount) \(apiResult.currency). Comission Fee: \(comission)",
                                        actionTitle: "Done")
                        }
                        /// Update user balance display
                        self?.collectionView.reloadData()
                    } failure: { error in
                        /// Show error alert
                        self?.showAlert(message: error)
                    }


                }
            }).disposed(by: disposeBag)
    }
}

extension CurrencyConverterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.supportedCurrency.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BalanceCollectionViewCell", for: indexPath) as! BalanceCollectionViewCell
        let titleText = "\(viewModel.supportedCurrency.value[indexPath.row].currencyAmount)" + " " + viewModel.supportedCurrency.value[indexPath.row].currencyName
        cell.config(titleString: titleText)
        return cell
    }
}
