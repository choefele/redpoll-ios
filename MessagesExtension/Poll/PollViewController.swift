//
//  CreatePollViewController.swift
//  Redpoll
//
//  Created by Claus Höfele on 28.08.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import UIKit
import Eureka

protocol PollViewControllerDelegate: class {
    func pollViewController(pollViewController: PollViewController, didUpdatePollForm pollForm: PollForm)
    func pollViewController(pollViewController: PollViewController, didCreatePollForm pollForm: PollForm)
}

class PollViewController: FormViewController {
    weak var delegate: PollViewControllerDelegate?

    private var pollForm = PollForm()
    private let titleRow = TextRow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let section0 = Section()
        form.append(section0)

        titleRow.title = "Title"
        titleRow.placeholder = "Enter text here"
        titleRow.onChange({ [unowned self] row in
            self.updatePoll()
        })
        section0.append(titleRow)

        let section1 = Section("Options")
        form.append(section1)
        section1.append(DateRow() { row in
            row.title = "Date Row"
            row.value = Date(timeIntervalSinceReferenceDate: 0)
        })

        let section2 = Section()
        form.append(section2)
        section2.append(ButtonRow() { row in
            row.title = "Create Poll"
            row.onCellSelection({ [unowned self] cell, row in
                self.createPoll()
            })
        })
    }

    private func updatePoll() {
        pollForm.title = titleRow.value

        delegate?.pollViewController(pollViewController: self, didUpdatePollForm: pollForm)
    }

    private func createPoll() {
        delegate?.pollViewController(pollViewController: self, didCreatePollForm: pollForm)
    }
}
