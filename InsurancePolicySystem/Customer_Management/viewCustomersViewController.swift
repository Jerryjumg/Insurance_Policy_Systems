
import UIKit

class viewCustomersViewController: UITableViewController {
    private var customerList = InsuranceDirectory.shared.getCustomers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom cell
        tableView.register(CustomerTableViewCell.self, forCellReuseIdentifier: "CustomerCell")
        
        // Set up notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(customerDataChanged), name: Notification.Name("CustomerDataUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func customerDataChanged() {
        customerList = InsuranceDirectory.shared.getCustomers()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerList.isEmpty ? 1 : customerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if customerList.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "NoDataCell")
            cell.textLabel?.text = "No customers found."
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as? CustomerTableViewCell else {
            return UITableViewCell()
        }
        
        let customer = customerList[indexPath.row]
        cell.configure(with: customer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !customerList.isEmpty else { return }
        let selectedCustomer = customerList[indexPath.row]
        performSegue(withIdentifier: "viewCustomerScreen", sender: selectedCustomer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewCustomerScreen",
           let updateCustomerVC = segue.destination as? UpdateCustomerViewController,
           let customer = sender as? Customer {
            updateCustomerVC.user = customer
        }
    }
}


class CustomerTableViewCell: UITableViewCell {
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let emailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [idLabel, nameLabel, ageLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with customer: Customer) {
        idLabel.text = "ID: \(customer.id)"
        nameLabel.text = "Name: \(customer.name)"
        ageLabel.text = "Age: \(customer.age)"
        emailLabel.text = "Email: \(customer.email)"
    }
}
