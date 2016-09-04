//
//  CreatePollViewController.swift
//  Redpoll
//
//  Created by Claus Höfele on 28.08.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import UIKit
import XLForm

protocol PollViewControllerDelegate2: class {
    func pollViewController(pollViewController: PollViewController2, didUpdatePollForm pollForm: PollForm)
    func pollViewController(pollViewController: PollViewController2, didCreatePollForm pollForm: PollForm)
}

class PollViewController2: XLFormViewController {
    weak var delegate: PollViewControllerDelegate2?

    fileprivate var pollForm = PollForm()
    fileprivate let titleRow: XLFormRowDescriptor
    fileprivate let optionsSection: XLFormSectionDescriptor
    
    required init!(coder aDecoder: NSCoder!) {
        let titleSection = XLFormSectionDescriptor()
        titleRow = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeText, title: "Title")
        titleRow.cellConfig.setObject("Title", forKey: NSString(string: "textField.placeholder"))
        titleRow.cellConfig.setObject(NSNumber(value: NSTextAlignment.right.rawValue), forKey: NSString(string: "textField.textAlignment"))
        titleRow.isRequired = true
        titleSection.addFormRow(titleRow)
        
        optionsSection = XLFormSectionDescriptor.formSection(withTitle: "Options", sectionOptions: [.canReorder, .canInsert, .canDelete], sectionInsertMode: .button)
        optionsSection.multivaluedAddButton?.title = "Add New Option"
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
        
        delegate?.pollViewController(pollViewController: self, didCreatePollForm: pollForm)
    }
}

extension PollViewController2 {
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
        
        print(pollForm)
        delegate?.pollViewController(pollViewController: self, didUpdatePollForm: pollForm)
    }
}
