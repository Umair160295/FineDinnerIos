//
//  ImagePicker.swift
//  FineDiner
//
//  Created by Mohammad Jawher on 21/08/2022.
//

import Foundation
import UIKit
import KRProgressHUD

class ImagePicker: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
//    let VC = ProfileVC.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
    }
    
    func OpenPortfolioVideo(){
            let alert = UIAlertController(title: "Add Video", message: nil, preferredStyle: .alert)
            let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
                self.imagePicker.mediaTypes = ["public.movie"]
                self.imagePicker.delegate = self
                self.OpenPcikImageOrCamera()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(gallery)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
    }
    
    func OpenprescriptionImage(){
            let alert = UIAlertController(title: "Add Image", message: nil, preferredStyle: .alert)
            let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
                self.imagePicker.mediaTypes = ["public.image"]
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.OpenPcikImageOrCamera()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(gallery)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
    }
    
    func Open(){
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
                self.imagePicker.mediaTypes = ["public.image"]
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.OpenPcikImageOrCamera()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(gallery)
            self.present(alert,animated: true,completion: nil)
    }
    
    func SelectedImage(image: UIImage){
        
    }
    
    func SelectedImgprescription(image: UIImage){
        
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        if Shared.shared.imgUserType == "Profile"{
            SelectedImage(image: image)
//        }else{
//            SelectedImgprescription(image: image)
//        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func OpenPcikImageOrCamera (){
        self.present(self.imagePicker,animated: true,completion: nil)
    }
}
