//
//  ViewController.swift
//  FineDiner
//
//  Created by iOS Developer on 12/12/2021.
//

import UIKit
import Toast_Swift
import KRProgressHUD
import FlagPhoneNumber
import FBSDKLoginKit
import Firebase
import AuthenticationServices
import OneSignal
import GoogleSignIn
import IQKeyboardManager
class LoginVC: UIViewController,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var faceview: UIView!
//    @IBOutlet weak var FaceBookView: UIView!
    
    @IBOutlet weak var AppleBtn: UIButton!
    @IBOutlet weak var FaceBTn: UIButton!
    @IBOutlet weak var phoneTxt: FPNTextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var BtnCheckTerms: UIButton!
    
    //MARK:- Variables
    private var isValid = false
    var provider_name = ""
    var provider_email = ""
    var provider_id = ""
    var provider = ""
    var CheckTerms = 0
    var provider_token = ""

    override func viewDidLoad() {
        super.viewDidLoad()
      

        self.loginStack.isHidden = false
        phoneSetups()

        BtnCheckTerms.layer.borderColor = UIColor(red:218/255, green:165/255, blue:32/255, alpha: 1).cgColor
        // 1
           updateButton(isLoggedIn: (AccessToken.current != nil))
           
           // 2
           updateMessage(with: Profile.current?.name)

          
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: "logout"), object: nil)
              
    }

   
    @objc func logout() {
        let loginManager = LoginManager()
           
           if let _ = AccessToken.current {
               // Access token available -- user already logged in
               // Perform log out
               
               // 2
               loginManager.logOut()
               updateButton(isLoggedIn: false)
               updateMessage(with: nil)
               
           }
       }
    
//    func setupProviderLoginView() {
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        authorizationButton.layer.cornerRadius = 10
////        let viewFacebook = UIView()
//        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
////        self.loginStack.addArrangedSubview(authorizationButton)
////        self.loginStack.addArrangedSubview(viewFacebook)
//    }
//    @objc func handleAuthorizationAppleIDButtonPress() {
//         provider = "apple"
//         let appleIDProvider = ASAuthorizationAppleIDProvider()
//         let request = appleIDProvider.createRequest()
//         request.requestedScopes = [.fullName, .email]
//
//         let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//         authorizationController.delegate = self
//         authorizationController.presentationContextProvider = self
//         authorizationController.performRequests()
//     }

    func phoneSetups(){
        phoneTxt.delegate = self
        phoneTxt.hasPhoneNumberExample = false
        phoneTxt.setFlag(key: .AE) //JO
    }

    @IBAction func ApplesignBTn(_ sender: Any) {
//        if CheckTerms == 0{
//            let alert = UIAlertController(title: "Oops!", message: "Please read and agree to the privacy policy and terms & conditions in order to sign in.",         preferredStyle: UIAlertController.Style.alert)
//
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
//                //Cancel Action
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }else{
        provider = "apple"
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()


//        }
    }
    
