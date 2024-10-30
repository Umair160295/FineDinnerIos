//
//  ReviewsVC.swift
//  FineDiner
//
//  Created by iOS Developer on 24/12/2021.
//

import UIKit
import SDWebImage
import KRProgressHUD
import Toast_Swift

class ReviewsVC: UIViewController {
    
    var dataList = [ReviewM]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblNameMenu: UILabel!
    @IBOutlet weak var lblDescriptionMenu: UILabel!
    @IBOutlet weak var lblCountRateOfMenu: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
//        Helper.shared.menuId = id
        self.imgMenu.layer.borderWidth = 1
        self.imgMenu.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        self.imgMenu.sd_setImage(with: URL(string: Helper.shared.menuImg), completed: nil)
        lblNameMenu.text = Helper.shared.menuName
        lblDescriptionMenu.text = Helper.shared.menuDescription
        lblCountRateOfMenu.text = "\(Helper.shared.menuRate)"
        getReview()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataReview), name: NSNotification.Name(rawValue: "reloadDataReview"), object: nil)
    }
    
    @objc func reloadDataReview() {
        getReview()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "ReviewsCell", bundle: nil), forCellReuseIdentifier: "ReviewsCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getReview() {
        KRProgressHUD.show()
        NetworkManager().getReview { review, message, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.dataList = review
                self.tableView.reloadData()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as? OrderDetailsVC else {return}
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func addReviewTapped(_ sender: Any) {
        if Helper.shared.getIsLogin() == true{
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC else {return}
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }else{
        let message = "Please, login"
        let style = ToastStyle()
         self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
        }

    }
}
extension ReviewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell", for: indexPath) as? ReviewsCell{
            cell.setData(data: dataList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
}

