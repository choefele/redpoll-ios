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

    private var pollForm = PollForm()
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
        form = XLFormDescriptor(title: "Form")
        
        let titleSection = XLFormSectionDescriptor()
        let titleRow = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeText)
        titleRow.cellConfig.setObject("Title", forKey: NSString(string: "textField.placeholder"))
        titleRow.isRequired = true
        titleSection.addFormRow(titleRow)
        form.addFormSection(titleSection)
        
        let optionsSection = XLFormSectionDescriptor.formSection(withTitle: "Options", sectionOptions: [.canReorder, .canInsert, .canDelete], sectionInsertMode: .button)
        optionsSection.multivaluedAddButton?.title = "Add New Option"
        let optionsRow = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeName)
        optionsSection.multivaluedRowTemplate = optionsRow
        form.addFormSection(optionsSection)
        
        let buttonSection = XLFormSectionDescriptor()
        let buttonRow = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeButton, title: "Create Poll")
        buttonRow.action.formSelector = #selector(createPoll)
        buttonSection.addFormRow(buttonRow)
        form.addFormSection(buttonSection)
    }
    
    private func updatePoll() {

        delegate?.pollViewController(pollViewController: self, didUpdatePollForm: pollForm)
    }

    @objc private func createPoll(sender: XLFormRowDescriptor) {
        deselectFormRow(sender)
        delegate?.pollViewController(pollViewController: self, didCreatePollForm: pollForm)
    }
    
}
