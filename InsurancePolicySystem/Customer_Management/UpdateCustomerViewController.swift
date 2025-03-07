import UIKit

class UpdateCustomerViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    var user: Customer!

    @IBAction func updateCustomerBtn(_ sender: UIButton) {
        updateCustomer()
    }
    
    @IBAction func deleteCustomer(_ sender: UIButton) {
        deleteCustomer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.text = user.name
        ageTextField.text = "\(user.age)"
        emailTextField.text = user.email
    }

    @objc private func updateCustomer() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter a name")
            return
        }
        guard let ageText = ageTextField.text, !ageText.isEmpty, let age = Int(ageText) else {
            showAlert(title: "Error", message: "Please enter a valid age")
            return
        }
        let emailPattern = #"^\S+@\S+\.\S+$"#
        guard emailTextField.text?.range(of: emailPattern, options: .regularExpression) != nil else {
            showAlert(title: "Warning", message: "Invalid email format. Please enter a valid email.")
            return
        }

        InsuranceDirectory.shared.updateCustomer(update: Customer(id: user.id, name: name, age: age, email: user.email))
        showAlert(title: "Success", message: "Customer updated successfully.")
        print(InsuranceDirectory.shared.getCustomer(id: user.id)?.name ?? "default value")
        backButtonTapped()
    }
    
    
    @objc private func deleteCustomer() {
        // Check if the customer has active or past policies
        guard !user.pastPolicies else {
            showAlert(title: "Warning", message: "Can't delete customer with active/past insurance.")
            return
        }

        // Proceed to delete the customer
        InsuranceDirectory.shared.deleteCustomer(id: user.id)

        // Show success alert and pop the view controller
        showAlert(title: "Success", message: "Customer deleted successfully.") { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true, completion: nil)
    }

}
