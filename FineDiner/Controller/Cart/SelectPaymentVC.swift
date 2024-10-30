//
//  SelectPaymentVC.swift
//  FineDiner
//
//  Created by iOS Developer on 23/12/2021.
//

import UIKit
import KRProgressHUD
import FirebaseAnalytics
import Toast_Swift
import WebKit
import Adjust


class SelectPaymentVC: UIViewController {

    @IBOutlet weak var AddcardBTn: UIButton!
    @IBOutlet weak var CardTableView: UITableView!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var groupViewOne: UIView!
    @IBOutlet weak var groupViewTwo: UIView!
    @IBOutlet weak var CreditCheckImg: UIImageView!
    @IBOutlet weak var CashCheckImg: UIImageView!
    
    var flag = "card"
    var redirect_url = ""
    let webView = WKWebView()
    var webViewFlag = 0
    var orderPrice = 0.0
    var datalistCard = [CardM]()
var selectedindex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        AddcardBTn.layer.borderWidth = 1
//        AddcardBTn.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.6470588235, blue: 0.1254901961, alpha: 1)
        AddcardBTn.layer.cornerRadius = 10
        Helper.shared.CardID = 0
        getCard()
        groupView.fullDesign()
//        groupViewOne.fullDesign()
//        groupViewTwo.fullDesign()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    @IBAction func btnCredit(_ sender: Any) {
        flag = "card"
//        CreditCheckImg.image = UIImage(named: "check-1")
//        CashCheckImg.image = UIImage(named: "un-check-1")
    }
    @IBAction func btnCash(_ sender: Any) {
        flag = "cash"
        CreditCheckImg.image = UIImage(named: "un-check-1")
        CashCheckImg.image = UIImage(named: "check-1")
    }
    func setupcardTableView(){

            CardTableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
            CardTableView.delegate = self
            CardTableView.dataSource = self
            CardTableView.reloadData()
  
    }
    func getCard(){
        KRProgressHUD.show()
        NetworkManager().getCard { Arr, mess, bool in
            KRProgressHUD.dismiss()
            if bool{
                self.datalistCard = Arr
                self.setupcardTableView()
            }else{
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
            
            
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmLocationVC") as? ConfirmLocationVC else {return}
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
    }
    @IBAction func nextTapped(_ sender: Any) {
//        let rootVC = UIStoryboard(name: "Your Orders", bundle: nil).instantiateViewController(withIdentifier: "YourOrdersVC")
//        self.navigationController?.pushViewController(rootVC, animated: true)

        if flag == "cash"{
            setData()
        }else{
            if Helper.shared.CardID == 0{
                let style = ToastStyle()
                self.view.makeToast("No card selected ", duration: 4.0, position: .bottom, style: style)
            }else{
//                let storyboard = UIStoryboard(name: "Your Orders", bundle: nil)
//                let root = storyboard.instantiateViewController(withIdentifier: "YourOrdersVC") as? YourOrdersVC
//                    self.navigationController?.pushViewController(root!, animated: true)
//                self.present(root!, animated: true)
//                chekout()
                payment_pay_order_t()
            }
            
            
           
//            getPayment()
//            self.setWebView( )
        }
    }
    @IBAction func AddNewCardBtn(_ sender: Any) {
        if flag == "cash"{
            setData()
        }else{
            tokenize_request_t()
//            getPayment()
        }
    }
    func tokenize_request_t(){
        let parameter = [
            "order_id" :Helper.shared.order_id] as [String:Any]
        print(parameter)
        KRProgressHUD.show()
        NetworkManager().tokenize_request_t(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool {
                self.redirect_url = message
                self.setWebView()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func getPayment(){
//        let parameter = ["address_id":Helper.shared.addressId,
//                         "date_order":Helper.shared.dateOrder,
//                         "time_order":Helper.shared.timeOrder,
//                         "note":Helper.shared.note]
        let parameter = [
            "address_id" : Helper.shared.addressId,
            "payment" : flag,
            "date_order" : Helper.shared.dateOrder,
            "start_time" : Helper.shared.start_time_Order,
            "end_time" : Helper.shared.end_time_Order,
            "type_time" : Helper.shared.type_time,
            "promo_code" : Helper.shared.promoCode,
            "note" : Helper.shared.note]
        print(parameter)
        KRProgressHUD.show()
        NetworkManager().payment(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool {
                self.redirect_url = message
                self.setWebView()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func payment_pay_order_t(){
        let parameter = [
            "order_id" : Helper.shared.order_id,
            "card_id":Helper.shared.CardID] as! [String:Any]
        
        print(parameter)
        KRProgressHUD.show()
        NetworkManager().pay_order_t(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool {
                print(message)
                self.redirect_url = message
                self.setWebView()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func chekout(){
        let parameter = [
            "address_id" : Helper.shared.addressId,
            "payment" : flag,
            "date_order" : Helper.shared.dateOrder,
            "start_time" : Helper.shared.start_time_Order,
            "end_time" : Helper.shared.end_time_Order,
            "type_time" : Helper.shared.type_time,
            "promo_code" : Helper.shared.promoCode,
            "note" : Helper.shared.note,
            "card_id":Helper.shared.CardID] as! [String:Any]
        
        print(parameter)
        KRProgressHUD.show()
        NetworkManager().CheckOut(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool {
                print(message)
                self.redirect_url = message
                self.setWebView()
//                let style = ToastStyle()
//                self.view.makeToast("Succfuly Payment", duration: 4.0, position: .bottom, style: style)
//                Helper.shared.CardID = 0
//                let rootVC = UIStoryboard(name: "Your Orders", bundle: nil).instantiateViewController(withIdentifier: "YourOrdersVC")
//                self.navigationController?.pushViewController(rootVC, animated: true)
//                self.redirect_url = message
//                self.setWebView()
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    func setWebView() {
        HomeVC().Analytics(title: "Initiate_Checkout_App")
        let event = ADJEvent(eventToken: "8b7crg")
        Adjust.trackEvent(event)
        let link = redirect_url
        print(link)
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 85))
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        view.addSubview(webView)
        guard let url = URL(string: link) else {
            return
        }
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
        self.webView.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        webView.removeFromSuperview()
    }
    
    func setData(){
        let parameter = [
            "address_id" : Helper.shared.addressId,
            "payment" : flag,
            "date_order" : Helper.shared.dateOrder,
            "start_time" : Helper.shared.start_time_Order,
            "end_time" : Helper.shared.end_time_Order,
            "type_time" : Helper.shared.type_time,
            "promo_code" : Helper.shared.promoCode,
            "note" : Helper.shared.note]
        print(parameter)
        KRProgressHUD.show()
        NetworkManager().postOrder(param: parameter) { message, bool in
            KRProgressHUD.dismiss()
            if bool{
//                let storyboard = UIStoryboard(name: "Your Orders", bundle: nil)
//                let destViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: "YourOrdersVC")
//                destViewController.modalPresentationStyle = .fullScreen
//                self.present(destViewController, animated: true)
                
                let rootVC = UIStoryboard(name: "Your Orders", bundle: nil).instantiateViewController(withIdentifier: "YourOrdersVC")
                self.navigationController?.pushViewController(rootVC, animated: true)
            }else{
                let style = ToastStyle()
                self.view.makeToast(message, duration: 4.0, position: .bottom, style: style)
            }
        }
    }
    
    func Alert (Message: String){
        let alert = UIAlertController(title: "Oops!", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in

        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func delete(sender:UIButton){
        let id = datalistCard[sender.tag].id
        Helper.shared.CardID = id
        delet_cart()
    }
    func delet_cart(){
        let parameter = [
            "id" : Helper.shared.CardID]
        KRProgressHUD.show()
        NetworkManager().delete_card(param: parameter) { mess, bool in
            KRProgressHUD.dismiss()
            if bool{
                let style = ToastStyle()
                self.view.makeToast("Card deleted successfully", duration: 4.0, position: .bottom, style: style)
                self.getCard()
            }else{
                let style = ToastStyle()
                self.view.makeToast(mess, duration: 4.0, position: .bottom, style: style)
            }
            
        }
    }
    
}


extension SelectPaymentVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString{
            print("url = \(url)")
            if webViewFlag == 0{
                if url.contains("return") {
                    print("exists")
                    webViewFlag = 1
                }
            }else{
//                if url == "https://app.finediner.co/api/payment/success"{
                if url.contains("https://app.finediner.co/api/payment/success_t") || url.contains("https://app.finediner.co/api/payment/savecard_t") {
                    HomeVC().Analytics(title: "Complete_Checkout_App")
                    var purchaseParams: [String: Any] = [
                      AnalyticsParameterCurrency: "AED",
                      AnalyticsParameterValue: Helper.shared.itemtTotalPriceInPopupCart
                    ]
                    Analytics.logEvent(AnalyticsEventPurchase, parameters: purchaseParams)
                    print(Helper.shared.itemtTotalPriceInPopupCart)
                    let event = ADJEvent(eventToken: "ybdsl9")
                    event?.setRevenue(Helper.shared.itemtTotalPriceInPopupCart, currency: "AED")
                    Adjust.trackEvent(event)
                    let event2 = ADJEvent(eventToken: "er6hai")
                    Adjust.trackEvent(event2)

                   print("successEva")
                    webView.removeFromSuperview()
                    let storyboard = UIStoryboard(name: "Your Orders", bundle: nil)
                    let root = storyboard.instantiateViewController(withIdentifier: "YourOrdersVC") as? YourOrdersVC
                    self.navigationController?.pushViewController(root!, animated: true)
//                    self.present(root!, animated: true)
                    
//                    let storyboard = UIStoryboard(name: "Your Orders", bundle: nil)
//                    let destViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: "YourOrdersVC")
//                    destViewController.modalPresentationStyle = .fullScreen
//                    self.present(destViewController, animated: true)
                }else{
                   webView.removeFromSuperview()
                    self.Alert(Message: "failer")
                }
            }
        }
    }
    
}
extension SelectPaymentVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalistCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CardTableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardCell
        if datalistCard[indexPath.row].select == "no"{
            cell?.RadioBtn.image = UIImage(named: "RadioOutIcon")
        }else{
            cell?.RadioBtn.image = UIImage(named: "RadioInIcon")
        }
        cell?.CardNameLbl.text  = datalistCard[indexPath.row].card_scheme
        cell?.CardNumberLbl.text = datalistCard[indexPath.row].payment_description
        cell?.deletecardBtn.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        cell?.deletecardBtn.tag  = indexPath.row
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 77
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in datalistCard{
            if i.select == "yes"{
                i.select = "no"
            }
        }
        Helper.shared.CardID = datalistCard[indexPath.row].id
        print(Helper.shared.CardID)
        self.datalistCard[indexPath.row].select = "yes"
        CardTableView.reloadData()
    }
    
    
}
