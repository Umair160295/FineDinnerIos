//
//  OTPVC.swift
//  FineDiner
//
//  Created by iOS Developer on 18/12/2021.
//

import UIKit
import SVPinView
import Toast_Swift
import Firebase
import KRProgressHUD
import Adjust

class OTPVC: UIViewController {
    
    @IBOutlet weak var txtHavePhone: UILabel!
    @IBOutlet weak var pinCode: SVPinView!{
        didSet{
            pinCode.pinLength = 6
            pinCode.interSpace = 6
            pinCode.font = UIFont.systemFont(ofSize: 20.0)
        }
    }
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var BtnResendCode: UIButton!
    
    
    var loginVC:LoginVC?
    var RegisterVC:RegisterVC?
    var forgotPassVc:ForgotPassVC?
    var AddPhoneNumberPopup:AddPhoneNumberPopup?
    var name = ""
    var email = ""
    var token = ""
    var phone = ""
    var password = ""
    var confirmPassword = ""
    var count = 60
    private var localTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtHavePhone.text = "We have sent a verification code to \(phone)"
        TimerResend()
//        loginRequest()
//        pinCode.style = .box
//        pinCode.didChangeCallback = { pin in
//            self.submitBtn.isEnabled = true
//        }
    }
    func TimerResend() {
        count = 60
        localTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.count == 0{
                self.BtnResendCode.isEnabled = true
                self.BtnResendCode.setTitleColor( #colorLiteral(red: 0.231372549, green: 0.7254901961, blue: 1, alpha: 1), for: .normal)
                self.lblTimer.text = "60"
            }else{
                self.count -= 1
                self.BtnResendCode.isEnabled = false
                self.lblTimer.text = "\(self.count)"
                self.BtnResendCode.setTitleColor(.lightGray, for: .normal)
                print(self.count)
            }
        }
    }
    static func storyboardInstance() -> OTPVC? {
        let storyboard = UIStoryboard(name: "LoginRegister", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC
    }
    func validateViewsOTP()-> Bool {
        let valid = true
        let code = pinCode.getPin()
        if code.count < 6  {
            let style = ToastStyle()
            self.view.makeToast("Please enter your OTP", duration: 4.0, position: .bottom, style: style)
            return false
        }
        return valid
    }
    func getOTP(){
        if validateViewsOTP(){
            print(pinCode.getPin())
            let parameters = [
                "token" : Helper.shared.verifyToken,
                "code" : self.pinCode.getPin()] as [String : Any]
            print(parameters)
            NetworkManager().checkCodeApi(param: parameters) { message, bool in
                KRProgressHUD.dismiss()
                if bool {
                    if Helper.shared.OTP == "forgetPassword"{
                        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassVC") as? ResetPassVC else {return}
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: true)
                    }else if Helper.shared.OTP == "AddPhone"{
                        self.OTPUpdatePhone()
                    }else{
                        self.register()
                    }
                }else{
                    let style = ToastStyle()
                    self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                }
            }
        }
    }
    func OTPUpdatePhone(){
        if validateViewsOTP(){
            let parameters = [
                "token" : Helper.shared.verifyToken] as [String : Any]
            print(parameters)
            NetworkManager().updatePhoneApi(param: parameters) { message, bool in
                KRProgressHUD.dismiss()
                if bool {
                        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {return}
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: true)
                }else{
                    let style = ToastStyle()
                    self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
                }
            }
        }
    }
    func register() {
        KRProgressHUD.show()
        NetworkManager().registerRequest(name: name, email: email, password: password, password_confirmation: confirmPassword){ (error, isSuccess, mess) in
            KRProgressHUD.dismiss()
            if isSuccess == true{
                Helper.shared.saveIsLogin(IsLogin: true)
                Helper.shared.addressEnter = "FirstAddress"
                HomeVC().Analytics(title: "Otp_IOS")
                let event = ADJEvent(eventToken: "jh8gk5")
                Adjust.trackEvent(event)
                let storyboard = UIStoryboard(name: "Address", bundle: nil)
                if let nextVC = storyboard.instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC {
                    nextVC.modalPresentationStyle = .fullScreen
                    self.present(nextVC, animated: true)
                }
            }else{
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func resendCode() {
        KRProgressHUD.show()
        NetworkManager().resetCodeRequest { error, bool, message in
            KRProgressHUD.dismiss()
            if bool{
                let style = ToastStyle()
                self.view.makeToast("Code is resend", duration: 4.0, position: .bottom, style: style)
                self.TimerResend()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    @IBAction func resendTapped(_ sender: Any) {
        resendCode()
    }
    @IBAction func backTapped(_ sender: Any) {
        if Helper.shared.OTP == "AddPhone"{
            self.dismiss(animated: true)
        }else{
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }
    }
    @IBAction func submitVC(_ sender: Any) {
        getOTP()
    }
}
