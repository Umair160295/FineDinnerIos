//
//  ChangePassVC.swift
//  FineDiner
//
//  Created by iOS Developer on 22/12/2021.
//

import UIKit
import KRProgressHUD
import Toast_Swift

class ChangePassVC: UIViewController {
    
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updatePassword(){
        let parameter = ["password" : txtNewPassword.text!,
                         "password_confirmation" : txtConfirmPassword.text!,
                         "current_password" : txtCurrentPassword.text!]
        KRProgressHUD.show()
        NetworkManager().updatePasswordApi(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool{
                Helper.shared.resetDefaults()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
                let rootVC = UIStoryboard(name: "LoginRegister", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                self.navigationController?.pushViewController(rootVC, animated: true)
                
//                self.navigationController?.popViewController(animated: true)
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else {return}
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if txtCurrentPassword.text! == "" || txtNewPassword.text! == "" || txtConfirmPassword.text! == ""{
            let style = ToastStyle()
            self.view.makeToast("Please, fill all field", duration: 4.0, position: .bottom, style: style)
        }else{
            if !(txtNewPassword.text?.elementsEqual((txtConfirmPassword.text)!))! {
                let style = ToastStyle()
                self.view.makeToast("The password and confirm password does not match", duration: 4.0, position: .bottom, style: style)
            }else{
                updatePassword()
            }
        }
    }
    

}
