//
//  AddReviewVC.swift
//  FineDiner
//
//  Created by iOS Developer on 24/12/2021.
//

import UIKit
import Cosmos
import KRProgressHUD
import Toast_Swift

class AddReviewVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var cosmosView: CosmosView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtComment.layer.borderWidth = 0.5
        txtComment.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.3)
        txtComment.textColor = UIColor.lightGray
        txtComment.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtComment.text == "Comment here"{
            txtComment.text = ""
            txtComment.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtComment.text == ""{
            txtComment.text = "Comment here"
            txtComment.textColor = UIColor.lightGray
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        var comment = ""
        if txtComment.text! == "Comment here"{
            comment = "Comment here"
        }else{
            comment = txtComment.text!
        }
        let parameter = ["rate" : cosmosView.rating,
                         "comment" : comment] as [String:Any]
        KRProgressHUD.show()
        NetworkManager().postReview(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.dismiss(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataReview"), object: nil)
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    

}
