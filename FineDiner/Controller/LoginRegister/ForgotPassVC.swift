//
//  ForgotPassVC.swift
//  FineDiner
//
//  Created by iOS Developer on 18/12/2021.
//

import UIKit
import Toast_Swift
import KRProgressHUD
import FlagPhoneNumber
import Firebase
class ForgotPassVC: UIViewController {
    
        
    @IBOutlet weak var phoneTxt: FPNTextField!
    
    @IBOutlet weak var continueBtn: UIButton!
    //MARK:- Variables
    private var isValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneSetups()
    }
    private func validateViews() -> Bool {
        let valid = true
        if let phone = phoneTxt.text {
            if phone.count == 0 {
                let style = ToastStyle()
                self.view.makeToast("Phone Required", duration: 4.0, position: .bottom, style: style)
                return false
            }
        }
    
        return valid
    }
    func Verify() {
        KRProgressHUD.show()
        let phone = phoneTxt.getFormattedPhoneNumber(format: .E164) ?? ""
        let parameters = ["phone_number" : phone] as [String : Any]
        print(phone)
        NetworkManager().verifyApi(param: parameters) { message, bool in
            KRProgressHUD.dismiss()
            if bool {
                self.forgotPass()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func forgotPass(){
        self.continueBtn.isEnabled = false
        KRProgressHUD.show()
        let phone = phoneTxt.getFormattedPhoneNumber(format: .E164) ?? ""
        print(phone)
        NetworkManager().forgotPassRequest(phone_number: phone) { error, isSucces, mess in
            KRProgressHUD.dismiss()
            if isSucces{
                Helper.shared.OTP = "forgetPassword"
                guard let otpVc = OTPVC.storyboardInstance() else {return}
                otpVc.phone = phone
                otpVc.modalPresentationStyle = .fullScreen
                self.present(otpVc, animated: true)
            }else{
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
//        self.continueBtn.isEnabled = false
//        let phone = phoneTxt.getFormattedPhoneNumber(format: .E164) ?? ""
//        print("======= phone \(phone)")
//        KRProgressHUD.show()
//        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
//            KRProgressHUD.dismiss()
//            self.continueBtn.isEnabled = true
//            if let error = error {
//                print(error.localizedDescription)
//                let style = ToastStyle()
//                self.view.makeToast(error.localizedDescription, duration: 4.0, position: .bottom, style: style)
//                return
//            }
//            print("======== Enter OTP")
//            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//
//            guard let otpVc = OTPVC.storyboardInstance() else {return}
//            otpVc.forgotPassVc = self
//            otpVc.phone = phone
//            otpVc.modalPresentationStyle = .fullScreen
//            self.present(otpVc, animated: true)
//        }
    }
    func phoneSetups(){
        phoneTxt.delegate = self
        phoneTxt.hasPhoneNumberExample = false
        phoneTxt.setFlag(key: .AE) //AE
    }
    @IBAction func continueTapped(_ sender: Any) {
        if validateViews(){
            forgotPass()
        }

        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    
}
extension ForgotPassVC: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {}
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.isValid = isValid
    }
    func fpnDisplayCountryList() {}
}
