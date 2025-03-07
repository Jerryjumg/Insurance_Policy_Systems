//
//  viewClaimViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/31/24.
//

import UIKit

class viewClaimViewController: UITableViewController {
    private var claimList = InsuranceDirectory.shared.getClaims() //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Claim List: \(claimList)")
        tableView.reloadData()

        // Register custom cell
        tableView.register(ClaimTableViewCell.self, forCellReuseIdentifier: "ClaimCell")

        // Set up notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(claimDataChanged), name: Notification.Name("ClaimDataUpdated"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func claimDataChanged() {
        claimList = InsuranceDirectory.shared.getClaims()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return claimList.isEmpty ? 1 : claimList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if claimList.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "NoDataCell")
            cell.textLabel?.text = "No claims found."
            cell.textLabel?.textAlignment = .center
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClaimCell", for: indexPath) as? ClaimTableViewCell else {
            return UITableViewCell()
        }

        let claim = claimList[indexPath.row]
        cell.configure(with: claim)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !claimList.isEmpty else { return }
        let selectedClaim = claimList[indexPath.row]
        performSegue(withIdentifier: "viewClaimScreen", sender: selectedClaim)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewClaimScreen",
           let claimDetailVC = segue.destination as? UpdateClaimViewController,
           let claim = sender as? Claim {
            claimDetailVC.claim = claim
        }
    }
}

class ClaimTableViewCell: UITableViewCell {
    private let idLabel = UILabel()
    private let policyIdLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusLabel = UILabel()
    private let policyTypeLabel = UILabel() // New label
    private let policyStartDateLabel = UILabel() // New label
    private let policyEndDateLabel = UILabel() // New label


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [idLabel, policyIdLabel, amountLabel, dateLabel, statusLabel,policyTypeLabel, policyStartDateLabel, policyEndDateLabel])
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

    func configure(with claim: Claim) {
        print("Configuring cell with claim: \(claim)")
        idLabel.text = "Claim ID: \(claim.id)"
        policyIdLabel.text = "Policy ID: \(claim.policy_id)"
        amountLabel.text = String(format: "Claim Amount: $%.2f", claim.claim_amount)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Date of Claim: \(formatter.string(from: claim.date_of_claim))"
        statusLabel.text = "Status: \(claim.status)"
        
        if let policy = InsuranceDirectory.shared.getInsurancePolicy(id: claim.policy_id) {
            policyTypeLabel.text = "Policy Type: \(policy.policy_type)"
            policyStartDateLabel.text = "Policy Start Date: \(formatter.string(from: policy.start_date))"
            policyEndDateLabel.text = "Policy End Date: \(formatter.string(from: policy.end_date))"
              } else {
                  policyTypeLabel.text = "Policy Type: N/A"
                  policyStartDateLabel.text = "Policy Start Date: N/A"
                  policyEndDateLabel.text = "Policy End Date: N/A"
              }
        
    }
}
