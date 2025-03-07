import UIKit

class UpdatePaymentViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets for text fields
    @IBOutlet weak var dateOfPaymentTextField: UITextField!
    @IBOutlet weak var paymentAmountTextField: UITextField!
    @IBOutlet weak var paymentStatusTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
  
    // Variables
    var payment: Payment!
    let statusOptions = ["Pending", "Processed", "Failed"]  // Example status options
    let methodOptions = ["Credit Card", "Bank Transfer"]  // Example method options
    private var paymentStatusPickerView : UIPickerView!
    private var paymentMethodPickerView : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentStatusPickerView = UIPickerView()
        paymentMethodPickerView = UIPickerView()
      
        
        // Set up Picker Views
        paymentStatusPickerView.delegate = self
        paymentStatusPickerView.dataSource = self
        paymentMethodPickerView.delegate = self
        paymentMethodPickerView.dataSource = self
        
        // Assign pickers to text fields
        paymentStatusTextField.inputView = paymentStatusPickerView
        paymentMethodTextField.inputView = paymentMethodPickerView
        
        // Initial setup
        paymentStatusTextField.text = payment.status
        paymentMethodTextField.text = payment.payment_method
        paymentAmountTextField.text = String(payment.payment_amount)
        dateOfPaymentTextField.text = formatDate(payment.payment_date)
        
        // Set initial values for Picker Views
        if let statusIndex = statusOptions.firstIndex(of: payment.status) {
            paymentStatusPickerView.selectRow(statusIndex, inComponent: 0, animated: false)
        }
        if let methodIndex = methodOptions.firstIndex(of: payment.payment_method) {
            paymentMethodPickerView.selectRow(methodIndex, inComponent: 0, animated: false)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
            view.addGestureRecognizer(tapGesture)
    }
    
    // Update Payment Action
    @IBAction func updatePayment(_ sender: UIButton) {
        // Validate payment amount
        guard let amountText = paymentAmountTextField.text,
              let amount = Double(amountText), amount > 0 else {
            showAlert(title: "Error", message: "Please enter a valid payment amount.")
            return
        }
        
        // Get selected status and method from Picker Views
        let selectedStatus = statusOptions[paymentStatusPickerView.selectedRow(inComponent: 0)]
        let selectedMethod = methodOptions[paymentMethodPickerView.selectedRow(inComponent: 0)]
        
        // Update the payment object
        payment.payment_amount = amount
        payment.status = selectedStatus
        payment.payment_method = selectedMethod
        
        InsuranceDirectory.shared.updatePayment(update: payment)
        
        // Show success alert
        showAlert(title: "Success", message: "Payment updated successfully.")
    }
    
    // Delete Payment Action
    @IBAction func deletePayment(_ sender: UIButton) {
        // Check if payment status is 'Processed'
        if payment.status == "Processed" {
            showAlert(title: "Warning", message: "Cannot delete a payment that has been processed.")
            return
        }
        
        // Perform deletion logic here
        InsuranceDirectory.shared.deletePayment(id: payment.id)  // Example deletion
        showAlert(title: "Success", message: "Payment deleted successfully.") { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // Helper function to show alerts
    func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == paymentStatusPickerView {
            return statusOptions.count
        } else {
            return methodOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == paymentStatusPickerView {
            return statusOptions[row]
        } else {
            return methodOptions[row]
        }
    }
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update the text field based on the selected row
        if pickerView == paymentStatusPickerView {
            paymentStatusTextField.text = statusOptions[row]
        } else if pickerView == paymentMethodPickerView {
            paymentMethodTextField.text = methodOptions[row]
        }
    }

    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)  // This will dismiss the picker
    }
}
