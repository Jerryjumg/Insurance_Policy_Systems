# Insurance Policy System

## Overview
This is an iOS application. The project implements an Insurance Policy System that allows users to manage Customers, Insurance Policies, Claims, and Payments using a user-friendly interface built with Interface Builder (IB) and Storyboard.

## Features
### Customer Management
- **Add Customer:** Create a new customer with required details.
- **Update Customer:** Modify customer's name and age.
- **Delete Customer:** Customers with active insurance policies cannot be deleted.
- **View All Customers:** Display a list of all customers using a `UITableViewController`.

### Insurance Policy Management
- **Add Insurance Policy:** Create a new policy and associate it with a customer.
- **Update Insurance Policy:** Modify policy type, premium amount, and end date.
- **Delete Insurance Policy:** Active policies cannot be deleted.
- **View All Insurance Policies:** Display a list of policies.

### Claims Management
- **Add Claim:** Create a claim for an existing policy.
- **Update Claim:** Modify claim amount and status.
- **Delete Claim:** Approved claims cannot be deleted.
- **View All Claims:** Display all claims associated with policies.

### Payments Management
- **Add Payment:** Record a payment for a policy.
- **Update Payment:** Modify payment amount, status, and payment method.
- **Delete Payment:** Processed payments cannot be deleted.
- **View All Payments:** Display all payments related to policies.

## Technologies Used
- **Swift (UIKit)** for application logic and UI development.
- **Interface Builder & Storyboard** for UI design.
- **UITableViewController** for displaying lists.
- **CoreData/UserDefaults** (if applicable) for data persistence.

## UI/UX Implementation
- Segues used for screen transitions.
- `UIDatePicker` for selecting policy and claim dates.
- `UIAlertController` for form validation and error handling.
- Appropriate keyboard types for numeric fields.

## Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/insurance-policy-system.git
   ```
2. Open the project in Xcode.
3. Build and run the app using an iOS simulator or a physical device.
4. Test CRUD operations for Customers, Policies, Claims, and Payments.

## Constraints & Considerations
- Customers with active policies cannot be deleted.
- Policies marked as "Active" cannot be deleted.
- Claims that are "Approved" cannot be deleted.
- Payments marked as "Processed" cannot be deleted.
- Proper validation and error handling implemented.

## Demo Data
- The app is preloaded with test data for demonstration purposes.

## Author
Jieyu Zheng

## License
This project is for educational purposes only and is not intended for commercial use.