//    func setupProviderLoginView() {
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
////        self.loginProviderStackView.addArrangedSubview(authorizationButton)
//    }
//    @objc
//    func handleAuthorizationAppleIDButtonPress() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            self.provider = "apple"
            let token = appleIDCredential.identityToken

            if let firstname = appleIDCredential.fullName?.givenName,let secoundname = appleIDCredential.fullName?.familyName {
                 //User has granted permission to access their name
                let fullname = "\(firstname) \(secoundname)"
                print(fullname)
                self.provider_name = fullname
            }else{
                print("no name")
                self.provider_name = "user name"
                 //User has not granted permission to access their name
            }
            if let email = appleIDCredential.email {
                 //User has granted permission to access their email
                print(email)
                self.provider_email = email ?? ""
            }else{
                print("no email")
                self.provider_email = "usernameapple@example.com"
                 //User has not granted permission to access their email
            }
            let userIdentifier = appleIDCredential.user
            let userIdentifierString = userIdentifier.description
            self.provider_id = userIdentifierString
            self.provider_token = token!.base64EncodedString()
            
            print(provider)
            print(provider_name)
            print(provider_email)
            print(provider_id)
            print(provider_token)
            
            
            self.loginSocialMedia()
            break
            default:
                  break
  
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.Alert(Message: "User canceld login")
    }
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        print(appleIDProvider)
//        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                break // The Apple ID credential is valid.
//            case .revoked, .notFound:
//                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                DispatchQueue.main.async {
//                    self.window?.rootViewController?.showLoginViewController()
//                }
//            default:
//                break
//            }
//        }
        return true
    }
    
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//          let name = appleIDCredential.fullName
//          let email = appleIDCredential.email
//          let token = appleIDCredential.identityToken
//            let userIdentifier = appleIDCredential.user
//            self.provider_name = "\(name?.givenName ?? "")\(name?.familyName ?? "")"
//            self.provider_email = email as? String ?? ""
//            self.provider_token = token as? String ?? ""
//            self.provider_id = userIdentifier
//            print(name)
//            print(email)
//            print(token)
//            print(userIdentifier)
//            print(provider_name)
//            print(provider_email)
//            print(provider_token)
//            print(provider_id)
//            self.provider = "apple"
//            self.loginSocialMedia()
//
//        }
//      }
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//            let token = appleIDCredential.identityToken
//
//            print(userIdentifier)
//            print(fullName)
//            print(email)
//            print(token)
//
//            self.provider_token = token as? String ?? ""
//            print( self.provider_token )
//
//            self.provider_name = fullName as? String ?? ""
//            print( self.provider_name )
//
//            self.provider_id = userIdentifier
//            print(self.provider_id)
//
//            provider_email = email as? String ?? ""
//
//            provider = "apple"
//
//            self.loginSocialMedia()
//
//            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
////            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
//        case let passwordCredential as ASPasswordCredential:
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
////                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//        default:
//            break
//        }
//    }
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        self.Alert(Message: "User canceled login")
//    }
//    func performExistingAccountSetupFlows() {
//        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                break // The Apple ID credential is valid.
//            case .revoked, .notFound:
//                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                DispatchQueue.main.async {
//                    self.window?.rootViewController?.showLoginViewController()
//                }
//            default:
//                break
//            }
//        }
//        return true
//    }
    
    private func validateViews() -> Bool {
        let valid = true
        if let phone = phoneTxt.text {
            if phone.count == 0 {
//                let style = ToastStyle()
//                self.view.makeToast("Phone Number Required", duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: "Phone Number Required")
                return false
            }
        }
        if let password = passwordTxt.text {
            if password.count == 0 {
//                let style = ToastStyle()
//                self.view.makeToast("Password Required", duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: "Password Required")
                return false
            }
        }
        return valid
    }
    
    
