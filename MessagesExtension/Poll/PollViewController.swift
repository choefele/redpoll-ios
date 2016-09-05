//
//  CreatePollViewController.swift
//  Redpoll
//
//  Created by Claus Höfele on 28.08.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import UIKit
import XLForm

protocol PollViewControllerDelegate: class {
    func pollViewController(pollViewController: PollViewController, didUpdatePollForm pollForm: PollForm)
    func pollViewController(pollViewController: PollViewController, didCreatePollForm pollForm: PollForm)
}

class PollViewController: XLFormViewController {
    weak var delegate: PollViewControllerDelegate?

    fileprivate let titleRow: XLFormRowDescriptor
    fileprivate let optionsSection: XLFormSectionDescriptor
    
    required init!(coder aDecoder: NSCoder!) {
        let titleSection = XLFormSectionDescriptor.formSection(withTitle: "Title")
        titleRow = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeTextView)
        titleRow.cellConfig.setObject("E.g. \"What should we eat for dinner?\" ", forKey: NSString(string: "textView.placeholder"))
        titleRow.cellConfig.setObject(NSNumber(value: 140), forKey: NSString(string: XLFormTextViewMaxNumberOfCharacters))
        titleRow.isRequired = true
        titleSection.addFormRow(titleRow)
        
        optionsSection = XLFormSectionDescriptor.formSection(withTitle: "Options", sectionOptions: [.canReorder, .canInsert, .canDelete], sectionInsertMode: .button)
        optionsSection.multivaluedAddButton?.title = "Add Option"
        let optionsRow = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeName)
        optionsSection.multivaluedRowTemplate = optionsRow
        
        let buttonSection = XLFormSectionDescriptor()
        let buttonRow = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeButton, title: "Create Poll")
        buttonRow.action.formSelector = #selector(createPoll)
        buttonSection.addFormRow(buttonRow)

        super.init(coder: aDecoder)
        
        form = XLFormDescriptor(title: "Poll")
        form.addFormSection(titleSection)
        form.addFormSection(optionsSection)
        form.addFormSection(buttonSection)
    }
    
    @objc private func createPoll(sender: XLFormRowDescriptor) {
        deselectFormRow(sender)
        
        let pollForm = exportFormValues()
        delegate?.pollViewController(pollViewController: self, didCreatePollForm: pollForm)
    }
    
    fileprivate func exportFormValues() -> PollForm {
        var pollForm = PollForm()
        pollForm.title = titleRow.value as? String
        
        pollForm.options.removeAll()
        for row in optionsSection.formRows {
            guard let formRowDescriptor = row as? XLFormRowDescriptor else { continue }
            
            if formRowDescriptor.rowType == XLFormRowDescriptorTypeName,
                let stringOption = formRowDescriptor.value as? String {
                if !stringOption.isEmpty {
                    pollForm.options.append(.string(stringOption))
                }
            }
        }
        
        return pollForm
    }
    
    func importFormValues(pollForm: PollForm?) {
        guard let pollForm = pollForm else { return }
        
        titleRow.value = pollForm.title
        
        for option in pollForm.options {
            switch option {
            case .string(let stringValue):
                let formRowDescriptor = formRowFormMultivaluedFormSection(optionsSection)!
                formRowDescriptor.value = stringValue
                optionsSection.addFormRow(formRowDescriptor)
            }
        }
    }
}

extension PollViewController {
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
    }
    
    override func formRowHasBeenAdded(_ formRow: XLFormRowDescriptor!, at indexPath: IndexPath!) {
        super.formRowHasBeenAdded(formRow, at: indexPath)
        
        updatePoll()
    }
    
    override func formRowHasBeenRemoved(_ formRow: XLFormRowDescriptor!, at indexPath: IndexPath!) {
        super.formRowHasBeenRemoved(formRow, at: indexPath)
        
        updatePoll()
    }
    
    override func formRowDescriptorValueHasChanged(_ formRow: XLFormRowDescriptor!, oldValue: Any!, newValue: Any!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        
        updatePoll()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        super.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        
        updatePoll()
    }
    
    private func updatePoll() {
        let pollForm = exportFormValues()
        delegate?.pollViewController(pollViewController: self, didUpdatePollForm: pollForm)
    }
}
