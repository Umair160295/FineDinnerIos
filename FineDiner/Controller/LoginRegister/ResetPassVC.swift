//
//  ResetPassVC.swift
//  FineDiner
//
//  Created by iOS Developer on 18/12/2021.
//

import UIKit
import Toast_Swift
import KRProgressHUD
class ResetPassVC: UIViewController {
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassVC") as? ForgotPassVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
        
    }
    @IBAction func resetPassTapped(_ sender: Any) {
        KRProgressHUD.show()
        NetworkManager().resetPassRequest(password: passwordTxt.text!, password_confirmation: confirmPasswordTxt.text!){ (error, isSuccess, mess) in
            KRProgressHUD.dismiss()
            if isSuccess == true{
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
            }else {
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
        
    }
    
}
