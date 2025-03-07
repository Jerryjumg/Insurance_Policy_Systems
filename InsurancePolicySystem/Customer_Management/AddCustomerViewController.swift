//
//  AddCusomterViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/29/24.
//

import UIKit

class AddCustomerViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addCustomerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addCustomerButtonTapped(_ sender: UIButton) {
           addCustomer()
       }
       
    @IBAction func backButtonTapped(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
     }
    
    
       @objc func addCustomer() {
           guard let name = nameTextField.text, !name.isEmpty else {
               showAlert(title: "Error", message: "Please enter a name")
               return
           }
           guard let age = ageTextField.text, !age.isEmpty else {
               showAlert(title: "Error", message: "Please enter an age")
               return
           }
           guard let ageInt = Int(age), ageInt > 0 else {
               showAlert(title: "Error", message: "Please enter an age greater than zero.")
               return
           }
           let emailPattern = #"^\S+@\S+\.\S+$"#
           guard let email = emailTextField.text, email.range(of: emailPattern, options: .regularExpression) != nil else {
               showAlert(title: "Warning", message: "Invalid email format. Please enter a valid email.")
               return
           }
           
           let directory = InsuranceDirectory.shared
           // Check if email already exists
           if directory.getCustomers().contains(where: { $0.email.caseInsensitiveCompare(email) == .orderedSame }) {
               showAlert(title: "Error", message: "Email already exists. Please use a different email.")
               return
           }
           let newCustomerID = (directory.getCustomers().map { $0.id }.max() ?? 0) + 1
        
           directory.addCustomer(customer: Customer(id: newCustomerID, name: name, age: ageInt, email: email))
           print("Customer directory updated!!")
           print(directory.getCustomers().count)
           
           showAlert(title: "Success", message: "Customer added successfully.")
           
           // Clear text fields
           nameTextField.text = ""
           ageTextField.text = ""
           emailTextField.text = ""
       }
       
       private func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
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
