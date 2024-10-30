//
//  AddPhoneNumberPopup.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 16/05/2022.
//

import UIKit
import FlagPhoneNumber
import Toast_Swift
import KRProgressHUD

class AddPhoneNumberPopup: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneTxt: FPNTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneSetups()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(popupDismiss))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @objc func popupDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func phoneSetups(){
        phoneTxt.delegate = self
        phoneTxt.hasPhoneNumberExample = false
        phoneTxt.setFlag(key: .AE) //AE
    }
    
    static func storyboardInstance() -> AddPhoneNumberPopup? {
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AddPhoneNumberPopup") as? AddPhoneNumberPopup
    }
    
    private func validateViews() -> Bool {
        let valid = true
        if let phone = phoneTxt.text {
            if phone.count == 0 {
                let style = ToastStyle()
                self.view.makeToast("User Name Required", duration: 4.0, position: .bottom, style: style)
                return false
            }
        }
        return valid
    }
    
    @IBAction func btnAddPhone(_ sender: Any) {
        if Helper.shared.getUserPhone() == ""{
            if validateViews(){
                Verify()
            }
        }
    }
    
    func Verify() {
        Helper.shared.OTP = "AddPhone"
        let aString = phoneTxt.text!
        let newString = aString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let phone = "\(phoneTxt.selectedCountry?.phoneCode ?? "")"+"\(newString)"
        KRProgressHUD.show()
        let parameters = ["phone_number" : phone] as [String : Any]
        NetworkManager().verifyApi(param: parameters) { message, bool in
            KRProgressHUD.dismiss()
            if bool {
                guard let otpVc = OTPVC.storyboardInstance() else {return}
                otpVc.AddPhoneNumberPopup = self
                otpVc.phone = phone
                otpVc.modalPresentationStyle = .fullScreen
                self.present(otpVc, animated: true)
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    

}
