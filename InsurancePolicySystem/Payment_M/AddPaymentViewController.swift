//
//  AddPaymentViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/29/24.
//

import UIKit

class AddPaymentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var policyIdTextField: UITextField!
    @IBOutlet weak var paymentAmountTextField: UITextField!
    @IBOutlet weak var paymentDateTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var addPaymentBtn: UIButton!
//    @IBOutlet weak var policyPicker: UIPickerView!
//    @IBOutlet weak var paymentMethodPicker: UIPickerView!
//    @IBOutlet weak var statusPicker: UIPickerView!

    
    var policyList: [InsurancePolicy] = InsuranceDirectory.shared.getInsurancePolicies()
    var paymentMethods: [String] = ["Credit Card", "Bank Transfer"]
    var statusList: [String] = ["Pending", "Completed", "Failed"]

      private var policyPicker: UIPickerView!
      private var paymentMethodPicker: UIPickerView!
      private var statusPicker: UIPickerView!
      private var paymentDatePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        policyPicker = UIPickerView()
        paymentMethodPicker = UIPickerView()
        statusPicker = UIPickerView()
        paymentDatePicker = UIDatePicker()
        
       
        
        policyPicker.delegate = self
        policyPicker.dataSource = self
        paymentMethodPicker.delegate = self
        paymentMethodPicker.dataSource = self
        statusPicker.delegate = self
        statusPicker.dataSource = self
        paymentDatePicker.datePickerMode = .date
        paymentDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        // Assign the pickers to the corresponding text fields
        policyIdTextField.inputView = policyPicker
        paymentMethodTextField.inputView = paymentMethodPicker
        statusTextField.inputView = statusPicker
        paymentDateTextField.inputView = paymentDatePicker
    
        registerForKeyboardNotifications()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
            view.addGestureRecognizer(tapGesture)
    }

    @IBAction func addPaymentBtnTapped(_ sender: UIButton) {
        addPayment()
    }

    @objc private func addPayment() {
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

        guard let paymentAmountText = paymentAmountTextField.text, !paymentAmountText.isEmpty else {
            showAlert(title: "Warning", message: "Please enter a payment amount.")
            return
        }
        guard let paymentAmount = Double(paymentAmountText) else {
            showAlert(title: "Warning", message: "Invalid payment amount format.")
            return
        }
        guard paymentAmount > 0 else {
            showAlert(title: "Warning", message: "Payment amount must be greater than zero.")
            return
        }

        guard let paymentDateText = paymentDateTextField.text, !paymentDateText.isEmpty else {
            showAlert(title: "Warning", message: "Please enter a payment date.")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let paymentDate = dateFormatter.date(from: paymentDateText) else {
            showAlert(title: "Warning", message: "Invalid date format. Use yyyy-MM-dd.")
            return
        }

        guard let paymentMethodText = paymentMethodTextField.text, !paymentMethodText.isEmpty, paymentMethods.contains(paymentMethodText) else {
            showAlert(title: "Warning", message: "Please select a valid payment method.")
            return
        }

            guard let statusText = statusTextField.text, !statusText.isEmpty, statusList.contains(statusText) else {
                showAlert(title: "Warning", message: "Please select a valid status.")
                return
            }

            let directory = InsuranceDirectory.shared
            let newPaymentID = (directory.getPayments().map { $0.id }.max() ?? 0) + 1

            let newPayment = Payment(id: newPaymentID, policy_id: policyIdInt, payment_amount: paymentAmount, payment_date: paymentDate, payment_method: paymentMethodText, status: statusText)
            directory.addPayment(payment: newPayment)
            
            showAlert(title: "Success", message: "Payment added successfully.")
            print("Payment count: \(directory.getPayments().count)")
            dismissPicker()
            print("Clearing text fields and resetting pickers")
            // Clear fields
            policyIdTextField.text = ""
            paymentAmountTextField.text = ""
            paymentDateTextField.text = ""
            paymentMethodTextField.text = ""
            statusTextField.text = ""
            policyPicker.selectRow(0, inComponent: 0, animated: false)
            paymentMethodPicker.selectRow(0, inComponent: 0, animated: false)
            statusPicker.selectRow(0, inComponent: 0, animated: false)
            if !policyList.isEmpty {
                policyIdTextField.text = "\(policyList[0].id)"
            }
            paymentMethodTextField.text = paymentMethods[0]
            statusTextField.text = statusList[0]
        }

        // MARK: - UIPickerViewDelegate and UIPickerViewDataSource

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == policyPicker {
            return policyList.count
        } else if pickerView == paymentMethodPicker {
            return paymentMethods.count
        } else if pickerView == statusPicker {
            return statusList.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == policyPicker {
            return "\(policyList[row].id)"
        } else if pickerView == paymentMethodPicker {
            return paymentMethods[row]
        } else if pickerView == statusPicker {
            return statusList[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == policyPicker {
            policyIdTextField.text = "\(policyList[row].id)"
        } else if pickerView == paymentMethodPicker {
            paymentMethodTextField.text = paymentMethods[row]
        } else if pickerView == statusPicker {
            statusTextField.text = statusList[row]
        }
    }

    // MARK: - Keyboard Handling

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
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Set the desired date format
        paymentDateTextField.text = dateFormatter.string(from: sender.date) // Update the text field with the selected date
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
