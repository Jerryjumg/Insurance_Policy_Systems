//
//  AddPolicyViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/29/24.
//

import UIKit

class AddPolicyViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet  var customerIdTextField: UITextField!
    @IBOutlet  var policyTypeTextField: UITextField!
    @IBOutlet weak var premiumAmountTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var addPolicyBtn: UIButton!
    @IBOutlet weak var addPolicyLabel: UILabel!
    
    
    // Initialize pickers and arrays for selection
    private let policyTypes = ["Health", "Life", "Travel"]
    private let policyPicker = UIPickerView()
    private let customerPicker = UIPickerView()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let customerList = InsuranceDirectory.shared.getCustomers()
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickers()  // Ensure this is called after IBOutlets are connected
        registerForKeyboardNotifications()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
            view.addGestureRecognizer(tapGesture)
    }
    
    
    
    private func setupPickers() {
        // Configure policy type picker
        policyPicker.delegate = self
        policyPicker.dataSource = self
        policyTypeTextField.inputView = policyPicker
        
        //Configure customer picker
        customerPicker.delegate = self
        customerPicker.dataSource = self
        customerIdTextField.inputView = customerPicker
        
        // Configure start date picker
        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        startDateTextField.inputView = startDatePicker
        
        // Configure end date picker
        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        endDateTextField.inputView = endDatePicker
    }
    
    // UIPickerViewDelegate and UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == policyPicker ? policyTypes.count : customerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == policyPicker ? policyTypes[row] : customerList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == policyPicker {
            policyTypeTextField.text = policyTypes[row]
        } else if pickerView == customerPicker {
            customerIdTextField.text = "\(customerList[row].id)"
        }
    }
    
    // Date change methods for date pickers
    @objc private func startDateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        startDateTextField.text = formatter.string(from: startDatePicker.date)
    }
    
    @objc private func endDateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        endDateTextField.text = formatter.string(from: endDatePicker.date)
    }
    
    
    @IBAction func addPolicyButtonTapped(_ sender: UIButton) {
        addPolicy()
    }
    
    @objc private func addPolicy() {
        guard let customerIdText = customerIdTextField.text, !customerIdText.isEmpty else {
            showAlert(title: "Warning", message: "Please select a customer.")
            return
        }
        guard let customerIdInt = Int(customerIdText) else {
            showAlert(title: "Warning", message: "Invalid customer ID format.")
            return
        }
        guard InsuranceDirectory.shared.getCustomer(id: customerIdInt) != nil else {
            showAlert(title: "Warning", message: "Invalid customer ID.")
            return
        }
        
        guard let policyTypeText = policyTypeTextField.text, !policyTypeText.isEmpty, policyTypes.contains(policyTypeText) else {
            showAlert(title: "Warning", message: "Please select a valid policy type.")
            return
        }
        guard let premiumAmountText = premiumAmountTextField.text, !premiumAmountText.isEmpty else {
            showAlert(title: "Warning", message: "Please enter a premium.")
            return
        }
        guard let premiumAmount = Double(premiumAmountText) else {
            showAlert(title: "Warning", message: "Invalid premium format.")
            return
        }
        
        guard premiumAmount > 0 else {
            showAlert(title: "Warning", message: "Premium must be greater than zero.")
            return
        }
        
        let startDatePicked = startDatePicker.date
        let endDatePicked = endDatePicker.date
        
        if startDatePicked >= endDatePicked {
            showAlert(title: "Warning", message: "Start date must be before end date.")
            return
        }
        
        let isSameDay = Calendar.current.isDate(startDatePicked, inSameDayAs: endDatePicked)
        let today = Calendar.current.startOfDay(for: Date())
        
        if startDatePicked < today || endDatePicked < today {
            showAlert(title: "Warning", message: "Start and end dates cannot be in the past.")
            return
        }
        
        if isSameDay {
            showAlert(title: "Warning", message: "Start date and end date cannot be the same day.")
            return
        }
        
        let directory = InsuranceDirectory.shared
        let newPolicyID = (directory.getInsurancePolicies().map { $0.id }.max() ?? 0) + 1
        
        let newPolicy = InsurancePolicy(id: newPolicyID, customer_id: customerIdInt, policy_type: policyTypeText, premium_amount: premiumAmount, start_date: startDatePicked, end_date: endDatePicked)
        directory.addInsurancePolicy(insurancePolicy: newPolicy)
        print("Policy updated!!")
        print("Insurance count: \(directory.getInsurancePolicies().count)")
        dismissPicker()
        showAlert(title: "Success", message: "Insurance added successfully.") {
            self.clearFields()
        }
  
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardSize.height / 2
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    //       private func showAlert(title: String, message: String) {
    //           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    //           self.present(alert, animated: true, completion: nil)
    //       }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?() // Call the completion handler after the alert is dismissed
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func clearFields() {
        policyTypeTextField.text = ""
        customerIdTextField.text = ""
        premiumAmountTextField.text = ""
        startDatePicker.date = Date()
        endDatePicker.date = Date()
        policyPicker.selectRow(0, inComponent: 0, animated: false)
        policyTypeTextField.text = policyTypes[0]
        if !customerList.isEmpty {
            customerPicker.selectRow(0, inComponent: 0, animated: false)
            customerIdTextField.text = "\(customerList[0].id)"
        }
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)  // This will dismiss the picker
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
