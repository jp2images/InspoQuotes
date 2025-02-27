//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController /*,SKPaymentTransactionObserver*/ {
    let productId = "dev.jeffpatterson.inspoQuotes.PremiumQuotes"
    
    var quotesToShow = [ /// This array is a var becasue we will be add the premium quotes to it if the user purchases more.
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// When this is setup and there are changes to the payment then this gets called and it will call
        /// the func paymentQueue to handle the purchase.
        ///SKPaymentQueue.default().add(self) /// Set this class as the observer of the payment queue.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Rows to show:\(quotesToShow.count)")
        /// Dynamically return the number of rows that we are planning to show.
        return quotesToShow.count + 1
    }
    
    
    /// This is the method that populates the cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// The reuseIdentifier is the "default" identifier that was set in the storyboard. Change this to the
        /// identifier that was set in the storyboard. QuoteCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        /// Added one additional cell row to the count list in tableView(numberOfRowsInSection)
        /// we will use this extra row to add a custom cell with a buy more quotes option.
        if indexPath.row < quotesToShow.count {
            // Configure the cell...
            /// This numberOfLines property is set to 0 so that the text can wrap around to the next line.
            cell.textLabel?.numberOfLines = 0
            /// For each item in the quotes to show array we fill a new row to the table with the indexed quote.
            content.text = quotesToShow[indexPath.row]
        } else {
            content.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
            content.textProperties.alignment = .center
            content.textProperties.color = .systemBlue
            content.text = "Buy more quotes"
            
            /// Add an icon indicating that the cell will take the user to a new location. (Purchase)
            cell.accessoryType = .disclosureIndicator
        }
        cell.contentConfiguration = content
        return cell
    }
    
    
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Clicking on the last cell row, the one with the "But more,,," will equal the cell count.
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        /// Deslect the row to make it look more natural like a PB
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    // MARK: - In-App Purchase Methods
    
    /// This MUST be tested on a Physical device! It will not work on the simulator.
    func buyPremiumQuotes() {
        // if SKPaymentQueue.canMakePayments() {
        if AppStore.canMakePayments {
            /// Can make payments
            print("Making a purchase")
            /// TODO: 'SKMutablePayment' was deprecated in iOS 18.0: Use Product.purchase(confirmIn:options:)
            let payment1 = SKMutablePayment()
            payment1.productIdentifier = productId
            /// TODO: 'add' was deprecated in iOS 18.0: Use Product.purchase(confirmIn:options:)
            SKPaymentQueue.default().add(payment1)
        } else{
            // Can't make payments
            print("User can't make payments")
        }
    }
    
    /// TODO: 'SKPaymentTransactionObserver' was deprecated in iOS 18.0: Use StoreKit 2 Transaction APIs
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    /// TODO: 'SKPaymentTransaction' was deprecated in iOS 18.0: Use PurchaseResult from Product.purchase(confirmIn:options:)
        for transaction in transactions {
            print("Transaction state \(transaction.transactionState)")
            if transaction.transactionState == .purchased {
                // User payment successful
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Transaction successful!")
                showPremiumQuotes()
            } else if transaction.transactionState == .failed {
                // User payment failed
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumQuotes() {
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData() /// Reload the table view with the new quotes.
                               /// Calls the 2 methods: numberOfRowsInSection and cellForRowAt
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        buyPremiumQuotes()
    }
}
