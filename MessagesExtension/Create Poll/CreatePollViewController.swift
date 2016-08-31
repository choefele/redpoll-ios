//
//  CreatePollViewController.swift
//  Redpoll
//
//  Created by Claus Höfele on 28.08.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import UIKit
import Eureka

protocol CreatePollViewControllerDelegate: class {
    func createPollViewController(createPollViewController: CreatePollViewController, didUpdatePollForm pollForm: PollForm)
    func createPollViewController(createPollViewController: CreatePollViewController, didCreatePollForm pollForm: PollForm)
    func createPollViewControllerDidCancel(createPollViewController: CreatePollViewController)
}

class CreatePollViewController: FormViewController {
    weak var delegate: CreatePollViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let section0 = Section("Section1")
        form.append(section0)
        section0.append(TextRow() { row in
            row.title = "Text Row"
            row.placeholder = "Enter text here"
        })
        section0.append(PhoneRow() {
            $0.title = "Phone Row"
            $0.placeholder = "And numbers here"
        })
        
        let section1 = Section("Section1")
        form.append(section1)
        section1.append(DateRow() {
            $0.title = "Date Row"
            $0.value = Date(timeIntervalSinceReferenceDate: 0)
        })
    }
}
