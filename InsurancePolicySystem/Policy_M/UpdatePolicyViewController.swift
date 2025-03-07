import UIKit

class UpdatePolicyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var policyTypeTextField: UITextField!
    @IBOutlet weak var premiumTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    var policy: InsurancePolicy!
    let policyTypes = ["Health", "Travel", "Life"]
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load current policy details into text fields
        policyTypeTextField.text = policy.policy_type
        premiumTextField.text = "\(policy.premium_amount)"
        setupDatePicker()
        let policyPicker = UIPickerView()
        policyPicker.delegate = self
        policyPicker.dataSource = self
        policyTypeTextField.inputView = policyPicker
        endDateTextField.text = DateFormatter.localizedString(from:policy.end_date, dateStyle: .medium, timeStyle: .none)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
            view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func updatePolicyBtn(_ sender: UIButton) {
        updatePolicy()
    }
    
    @IBAction func deletePolicyBtn(_ sender: UIButton) {
        deletePolicy()
    }
    
    private func updatePolicy() {
        guard let policyType = policyTypeTextField.text, !policyType.isEmpty else {
            showAlert(title: "Error", message: "Please enter a valid policy type.")
            return
        }
        
        guard let premiumText = premiumTextField.text, !premiumText.isEmpty, let premiumAmount = Double(premiumText) else {
            showAlert(title: "Error", message: "Please enter a valid premium amount.")
            return
        }
        
        guard let endDateText = endDateTextField.text, !endDateText.isEmpty else {
            showAlert(title: "Error", message: "Please enter a valid end date.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        guard let endDate = dateFormatter.date(from: endDateText) else {
            showAlert(title: "Error", message: "Invalid date format. Please enter a valid end date.")
            return
        }
        
        // Ensure the end date is after the policy's start date
        guard endDate > policy.start_date else {
            showAlert(title: "Error", message: "End date must be after the start date.")
            return
        }
        
        // Create updated policy object
        let updatedPolicy = InsurancePolicy(
            id: policy.id,
            customer_id: policy.customer_id,
            policy_type: policyType,
            premium_amount: premiumAmount,
            start_date: policy.start_date,
            end_date: endDate
        )
        
        // Update the policy in the directory
        InsuranceDirectory.shared.updateInsurancePolicy(update: updatedPolicy)
        showAlert(title: "Success", message: "Policy updated successfully.")
        backButtonTapped()
    }
    
    private func deletePolicy() {
        let delectionSuccessful = InsuranceDirectory.shared.deleteInsurancePolicy(id: policy.id)
        if delectionSuccessful {
            showAlert(title: "Success", message: "Policy deleted successfully.") { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: "Active policy cannot be deleted.")
            }
      
        }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return policyTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return policyTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        policyTypeTextField.text = policyTypes[row]
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        endDateTextField.inputView = datePicker
        
        // Set the initial date to the current end date of the policy
        datePicker.date = policy.end_date
        endDateTextField.text = DateFormatter.localizedString(from: policy.end_date, dateStyle: .medium, timeStyle: .none)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        endDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)  // This will dismiss the picker
    }
    
}