//    func fbLogin2() {
//    provider = "facebook"
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: [ .publicProfile, .userFriends, .email ], viewController: self) { loginResult in
//                switch loginResult {
//                case .failed(let error):
//                    print(error)
//                case .cancelled:
//                    print("User cancelled login.")
//                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//
//                    print("accessToken: " + String(describing: accessToken))
//                    break
//
//                }
//            }
//    }
    func myface(){
//        if let token = AccessToken.current,
//                !token.isExpired {
//                // User is logged in, do work such as go to next view controller.
//            }
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        FaceBTn = loginButton
//        FaceBTn = FBLoginButton()
        view.addSubview(loginButton)
        loginButton.permissions = ["public_profile", "email","id","name","gender"]
        
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start {
            Connection, result, error in
            if (error == nil)
            {
                let dict = result as! [String : AnyObject]
                print(result)
                let email = dict["email"] as? String ?? "email"
                self.provider_email = email
                let name = dict["name"] as? String ?? "name"
                self.provider_name = name
                let id = dict["id"] as? String ?? "id"
                self.provider_id = id
                self.loginSocialMedia()
            }
        }
//        let login = FBLoginButton()
//        login.center = view.center
//        login.delegate = self
//        login.permissions = ["public_profile","email"]
//        view.addSubview(login)
    }
    func nextstepfacebook(){
        if let token = AccessToken.current,
                !token.isExpired {
            var fbAccessToken = AccessToken.current?.tokenString
            provider_token = fbAccessToken!
            print(provider_token)
          
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start {
                Connection, result, error in
                if (error == nil)
                {
                    let dict = result as! [String : AnyObject]
                    print(result)
                    let email = dict["email"] as? String ?? "email"
                    self.provider_email = email
                    let name = dict["name"] as? String ?? "name"
                    self.provider_name = name
                    let id = dict["id"] as? String ?? "id"
                    self.provider_id = id
                    self.loginSocialMedia()
                }
            }
                // User is logged in, do work such as go to next view controller.
            }
    }
    func fbLogin(){
        provider = "facebook"
        if let token = AccessToken.current,!token.isExpired{
            let token = token.tokenString
            print(token)
        }else{
//            let login = FBLoginButton()
//            login.center = self.FaceBookView.center
//            login.delegate = self
//            login.permissions = ["public_profile","email"]
//            view.addSubview(login)
            print(AccessToken.current)
            if((AccessToken.current) != nil){
                var fbAccessToken = AccessToken.current?.tokenString
                provider_token = fbAccessToken!
                print(provider_token)
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start {
                    Connection, result, error in
                    if (error == nil)
                    {
                        let dict = result as! [String : AnyObject]
                        print(result)
                        let email = dict["email"] as? String ?? "email"
                        self.provider_email = email
                        let name = dict["name"] as? String ?? "name"
                        self.provider_name = name
                        let id = dict["id"] as? String ?? "id"
                        self.provider_id = id
                        self.loginSocialMedia()
                    }
                }
            }
        }
        print(AccessToken.current)
        if((AccessToken.current) != nil){
            var fbAccessToken = AccessToken.current?.tokenString
            provider_token = fbAccessToken!
            print(provider_token)
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start {
                Connection, result, error in
                if (error == nil)
                {
                    let dict = result as! [String : AnyObject]
                    print(result)
                    let email = dict["email"] as? String ?? "email"
                    self.provider_email = email
                    let name = dict["name"] as? String ?? "name"
                    self.provider_name = name
                    let id = dict["id"] as? String ?? "id"
                    self.provider_id = id
                    self.loginSocialMedia()
                }
            }
        }
    }
    func loginSocialMedia(){
        let deviceState = OneSignal.getDeviceState()
        let pleyerId = deviceState?.userId
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let parameter = ["name" : provider_name,
                         "provider" : provider,
                         "provider_id" : provider_id,
                         "provider_token" : provider_token,
                         "email" : provider_email,
                         "phone_number" : "",
                         "firebase_token" : pleyerId ?? "",
                         "platform" : "ios",
                         "timezone" : localTimeZoneIdentifier,
                         "app_version" : appVersion ?? ""] as [String:Any]
//        print(parameter)
        print("fudgycvh")
        KRProgressHUD.show()
        NetworkManager().loginSocialRequest(param: parameter) { error, isSucces, mess in
            KRProgressHUD.dismiss()
            if isSucces == true{
                self.getAddress()
//                Helper.shared.saveIsLogin(IsLogin: true)
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let nextVC = storyboard.instantiateViewController(withIdentifier: "NavHomeVC") as? NavHomeVC {
//                    nextVC.modalPresentationStyle = .fullScreen
//                    self.present(nextVC, animated: true)
//
//                }
                    
            }else {
//                let style = ToastStyle()
//                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: mess ?? "")
            }
        }
    }
//    func getAddress(){
//        NetworkManager().getAddress{ (addressArray, mess, isSuccess) in
//            if isSuccess == true{
//                if addressArray.count == 0{
//                    let storyboard = UIStoryboard(name: "Address", bundle: nil)
//                    if let nextVC = storyboard.instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC {
//                        nextVC.modalPresentationStyle = .fullScreen
//                        self.present(nextVC, animated: true)
//                    }
//                }else{
//                    Helper.shared.saveIsLogin(IsLogin: true)
//                    Helper.shared.saveIsAddress(IsAddress: true)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    if let nextVC = storyboard.instantiateViewController(withIdentifier: "NavHomeVC") as? NavHomeVC {
//                        nextVC.modalPresentationStyle = .fullScreen
//                        self.present(nextVC, animated: true)
//                    }
//                }
//            }else {
//                let style = ToastStyle()
//                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
//            }
//        }
//    }
    func loginRequest(){
        KRProgressHUD.show()
        let phone = phoneTxt.getFormattedPhoneNumber(format: .E164) ?? ""
        NetworkManager().loginRequest(phone_number: phone, password: passwordTxt.text!){ (error, isSuccess, mess) in
            KRProgressHUD.dismiss()
            if isSuccess == true{
                self.getAddress()
            }else {
//                let style = ToastStyle()
//                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
                self.Alert(Message: mess ?? "")
            }
        }
    }
    
//    func checkAppleLogin() {
//        NetworkManager().checkAppleLoginApi { message, bool in
//            self.loginStack.isHidden = false
//            if bool{
//                self.setupProviderLoginView()
//            }else{
//                let view1 = UIView()
////                let view2 = UIView()
//                self.loginStack.addArrangedSubview(view1)
////                self.loginStack.addArrangedSubview(view2)
//            }
//        }
//    }
    func getAddress(){
        NetworkManager().getAddress{ (addressArray, mess, isSuccess) in
            if isSuccess == true{
                Helper.shared.saveIsLogin(IsLogin: true)
                if addressArray.count == 0{
                    Helper.shared.addressEnter = "FirstAddress"
                    let storyboard = UIStoryboard(name: "Address", bundle: nil)
                    if let nextVC = storyboard.instantiateViewController(withIdentifier: "AddAddressVC") as? AddAddressVC {
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: true)
                    }
                }else{
                    Helper.shared.saveIsAddress(IsAddress: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let nextVC = storyboard.instantiateViewController(withIdentifier: "NavHomeVC") as? NavHomeVC {
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: true)
                    }
                }
            }else {
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    @IBAction func btnFB(_ sender: Any) {
        if CheckTerms == 0{
            let alert = UIAlertController(title: "Oops!", message: "Please read and agree to the privacy policy and terms & conditions in order to sign in.",         preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            let loginManager = LoginManager()
               
               if let _ = AccessToken.current {
                   // Access token available -- user already logged in
                   // Perform log out
                   
                   // 2
                   loginManager.logOut()
                   updateButton(isLoggedIn: false)
                   updateMessage(with: nil)
                   
               } else {
                   // Access token not available -- user already logged out
                   // Perform log in
                   
                   // 3
                   loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
                       print(result)
                       // 4
                       // Check for error
                       guard error == nil else {
                           // Error occurred
                           let alert = UIAlertController(title: "Oops!", message: error!.localizedDescription,         preferredStyle: UIAlertController.Style.alert)

                           alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                               //Cancel Action
                           }))
                           self!.present(alert, animated: true, completion: nil)
                           print(error!.localizedDescription)
                           return
                       }
                       
                       // 5
                       // Check for cancel
                       guard let result = result, !result.isCancelled else {
                           print("User cancelled login")
                           let alert = UIAlertController(title: "Oops!", message: "User cancelled login",         preferredStyle: UIAlertController.Style.alert)

                           alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                               //Cancel Action
                           }))
                           self!.present(alert, animated: true, completion: nil)
                           return
                       }
                     
                       // Successfully logged in
                       // 6
                       self?.updateButton(isLoggedIn: true)
                       
                       // 7
                       Profile.loadCurrentProfile { (profile, error) in
                           print(profile)
//                           self?.provider_email = profile.
                           self!.provider = "facebook"
                           self!.provider_name = "\(profile?.firstName ?? "" )\(profile?.lastName ?? "" )"
                           self!.provider_id = profile?.userID ?? ""
                           self!.provider_token = "\(String(describing: AccessToken.current))"
                           print( self!.provider_token )
                           print( self!.provider_name )
                           print(self!.provider_id)
                           self!.loginSocialMedia()

//                           self?.updateMessage(with: Profile.current?.name)
                       }
                   }
               }
