//
//  viewPolicyViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/29/24.
//
import UIKit

class viewPolicyViewController: UITableViewController {
    private var policyList = InsuranceDirectory.shared.getInsurancePolicies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom cell
        tableView.register(PolicyTableViewCell.self, forCellReuseIdentifier: "PolicyCell")
        
        // Set up notification observer for policy updates
        NotificationCenter.default.addObserver(self, selector: #selector(policyDataChanged), name: Notification.Name("InsuranceDataUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func policyDataChanged() {
        policyList = InsuranceDirectory.shared.getInsurancePolicies()
        print("Policy List Updated Count: \(policyList.count)")
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return policyList.isEmpty ? 1 : policyList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if policyList.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "NoDataCell")
            cell.textLabel?.text = "No policies found."
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PolicyCell", for: indexPath) as? PolicyTableViewCell else {
            return UITableViewCell()
        }
        
        let policy = policyList[indexPath.row]
        cell.configure(with: policy)
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !policyList.isEmpty else { return }
        let selectedPolicy = policyList[indexPath.row]
        performSegue(withIdentifier: "viewPolicyScreen", sender: selectedPolicy)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewPolicyScreen",
           let policyDetailVC = segue.destination as? UpdatePolicyViewController,
           let policy = sender as? InsurancePolicy {
            policyDetailVC.policy = policy
        }
    }
}

// Assuming you have a custom cell for displaying policies
class PolicyTableViewCell: UITableViewCell {
        private let idLabel = UILabel()
        private let customerIdLabel = UILabel()
        private let typeLabel = UILabel()
        private let premiumLabel = UILabel()
        private let startDateLabel = UILabel()
        private let endDateLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupViews()
        }
        
        private func setupViews() {
            let stackView = UIStackView(arrangedSubviews: [idLabel, customerIdLabel, typeLabel, premiumLabel, startDateLabel, endDateLabel])
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
        
        func configure(with policy: InsurancePolicy) {
            idLabel.text = "Policy ID: \(policy.id)"
            customerIdLabel.text = "Customer ID: \(policy.customer_id)"
            typeLabel.text = "Policy Type: \(policy.policy_type)"
            premiumLabel.text = "Premium Amount: $\(policy.premium_amount)"
            startDateLabel.text = "Start Date: \(dateFormatter.string(from: policy.start_date))"
            endDateLabel.text = "End Date: \(dateFormatter.string(from: policy.end_date))"
        }
        
        // Create a date formatter to format the date
        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short // Adjust the date style as needed
            return formatter
        }
    }

