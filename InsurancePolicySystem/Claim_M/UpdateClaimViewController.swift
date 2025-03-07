//
//  UpdateClaimViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/29/24.
//
import UIKit

class UpdateClaimViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet weak var policyIDTextField: UITextField!
    @IBOutlet weak var dateOfClaimTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var claimAmountTextField: UITextField!
    
    // UI Components
    private let statusPicker = UIPickerView()
    private let statusOptions = ["Pending", "Approved", "Rejected"]

    // Placeholder claim object to update
    var claim: Claim!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the UI
        policyIDTextField.text = "\(claim.policy_id)"
        // Convert Date to String using DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateOfClaimTextField.text = dateFormatter.string(from: claim.date_of_claim)
        statusTextField.text = claim.status
        claimAmountTextField.text = "\(claim.claim_amount)"
        
        // Set up the status picker
        statusPicker.delegate = self
        statusPicker.dataSource = self
        statusTextField.inputView = statusPicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
            view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UIPickerView DataSource and Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusTextField.text = statusOptions[row]
    }
    
    // MARK: - IBActions
    @IBAction func updateClaimBtnTapped(_ sender: UIButton) {
        updateClaim()
    }
    
    @IBAction func deleteClaimBtnTapped(_ sender: UIButton) {
        deleteClaim()
    }
    
    // MARK: - Private Methods
    private func updateClaim() {
        // Validate claim amount
        guard let claimAmountText = claimAmountTextField.text, !claimAmountText.isEmpty,
              let claimAmount = Double(claimAmountText) else {
            showAlert(title: "Error", message: "Please enter a valid claim amount.")
            return
        }
        
        // Validate status
        guard let status = statusTextField.text, statusOptions.contains(status) else {
            showAlert(title: "Error", message: "Please select a valid status.")
            return
        }
        
        // Update the claim details
        claim.claim_amount = claimAmount
        claim.status = status
        
        // Call your update function here (e.g., to update the claim in your data source)
        InsuranceDirectory.shared.updateClaim(update: claim)
        showAlert(title: "Success", message: "Claim updated successfully.")
    }
    
    private func deleteClaim() {
        let deletionSuccessful = InsuranceDirectory.shared.deleteClaim(id: claim.id)
        
        if deletionSuccessful {
            showAlert(title: "Success", message: "Claim deleted successfully.") { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: "Approved claim cannot be deleted.")
        }
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
