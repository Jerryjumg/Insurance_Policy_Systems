//
//  Model.swift
//  InsurancePolicySystem
//
//  Created by Jerry Jung on 10/29/24.
//

import Foundation
import Combine

class InsuranceDirectory: ObservableObject {
    @Published private var insurancePolicies: [InsurancePolicy]
    @Published private var customers: [Customer]
    @Published private var claims: [Claim]
    @Published private var payments: [Payment]
    
    static let shared = InsuranceDirectory()
    
    private init() {
        self.insurancePolicies = []
        self.customers = []
        self.claims = []
        self.payments = []
        prepopulate()
    }
    
    
    
    func addInsurancePolicy(insurancePolicy: InsurancePolicy) {
        if let customer = customers.first(where: { $0.id == insurancePolicy.customer_id }) {
            customer.pastPolicies = true
            self.insurancePolicies.append(insurancePolicy)
        } else {
            print("Customer not found")
        }
    }
    
    func getInsurancePolicy(id: Int) -> InsurancePolicy? {
        return insurancePolicies.first(where: { $0.id == id })
    }
    
    func addCustomer(customer: Customer) {
        self.customers.append(customer)
    }
    
    func getCustomer(id: Int) -> Customer? {
        return customers.first(where: { $0.id == id })
    }
    
    func getInsurancePolicies() -> [InsurancePolicy] {
        return insurancePolicies
    }
    
    func deleteInsurancePolicy(id: Int) -> Bool {
        // Find the index of the policy to delete
        guard let policyIndex = insurancePolicies.firstIndex(where: { $0.id == id }) else {
            print("Policy not found.")
            return false
        }

        // Get the policy to check if it's active
        let policyToDelete = insurancePolicies[policyIndex]

        // Check if the policy is active using the computed property
        if policyToDelete.isActive {
            // Handle the case where the policy cannot be deleted
            print("Active policies cannot be deleted.")
            return false
        }

        // Remove the policy from the array
        insurancePolicies.remove(at: policyIndex)
        NotificationCenter.default.post(name: Notification.Name("InsuranceDataUpdated"), object: nil)
        return true  // Deletion successful
    }


//    func deleteInsurancePolicy(id: Int) -> Bool {
//        // Find the index of the policy to delete
//        guard let policyIndex = insurancePolicies.firstIndex(where: { $0.id == id }) else {
//            print("Policy not found.")
//            return
//        }
//
//        // Get the policy to check if it's active
//        let policyToDelete = insurancePolicies[policyIndex]
//
//        // Check if the policy is active using the computed property
//        if policyToDelete.isActive {
//            // Show an alert or handle the case where the policy cannot be deleted
//            print("Active policies cannot be deleted.")
//            return
//        }
//
//        // Remove the policy from the list
//        insurancePolicies.remove(at: policyIndex)
//
//        // Notify that the data has been updated
//        NotificationCenter.default.post(name: Notification.Name("InsuranceDataUpdated"), object: nil)
//    }

    
    
    func updateInsurancePolicy(update: InsurancePolicy) {
         let index = insurancePolicies.firstIndex(where: { $0.id == update.id })!
            insurancePolicies[index].policy_type = update.policy_type
            insurancePolicies[index].premium_amount = update.premium_amount
            insurancePolicies[index].end_date = update.end_date
            NotificationCenter.default.post(name: Notification.Name("InsuranceDataUpdated"), object: nil)
    }
    
    func getCustomers() -> [Customer] {
        return customers
    }

    func updateCustomer(update: Customer) {
        let index = customers.firstIndex(where: { $0.id == update.id })!
        customers[index].name = update.name
        customers[index].age = update.age
        NotificationCenter.default.post(name: Notification.Name("CustomerDataUpdated"), object: nil)
    }

    
    func deleteCustomer(id: Int) {
//        customers.removeAll(where: { $0.id == id })
//        print(customers.count)
//        NotificationCenter.default.post(name: Notification.Name("CustomerDataUpdated"), object: nil)
        let initialCount = customers.count
           customers.removeAll(where: { $0.id == id })
           
           if customers.count < initialCount {
               print("Customer with ID \(id) deleted successfully.")
               NotificationCenter.default.post(name: Notification.Name("CustomerDataUpdated"), object: nil)
           } else {
               print("Error: Customer with ID \(id) not found.")
           }
    }
    
    // Claim methods
    func addClaim(claim: Claim) {
        if let _ = insurancePolicies.first(where: { $0.id == claim.policy_id }) {
            self.claims.append(claim)
        } else {
            print("Insurance policy not found")
        }
    }
    
    func getClaim(id: Int) -> Claim? {
        return claims.first(where: { $0.id == id })
    }
    
    func getClaims() -> [Claim] {
        return claims
    }
    
    // Delete Claim: Approved claims cannot be deleted.
//    func deleteClaim(id: Int) {
//        if let claim = claims.first(where: { $0.id == id }), claim.status != "Approved" {
//            claims.removeAll(where: { $0.id == id })
//            NotificationCenter.default.post(name: Notification.Name("ClaimDataUpdated"), object: nil)
//        } else {
//            print("Approved claims cannot be deleted")
//        }
//    }
    func deleteClaim(id: Int) -> Bool {
    if let claim = claims.first(where: { $0.id == id }), claim.status != "Approved" {
        claims.removeAll(where: { $0.id == id })
        NotificationCenter.default.post(name: Notification.Name("ClaimDataUpdated"), object: nil)
        return true  // Deletion successful
    } else {
        print("Approved claims cannot be deleted")
        return false  // Deletion failed
    }
}

    
    //Update Claim: Update claim amount and status (e.g., from 'Pending' to 'Approved' or 'Rejected').
    func updateClaim(update: Claim) {
        if let index = claims.firstIndex(where: { $0.id == update.id }) {
            claims[index].claim_amount = update.claim_amount
            claims[index].status = update.status
            NotificationCenter.default.post(name: Notification.Name("ClaimDataUpdated"), object: nil)
        }
    }
        
