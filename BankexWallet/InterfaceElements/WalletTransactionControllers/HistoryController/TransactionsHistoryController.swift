//
//  TransactionsHistoryController.swift
//  BankexWallet
//
//  Created by Korovkina, Ekaterina on 3/4/2561 BE.
//  Copyright © 2561 Alexander Vlasov. All rights reserved.
//

import UIKit

class TransactionsHistoryController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    TransactionsHistoryViewInput {
    
    // MARK: empty View
    @IBOutlet weak var emptyViewButton: UIButton!
    @IBOutlet weak var emptyViewLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: tableView
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: additional items
    @IBOutlet weak var addTransactionButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Non-view vars
    var transactionsToShow: [Any]?
    var presenter: TransactionsHistoryViewOutput!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isHidden = true
        emptyView.isHidden = true
        addTransactionButton.isHidden = true
        activityIndicator.startAnimating()
        presenter.viewIsReady()
    }
    
    // MARK: Update view status
    var canSendTransactions = false
    func showEmptyView() {
        canSendTransactions = true
        emptyView.isHidden = false
        tableView.isHidden = true
        addTransactionButton.isHidden = false
        activityIndicator.stopAnimating()
        emptyViewLabel.text = NSLocalizedString("You don't have any transactions yet", comment: "")
        emptyViewButton.setTitle("Send money", for: .normal)
        emptyViewButton.addTarget(self, action: #selector(showSendEth), for: .touchUpInside)

    }
    
    func showNoKeysAvailableView() {
        canSendTransactions = false
        emptyView.isHidden = false
        tableView.isHidden = true
        addTransactionButton.isHidden = true
        activityIndicator.stopAnimating()
        emptyViewLabel.text = NSLocalizedString("You don't have any keys yet", comment: "")
        emptyViewButton.setTitle("Add key", for: .normal)
        emptyViewButton.addTarget(self, action: #selector(showAddNewKeyController), for: .touchUpInside)
    }
    
    func show(transactions: [Any]) {
        canSendTransactions = true
        addTransactionButton.isHidden = false
        emptyView.isHidden = true
        tableView.isHidden = false
        activityIndicator.stopAnimating()
        transactionsToShow = transactions
        tableView.reloadData()
    }
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsToShow?.count ?? 0
    }
    
    let identifier = "TransactionHistoryCell"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TransactionHistoryCell
        guard let transaction = transactionsToShow?[indexPath.row] else {return cell}
        cell.configure(withTransaction: transaction)
        return cell
    }
    
    var selectedTransaction: SendEthTransaction?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let transaction = transactionsToShow?[indexPath.row] as? SendEthTransaction else {return}
        
        selectedTransaction = transaction
        performSegue(withIdentifier: "showSendTransactions", sender: self)

    }
    
    // MARK:
    @objc func showSendEth() {
        performSegue(withIdentifier: "showSendTransactions", sender: self)
    }
    
    @objc func showAddNewKeyController() {
        if canSendTransactions {
            performSegue(withIdentifier: "showSendTransactions", sender: self)
        }
        else {
            performSegue(withIdentifier: "addNewKey", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSendTransactions",
            let transaction = selectedTransaction,
            let navController = segue.destination as? UINavigationController,
            let controller = navController.viewControllers.first as? TokenTransferContainerController {
            controller.selectedTransaction = transaction
            selectedTransaction = nil
        }
    }
}
