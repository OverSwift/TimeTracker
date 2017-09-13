//
//  ProjectsTableViewController.swift
//  TimeTracker
//
//  Created by Sergiy Loza on 13.09.17.
//  Copyright © 2017 Sergiy Loza. All rights reserved.
//

import UIKit
import CoreData

class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var managerName: UILabel!
    @IBOutlet weak var activeTasks: UILabel!
    @IBOutlet weak var doneTasks: UILabel!
    @IBOutlet weak var avarageTaskTime: UILabel!
    @IBOutlet weak var reportedTime: UILabel!
    @IBOutlet weak var unreportedTime: UILabel!
    
    func fill(with project:Project) {
        projectName.text = project.name ?? "No Name"
        managerName.text = project.manager!.firstName! + " " + project.manager!.lastName!
    }
    
}

class ProjectsTableViewController: UITableViewController {

    let controller = database.createProjectsFetchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
        try? controller.performFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return controller.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return controller.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProjectCell
        let project = controller.object(at: indexPath)
        cell.fill(with: project)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let project = controller.object(at: indexPath)
            database.delete(project: project)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cteateProject" {
            segue.destination.modalPresentationStyle = .popover
            segue.destination.popoverPresentationController?.delegate = self
        }
    }
}

extension ProjectsTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension ProjectsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
