//
//  BalanceCollectionViewCell.swift
//  Paysera
//
//  Created by tanaz on 20/12/1400 AP.
//

import UIKit

class BalanceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderColor = UIColor.systemGray5.cgColor
        mainView.layer.borderWidth = 0.4
    }

    func config(titleString: String) {
        titleLabel.text = titleString
    }

}