//            myface()
//            fbLogin()
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if validateViews(){
            if CheckTerms == 0{
                let alert = UIAlertController(title: "Oops!", message: "Please read and agree to the privacy policy and terms & conditions in order to sign in.",         preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    //Cancel Action
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                loginRequest()
            }
        }
    }
    
    @IBAction func asGuestTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(withIdentifier: "NavHomeVC") as? NavHomeVC {
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }
    }
    
    
    @IBAction func registerTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC else {return}
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
        
    }
    @IBAction func forgotPass(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassVC") as? ForgotPassVC else {return}
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
extension LoginVC: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {}
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        self.isValid = isValid
    }
    func fpnDisplayCountryList() {}
}
//extension LoginVC : LoginButtonDelegate {
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        self.Alert(Message: "Sign in with Facebook failed")
//    }
//
//
////    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
////        let token = result?.token?.tokenString
////        print(token)
////        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token,version: nil ,httpMethod: .get)
////        print(AccessToken.current)
////        if((AccessToken.current) != nil){
////            var fbAccessToken = AccessToken.current?.tokenString
////            provider_token = fbAccessToken!
////            print(provider_token)
////            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start {
////                Connection, result, error in
////                if (error == nil)
////                {
////                    let dict = result as! [String : AnyObject]
////                    print(result)
////                    let email = dict["email"] as? String ?? "email"
////                    self.provider_email = email
////                    let name = dict["name"] as? String ?? "name"
////                    self.provider_name = name
////                    let id = dict["id"] as? String ?? "id"
////                    self.provider_id = id
////                    self.loginSocialMedia()
////                }
////            }
////        }
//////        request.start(completionHandler: {connection, result , error in
//////            if let tabBarVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBar") as? MainTabBar {
//////                if let accessToken = AccessToken.current?.tokenString {
//////                    NetworkManager().FacebookloginRequest(access_token: accessToken) { (error, isSuccess, mess) in
//////                        LoginManager().logOut()
//////                        self.SetDeviceDataRegister()
//////                        let nextVC = UINavigationController(rootViewController: tabBarVc)
//////                        nextVC.modalPresentationStyle = .fullScreen
//////                        self.present(nextVC, animated: true, completion: nil)
//////                    }
//////                }
////           // }
////       // })
////    }
//
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        print("Hello")
//    }
//}


