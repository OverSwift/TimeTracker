//
//  TrackingsViewController.swift
//  TimeTracker
//
//  Created by Sergiy Loza on 12.09.17.
//  Copyright © 2017 Sergiy Loza. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /// Try to find controller of given type in navigation stack
    ///
    /// - Returns: controller of given type on nil if not found
    func findController<T: UIViewController>() -> T? {
        for vc in self.viewControllers {
            if let toFind = vc as? T {
                return toFind
            }
        }
        return nil
    }
}

extension UIViewController {
    
    func findChild<T: UIViewController>() -> T {
        let child = self.childViewControllers.first { (vc) -> Bool in
            return vc is T
        }
        return child as! T
    }
}

class TrackingsViewController: UIViewController {

    lazy var timeTrakingsTable: TrackingsTableViewController = {
        let vc = self.findChild() as TrackingsTableViewController
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createTrack" {
            segue.destination.modalPresentationStyle = .popover
            segue.destination.popoverPresentationController?.delegate = self
        }
    }
}

extension TrackingsViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