        // Payment Methods
        func addPayment(payment: Payment) {
            if let _ = insurancePolicies.first(where: { $0.id == payment.policy_id }) {
                self.payments.append(payment)
            } else {
                print("Insurance policy not found")
            }
        }
        
        func getPayment(id: Int) -> Payment? {
            return payments.first(where: { $0.id == id })
        }
        
        func getPayments() -> [Payment] {
            return payments
        }
        
        func deletePayment(id: Int) {
            if let payment = payments.first(where: { $0.id == id }), payment.status != "Processed" {
                payments.removeAll(where: { $0.id == id })
                NotificationCenter.default.post(name: Notification.Name("PaymentDataUpdated"), object: nil)
            } else {
                print("Confirmed payments cannot be deleted")
            }
        }
            
        func updatePayment(update: Payment) {
            if let index = payments.firstIndex(where: { $0.id == update.id }) {
                payments[index].payment_amount = update.payment_amount
                payments[index].status = update.status
                payments[index].payment_method = update.payment_method
                NotificationCenter.default.post(name: Notification.Name("PaymentDataUpdated"), object: nil)
            }
        }
        
    private func prepopulate() {
        customers.append(Customer(id: 1, name: "Jerry", age: 22, email: "jerry@gmail.com"))
        customers.append(Customer(id: 2, name: "Eve", age: 23, email: "eve@gmail.com"))
        customers.append(Customer(id: 3, name: "Qu", age: 24, email: "qu@gmail.com"))
        
        let today = Date()
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        let endDate1 = Calendar.current.date(byAdding: .day, value: 30, to: today)!
        let endDate2 = Calendar.current.date(byAdding: .day, value: 60, to: today)!
        let endDate3 = Calendar.current.date(byAdding: .day, value: 90, to: today)!
        
        addInsurancePolicy(insurancePolicy: InsurancePolicy(id: 1, customer_id: 1, policy_type: "Health", premium_amount: 1000, start_date: twoDaysAgo, end_date: endDate1))
        addInsurancePolicy(insurancePolicy: InsurancePolicy(id: 2, customer_id: 2, policy_type: "Life", premium_amount: 2000, start_date: twoDaysAgo, end_date: endDate2))
        addInsurancePolicy(insurancePolicy: InsurancePolicy(id: 3, customer_id: 3, policy_type: "Travel", premium_amount: 3000, start_date: twoDaysAgo, end_date: endDate3))
        
        // Adding sample claims
        addClaim(claim: Claim(id: 1, policy_id: 1, claim_amount: 500, date_of_claim: twoDaysAgo, status: "Pending"))
        addClaim(claim: Claim(id: 2, policy_id: 2, claim_amount: 1500, date_of_claim: twoDaysAgo, status: "Processed"))
        addClaim(claim: Claim(id: 3, policy_id: 3, claim_amount: 2500, date_of_claim: twoDaysAgo, status: "Failed"))
        
        // Adding sample payments
        addPayment(payment: Payment(id: 1, policy_id: 1, payment_amount: 1000, payment_date: twoDaysAgo, payment_method: "Credit Card", status: "Pending"))
        addPayment(payment: Payment(id: 2, policy_id: 2, payment_amount: 2000, payment_date: twoDaysAgo, payment_method: "Bank Transfer", status: "Processed"))
        addPayment(payment: Payment(id: 3, policy_id: 3, payment_amount: 3000, payment_date: twoDaysAgo, payment_method: "Credit Card", status: "Failed"))
    }
    
}
class Customer: Identifiable {
    var id : Int
    var name : String
    var age : Int
    var email : String
    var pastPolicies: Bool
    var policies: [InsurancePolicy] = []
    
    init(id: Int, name: String, age: Int, email: String) {
        self.id = id
        self.name = name
        self.age = age
        self.email = email
        self.pastPolicies = false
    }
}

class InsurancePolicy: Identifiable, ObservableObject{
    var id: Int
    var customer_id: Int
    @Published var policy_type: String
    @Published var premium_amount: Double
    @Published var start_date: Date
    @Published var end_date: Date
    
    init(id: Int, customer_id: Int, policy_type: String, premium_amount: Double, start_date: Date, end_date: Date) {
        self.id = id
        self.customer_id = customer_id
        self.policy_type = policy_type
        self.premium_amount = premium_amount
        self.start_date = start_date
        self.end_date = end_date
    }
    
    var isActive: Bool {
          let now = Date()
          return start_date <= now && end_date >= now
      }
}

class Claim: Identifiable {
    var id: Int
    var policy_id: Int
    var claim_amount: Double
    var date_of_claim: Date
    var status: String

    init(id: Int, policy_id: Int, claim_amount: Double, date_of_claim: Date, status: String) {
        self.id = id
        self.policy_id = policy_id
        self.claim_amount = claim_amount
        self.date_of_claim = date_of_claim
        self.status = status
    }
}

class Payment: Identifiable {
    var id: Int
    var policy_id: Int
    var payment_amount: Double
    var payment_date: Date
    var payment_method: String
    var status: String

    init(id: Int, policy_id: Int, payment_amount: Double, payment_date: Date, payment_method: String, status: String) {
        self.id = id
        self.policy_id = policy_id
        self.payment_amount = payment_amount
        self.payment_date = payment_date
        self.payment_method = payment_method
        self.status = status
    }
}
