//
//  viewPaymentViewController.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/31/24.
//

import UIKit

class viewPaymentViewController: UITableViewController {
    private var paymentList = InsuranceDirectory.shared.getPayments()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Register custom cell
        tableView.register(PaymentTableViewCell.self, forCellReuseIdentifier: "PaymentCell")

        // Set up notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(paymentDataChanged), name: Notification.Name("PaymentDataUpdated"), object: nil)
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func paymentDataChanged() {
        paymentList = InsuranceDirectory.shared.getPayments()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentList.isEmpty ? 1 : paymentList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if paymentList.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "NoDataCell")
            cell.textLabel?.text = "No payments found."
            cell.textLabel?.textAlignment = .center
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as? PaymentTableViewCell else {
            return UITableViewCell()
        }

        let payment = paymentList[indexPath.row]
        cell.configure(with: payment)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !paymentList.isEmpty else { return }
        let selectedPayment = paymentList[indexPath.row]
        performSegue(withIdentifier: "viewPaymentScreen", sender: selectedPayment)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewPaymentScreen",
           let paymentDetailVC = segue.destination as? UpdatePaymentViewController,
           let payment = sender as? Payment {
            paymentDetailVC.payment = payment
        }
    }
}

class PaymentTableViewCell: UITableViewCell {
    private let idLabel = UILabel()
    private let policyIdLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    private let methodLabel = UILabel()
    private let statusLabel = UILabel()
    private let policyTypeLabel = UILabel() // New label for Policy Type
    private let policyStartDateLabel = UILabel() // New label for Policy Start Date
    private let policyEndDateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [idLabel, policyIdLabel, amountLabel, dateLabel, methodLabel, statusLabel, policyTypeLabel, policyStartDateLabel, policyEndDateLabel])
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

    func configure(with payment: Payment) { // Assuming a Payment model
        idLabel.text = "Payment ID: \(payment.id)"
        policyIdLabel.text = "Policy ID: \(payment.policy_id)"
        amountLabel.text = String(format: "Amount: $%.2f", payment.payment_amount)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Date: \(formatter.string(from: payment.payment_date))"
        
        methodLabel.text = "Method: \(payment.payment_method)"
        statusLabel.text = "Status: \(payment.status)"
        
        if let policy = InsuranceDirectory.shared.getInsurancePolicy(id: payment.policy_id) {
            policyTypeLabel.text = "Policy Type: \(policy.policy_type)"
            policyStartDateLabel.text = "Policy Start Date: \(formatter.string(from: policy.start_date))"
            policyEndDateLabel.text = "Policy End Date: \(formatter.string(from: policy.end_date))"
               } else {
                   // Handle the case where the policy is not found
                   policyTypeLabel.text = "Policy Type: Not found"
                   policyStartDateLabel.text = "Policy Start Date: Not found"
                   policyEndDateLabel.text = "Policy End Date: Not found"
               }
    }
}
