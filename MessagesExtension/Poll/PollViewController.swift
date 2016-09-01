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
    private var optionsSection = Section("Options")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleSection = Section()
        form.append(titleSection)

        titleRow.title = "Title"
        titleRow.placeholder = "Enter text here"
        titleRow.onChange({ [unowned self] row in
            self.updatePoll()
        })
        titleSection.append(titleRow)

        form.append(optionsSection)
        optionsSection.append(DateRow() { row in
            row.title = "Date Row"
            row.value = Date(timeIntervalSinceReferenceDate: 0)
        })
        optionsSection.append(ButtonRow() { row in
            row.title = "Add option"
            row.onCellSelection({ [unowned self] cell, row in
                self.optionsSection.insert(DateRow() { row in
                    row.title = "Date Row"
                    row.value = Date(timeIntervalSinceReferenceDate: 0)
                }, at:self.optionsSection.count - 1)
            })
        })
        let buttonSection = Section()
        form.append(buttonSection)
        buttonSection.append(ButtonRow() { row in
            row.title = "Create Poll"
            row.onCellSelection({ [unowned self] cell, row in
                self.createPoll()
            })
        })
    }

    private func updatePoll() {
        pollForm.title = titleRow.value

        pollForm.options.removeAll()
        for row in optionsSection {
            if let dateRow = row as? DateRow, let dateRowValue = dateRow.value {
                pollForm.options.append(.date(dateRowValue))
            }
        }

        delegate?.pollViewController(pollViewController: self, didUpdatePollForm: pollForm)
    }

    private func createPoll() {
        delegate?.pollViewController(pollViewController: self, didCreatePollForm: pollForm)
    }
}
