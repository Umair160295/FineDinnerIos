//
//  PersonalInfoVC.swift
//  FineDiner
//
//  Created by iOS Developer on 22/12/2021.
//

import UIKit
import Toast_Swift
import KRProgressHUD
import FlagPhoneNumber
import ImagePicker
import SDWebImage

class PersonalInfoVC: ImagePicker, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var upperImage: UIImageView!
    @IBOutlet weak var profileNameView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
//    {
//        didSet{
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadImage))
//            profileImage.addGestureRecognizer(tapGestureRecognizer)
//            profileImage.isUserInteractionEnabled = true
//        }
//    }
        
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var birth_dateTxt: UITextField!
    
    let picker = UIDatePicker()
    private var selectedImage : UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperImage.viewDesign()
        upperView.viewDesign()
        profileNameView.layer.borderWidth = 5
        profileNameView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        getProfile()
        createBirthdayDatePicker()
        let tap = UITapGestureRecognizer(target: self, action: #selector(GetIMage(gesture:)))
        tap.delegate = self
        profileNameView.addGestureRecognizer(tap)
    }
    @objc func GetIMage(gesture: UIGestureRecognizer) {
        Open()
    }
    override func SelectedImage(image: UIImage) {
        self.profileImage.image = image
    }
//    @objc func uploadImage(){
//        let imagePickerController = ImagePickerController()
//        imagePickerController.imageLimit = 1
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
//    }
    
    func createBirthdayDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneEndPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,done], animated: false)
        
        birth_dateTxt.inputAccessoryView = toolbar
        birth_dateTxt.inputView = picker
    }
    @objc func doneEndPressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: picker.date)
        birth_dateTxt.text = "\(date)"
        self.view.endEditing(true)
    }
    
    func getProfile(){
        KRProgressHUD.show()
        NetworkManager().getProfile(){ (error, isSuccess, mess, name, phone_number,email,avatar,birth_date) in
            KRProgressHUD.dismiss()
            if isSuccess == true{
                Helper.shared.saveUserName(name: name ?? "")
                Helper.shared.saveUserAvatar(avatar: avatar ?? "")

                self.nameTxt.text = name
                self.emailTxt.text = email
                self.phoneTxt.text = phone_number
                self.birth_dateTxt.text = birth_date
//                self.profileImage.sd_setImage(with: URL(string: avatar!), completed: nil)
                if avatar == ""{
                    self.profileImage.image = UIImage(named: "Logo-1")
                }else{
                    self.profileImage.sd_setImage(with: URL(string: avatar!), completed: nil)
                }
            }else {
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else {return}
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        KRProgressHUD.show()
        NetworkManager().updateProfile(name: nameTxt.text!, avatar: profileImage.image!, birth_date: birth_dateTxt.text!){ (error, isSuccess, mess) in
            KRProgressHUD.dismiss()
            if isSuccess == true{
                let style = ToastStyle()
                self.view.makeToast("CHANGED SUCESSFULL", duration: 4.0, position: .bottom, style: style)
            } else{
              let style = ToastStyle()
               self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
}

//extension PersonalInfoVC :ImagePickerDelegate, UITextViewDelegate {
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        if images.count == 0 {
//            return
//        }
//        self.profileImage.layer.cornerRadius = 50
//        self.profileImage.contentMode = .scaleAspectFit
//        self.profileImage.image = images[0]
//
//        if images.count > 0 {
//            self.selectedImage = images[0]
//        }
//
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//}
