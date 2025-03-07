//
//  MainViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/29/24.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    //@IBOutlet weak var myView : UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var AddCustomerBtn: UIButton!
    @IBOutlet weak var viewAllCustomerBtn: UIButton!
    
    @IBOutlet weak var AddPolicyBtn: UIButton!
    @IBOutlet weak var viewAllPolicyBtn: UIButton!
    
    @IBOutlet weak var AddClaimBtn: UIButton!
    @IBOutlet weak var viewAllClaimsBtn: UIButton!
    
    @IBOutlet weak var addPaymentBtn: UIButton!
    @IBOutlet weak var viewAllPaymentBtn: UIButton!
    
    
    @IBAction func addCustomerBtn(_ sender: UIButton) {
        
        let addvc = AddCustomerViewController(nibName: "AddCustomerViewController", bundle: nil)
        self.present(addvc, animated: true, completion: nil)
        
    }
    
    @IBAction func viewCustomersBtnTapped(_ sender: UIButton) {
        let viewvc = viewCustomersViewController(nibName: "viewCustomersViewController", bundle: nil)
        self.present(viewvc, animated: true, completion: nil)
    }
    
//    @IBAction func addPolicyBtnTapped(_ sender: UIButton) {
//        let addvc = AddPolicyViewController(nibName: "AddPolicyViewController", bundle: nil)
//        self.present(addvc, animated: true, completion: nil)
//    }
//    
//    @IBAction func viewAllPoliciesBtnTapped(_ sender: UIButton) {
//        let viewvc = ViewPoliciesViewController(nibName: "ViewPoliciesViewController", bundle: nil)
//        self.present(viewvc, animated: true, completion: nil)
//    }
    
    @IBAction func addClaimBtnTapped(_ sender: UIButton) {
        let addvc = AddClaimViewController(nibName: "AddClaimViewController", bundle: nil)
        self.present(addvc, animated: true, completion: nil)
    }
//    
//    @IBAction func viewAllClaimsBtnTapped(_ sender: UIButton) {
//        let viewvc = ViewClaimsViewController(nibName: "ViewClaimsViewController", bundle: nil)
//        self.present(viewvc, animated: true, completion: nil)
//    }
//    
    @IBAction func addPaymentBtnTapped(_ sender: UIButton) {
        let addvc = AddPaymentViewController(nibName: "AddPaymentViewController", bundle: nil)
        self.present(addvc, animated: true, completion: nil)
    }
//    
//    @IBAction func viewAllPaymentsBtnTapped(_ sender: UIButton) {
//        let viewvc = ViewPaymentsViewController(nibName: "ViewPaymentsViewController", bundle: nil)
//        self.present(viewvc, animated: true, completion: nil)
//    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white // Add this line to confirm the view is being displayed
//            welcomeLabel.backgroundColor = UIColor.brown
//            welcomeLabel.text = "Hello World!"
     
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
