//
//  CategoryVCCollectionViewCell.swift
//  FineDiner
//
//  Created by iOS Developer on 19/12/2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    func setData(data: MenuShowCategoryM){
        self.categoryLbl.text = data.name as? String ?? ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryView.layer.borderWidth = 0.5
        categoryView.layer.borderColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1) //#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)

    }
}
