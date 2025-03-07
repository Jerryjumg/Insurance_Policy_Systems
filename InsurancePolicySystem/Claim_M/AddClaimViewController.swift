//
//  AddClaimViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/29/24.
//

import UIKit

class AddClaimViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource  {

   @IBOutlet weak var policyIdTextField: UITextField!
   @IBOutlet weak var claimAmountTextField: UITextField!
   @IBOutlet weak var dateOfClaimTextField: UITextField!
   @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var addClaimButton: UIButton!
//    @IBOutlet weak var policyPicker: UIPickerView!
//    @IBOutlet weak var statusPicker: UIPickerView!
//    @IBOutlet weak var claimDatePicker: UIDatePicker!
    
    private let policyPicker = UIPickerView()
    private let statusPicker = UIPickerView()
    private let claimDatePicker = UIDatePicker()

    
    var policyList: [InsurancePolicy] = InsuranceDirectory.shared.getInsurancePolicies()
    var statusList: [String] = ["Pending", "Approved", "Rejected"]

    override func viewDidLoad() {
        super.viewDidLoad()
        policyPicker.delegate = self
        policyPicker.dataSource = self
        statusPicker.delegate = self
        statusPicker.dataSource = self
        claimDatePicker.datePickerMode = .date
        claimDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
      //  claimDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        policyIdTextField.inputView = policyPicker
        statusTextField.inputView = statusPicker
        dateOfClaimTextField.inputView = claimDatePicker
        registerForKeyboardNotifications()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
            view.addGestureRecognizer(tapGesture)
    }

    @IBAction func addClaimButtonTapped(_ sender: UIButton) {
        addClaim()
    }

    @objc private func addClaim() {
        guard let policyIdText = policyIdTextField.text, !policyIdText.isEmpty else {
            showAlert(title: "Warning", message: "Please select a policy.")
            return
        }
        guard let policyIdInt = Int(policyIdText) else {
            showAlert(title: "Warning", message: "Invalid policy ID format.")
            return
        }
        guard InsuranceDirectory.shared.getInsurancePolicy(id: policyIdInt) != nil else {
            showAlert(title: "Warning", message: "Invalid policy ID.")
            return
        }
        let claimDatePicked = claimDatePicker.date
           let today = Calendar.current.startOfDay(for: Date())

           if claimDatePicked < today {
               showAlert(title: "Warning", message: "Claim date cannot be in the past.")
               return
           }

           guard let statusText = statusTextField.text, !statusText.isEmpty, statusList.contains(statusText) else {
               showAlert(title: "Warning", message: "Please select a valid status.")
               return
           }
           guard let claimAmountText = claimAmountTextField.text, !claimAmountText.isEmpty else {
               showAlert(title: "Warning", message: "Please enter a claim amount.")
               return
           }
           guard let claimAmount = Double(claimAmountText) else {
               showAlert(title: "Warning", message: "Invalid claim amount format.")
               return
           }

           guard claimAmount > 0 else {
               showAlert(title: "Warning", message: "Claim amount must be greater than zero.")
               return
           }

           let directory = InsuranceDirectory.shared
           let newClaimID = (directory.getClaims().map { $0.id }.max() ?? 0) + 1

        let newClaim = Claim(id: newClaimID, policy_id: policyIdInt,claim_amount: claimAmount, date_of_claim: claimDatePicked, status: statusText)
           directory.addClaim(claim: newClaim)
            
           showAlert(title: "Success", message: "Claim added successfully.")
           print("Claim count: \(directory.getClaims().count)")

           // Clear fields
           policyIdTextField.text = ""
           statusTextField.text = ""
           claimAmountTextField.text = ""
           claimDatePicker.date = Date()
           policyPicker.selectRow(0, inComponent: 0, animated: false)
           statusPicker.selectRow(0, inComponent: 0, animated: false)
           if !policyList.isEmpty {
               policyIdTextField.text = "\(policyList[0].id)"
           }
           statusTextField.text = statusList[0]
       }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        updateDateOfClaimTextField() // Call this method when the date changes
    }

    private func updateDateOfClaimTextField() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Set the desired date format
        dateOfClaimTextField.text = dateFormatter.string(from: claimDatePicker.date)
    }
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == policyPicker {
            return policyList.count
        } else if pickerView == statusPicker {
            return statusList.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == policyPicker {
            return "\(policyList[row].id)"
        } else if pickerView == statusPicker {
            return statusList[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == policyPicker {
            policyIdTextField.text = "\(policyList[row].id)"
        } else if pickerView == statusPicker {
            statusTextField.text = statusList[row]
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
