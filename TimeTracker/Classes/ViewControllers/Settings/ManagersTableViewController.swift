//
//  ManagersTableViewController.swift
//  TimeTracker
//
//  Created by Sergiy Loza on 12.09.17.
//  Copyright © 2017 Sergiy Loza. All rights reserved.
//

import UIKit
import CoreData

class ManagerCell: UITableViewCell {
    
    @IBOutlet weak var firstNameLabel:UILabel!
    @IBOutlet weak var lastNameLabel:UILabel!
    
    func fill(with manager:Manager) {
        firstNameLabel.text = manager.firstName
        lastNameLabel.text = manager.lastName
    }
}

class ManagersTableViewController: UITableViewController {
    
    lazy var fetchController:NSFetchedResultsController<Manager> = {
        return database.createManagersController
    }()()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchController.delegate = self
        try? fetchController.performFetch()
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManagerCell
        let manager = fetchController.object(at: indexPath)
        cell.fill(with: manager)
        return cell
    }
 
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let manager = fetchController.object(at: indexPath)
//        database.createProject(with: "Test", and: manager)
//    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let manager = fetchController.object(at: indexPath)
            database.delete(manager: manager)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cteateManager" {
            segue.destination.modalPresentationStyle = .popover
            segue.destination.popoverPresentationController?.delegate = self
        }
    }

}

extension ManagersTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension ManagersTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