//extension LoginVC: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        let Alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
//        Alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        present(Alert, animated: true, completion: nil)
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let firstName = fullName?.givenName
//            let lastName = fullName?.familyName
//            let email = appleIDCredential.email!
//
//            provider_id = userIdentifier
//            provider_name = "\(firstName ?? "") \(lastName ?? "")"
//            provider_email = email
//            loginSocialMedia()
//        case let appleIDCredential as ASPasswordCredential:
//            print(appleIDCredential.password)
//
//        default:
//            let Alert = UIAlertController(title: "Apple SingIn", message: "Something wronge", preferredStyle: .alert)
//            Alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//            present(Alert, animated: true, completion: nil)
//        }
//
//    }
//}
//extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//            print(userIdentifier)
//            print(fullName)
//            print(email)
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
////            self.saveUserInKeychain(userIdentifier)
//            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
////            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
//        case let passwordCredential as ASPasswordCredential:
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
////                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//        default:
//            break
//        }
//    }
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        self.Alert(Message: "Somthing went wrong")
//    }
//    func performExistingAccountSetupFlows() {
//        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                break // The Apple ID credential is valid.
//            case .revoked, .notFound:
//                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                DispatchQueue.main.async {
//                    self.window?.rootViewController?.showLoginViewController()
//                }
//            default:
//                break
//            }
//        }
//        return true
//    }
//}
extension LoginVC {
    
    private func updateButton(isLoggedIn: Bool) {
        // 1
        let title = isLoggedIn ? "Log out 👋🏻" : "Continue with Facebook"
        FaceBTn.setTitle(title, for: .normal)
    }
    
    private func updateMessage(with name: String?) {
        // 2
        guard let name = name else {
            // User already logged out
//            messageLabel.text = "Please log in with Facebook."
            return
        }
        
        // User already logged in
//        messageLabel.text = "Hello, \(name)!"
    }
}
