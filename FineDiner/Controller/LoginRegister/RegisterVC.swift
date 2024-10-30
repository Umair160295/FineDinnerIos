//
//  RegisterVC.swift
//  FineDiner
//
//  Created by iOS Developer on 18/12/2021.
//

import UIKit
import Toast_Swift
import KRProgressHUD
import Firebase
import FlagPhoneNumber
import Adjust

class RegisterVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var nameTxt: UITextField!    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneTxt: FPNTextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var BtnCheckTerms: UIButton!
    
    //MARK:- Variables
    private var isValid = false
    var CheckTerms = 0
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeVC().Analytics(title: "Initiate_Sign_Up_App")
        let event = ADJEvent(eventToken: "8j2dh9")
        Adjust.trackEvent(event)
        phoneTxt.delegate = self
        phoneTxt.hasPhoneNumberExample = false
        phoneTxt.setFlag(key: .AE) //AE
        BtnCheckTerms.layer.borderColor = UIColor(red:218/255, green:165/255, blue:32/255, alpha: 1).cgColor
    }
    //MARK:- Functions
    private func validateViews() -> Bool {
        let valid = true
        if let name = nameTxt.text {
            if name.count == 0 {
//                let style = ToastStyle()
//                self.view.makeToast("User Name Required", duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: "User Name Required")
                self.nameTxt.layer.borderColor = UIColor.red.cgColor
                self.nameTxt.layer.borderWidth = 1
                return false
            }else{
                self.nameTxt.layer.borderColor = nil
                self.nameTxt.layer.borderWidth = 0
            }
        }
        if let email = emailTxt.text {
            if email.count == 0 {
//                let style = ToastStyle()
//                self.view.makeToast("Email Required", duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: "Email Required")
                self.emailTxt.layer.borderColor = UIColor.red.cgColor
                self.emailTxt.layer.borderWidth = 1
                return false
            }else{
                self.emailTxt.layer.borderColor = nil
                self.emailTxt.layer.borderWidth = 0
            }
            
        }
        if let phone = phoneTxt.text {
            if phone.count == 0 {
//                let style = ToastStyle()
//                self.view.makeToast("Phone Required", duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: "Phone Required")
                self.phoneTxt.layer.borderColor = UIColor.red.cgColor
                self.phoneTxt.layer.borderWidth = 1
                return false
            }else{
                self.phoneTxt.layer.borderColor = nil
                self.phoneTxt.layer.borderWidth = 0
            }
            
        }
        if let password = passwordTxt.text {
            if password.count == 0 {
//                let style = ToastStyle()
//                self.view.makeToast("Password Required", duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: "Password Required")
                self.passwordTxt.layer.borderColor = UIColor.red.cgColor
                self.passwordTxt.layer.borderWidth = 1
                return false
            }else{
                self.passwordTxt.layer.borderColor = nil
                self.passwordTxt.layer.borderWidth = 0
            }
        }
        if let confermpassword = confirmPasswordTxt.text{
            if confermpassword.count == 0 {
                self.Alert(Message: "Confirm Password Required")
                self.confirmPasswordTxt.layer.borderColor = UIColor.red.cgColor
                self.confirmPasswordTxt.layer.borderWidth = 1
                return false
            }else{
                self.confirmPasswordTxt.layer.borderColor = nil
                self.confirmPasswordTxt.layer.borderWidth = 0
            }
        }
        if !(passwordTxt.text?.elementsEqual((confirmPasswordTxt.text)!))! {
//        let style = ToastStyle()
//        self.view.makeToast("The password and confirm password does not match", duration: 4.0, position: .bottom, style: style)
            self.Alert(Message: "The password and confirm password does not match")
        return false
        }
    
        return valid
    }
  
    @IBAction func registerTapped(_ sender: Any) {
        if validateViews(){
            if CheckTerms == 0{
                let alert = UIAlertController(title: "Oops!", message: "Please read and agree to the privacy policy and terms & conditions in order to sign in.",         preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                Verify()
            }
        }
    }
    func Verify() {
        KRProgressHUD.show()
        let phone = phoneTxt.getFormattedPhoneNumber(format: .E164) ?? ""
        let parameters = ["phone_number" : phone] as [String : Any]
        NetworkManager().verifyApi(param: parameters) { message, bool in
            KRProgressHUD.dismiss()
            if bool {
                guard let otpVc = OTPVC.storyboardInstance() else {return}
                otpVc.RegisterVC = self
                otpVc.name = self.nameTxt.text!
                otpVc.email = self.emailTxt.text!
                otpVc.phone = phone
                otpVc.password = self.passwordTxt.text!
                otpVc.confirmPassword = self.confirmPasswordTxt.text!
                otpVc.modalPresentationStyle = .fullScreen
                self.present(otpVc, animated: true)
            }else{
//                let style = ToastStyle()
//                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: message )
            }
        }
    }

    
    @IBAction func backTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
    @IBAction func BtnCheckTermsAction(_ sender: Any) {
        if CheckTerms == 0{
            CheckTerms = 1
            BtnCheckTerms.setImage(UIImage(named: "CheckboxIcon"), for: .normal)
        }else{
            CheckTerms = 0
            BtnCheckTerms.setImage(nil, for: .normal)
        }
    }
    
    @IBAction func BtnPrivacyAction(_ sender: Any) {
        if let url = URL(string: "https://finediner.co/privacy-policy-2/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func BtnTerms(_ sender: Any) {
        if let url = URL(string: "https://finediner.co/terms-and-conditions/") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func Alert(Message: String) {
        let alertController = UIAlertController(title: "Whoops", message: Message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension RegisterVC: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {}
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.isValid = isValid
    }
    func fpnDisplayCountryList() {}
}
