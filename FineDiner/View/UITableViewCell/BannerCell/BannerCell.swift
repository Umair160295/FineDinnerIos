//
//  BannerCell.swift
//  FineDiner
//
//  Created by QTechnetworks on 13/02/2022.
//

import UIKit
import ImageSlideshow
import ImagePicker


class BannerCell: UITableViewCell {
    var bannersArray = [BannerM]()
    var impArray = [SDWebImageSource]()
    var Vc: GroupDetailsVC?

    @IBOutlet weak var sliderView: ImageSlideshow!
    {
        didSet{
        sliderView.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        sliderView.addGestureRecognizer(gestureRecognizer)
        sliderView.contentMode = .scaleToFill
        sliderView.contentScaleMode = .scaleToFill
        sliderView.clipsToBounds = true
        sliderView.slideshowInterval = 4
//        sliderView.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customBottom(padding: 32))
    }
}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bannersArray = Helper.shared.bannerArray as! [BannerM]
        for image in bannersArray {
            impArray.append(SDWebImageSource(urlString:  "\(image.image as! String)", placeholder: UIImage(named: "Image"))!)
        }
        sliderView.setImageInputs(impArray)
    }

    @objc func didTap(_ sender: UIButton) {
        guard let Vc = self.Vc else {return}
        sliderView.presentFullScreenController(from: Vc)
    }
    
}
