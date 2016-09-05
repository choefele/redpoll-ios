//
//  MessagesViewController+PollViewControllerDelegate.swift
//  Redpoll
//
//  Created by Claus Höfele on 01/09/16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import Messages
import Charts

extension MessagesViewController: PollViewControllerDelegate {
    func pollViewController(pollViewController: PollViewController, didUpdatePollForm pollForm: PollForm) {
        self.pollForm = pollForm
    }

    func pollViewController(pollViewController: PollViewController, didCreatePollForm pollForm: PollForm) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }

        self.pollForm = pollForm

        let message = composeMessage(with: pollForm, caption: "Caption", session: conversation.selectedMessage?.session)
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }

        dismiss()
    }

    private func composeMessage(with pollForm: PollForm, caption: String, session: MSSession? = nil) -> MSMessage {
        let message = MSMessage(session: session ?? MSSession())

        //        var components = URLComponents()
        //        components.queryItems = iceCream.queryItems
        //        message.url = components.url!

        let layout = MSMessageTemplateLayout()
        layout.image = renderPollForm(pollForm: pollForm)
        layout.caption = caption
        message.layout = layout

        return message
    }

    private func renderPollForm(pollForm: PollForm) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 300)
        let pieChartView = PieChartView(frame: rect)
        pieChartView.holeColor = UIColor.clear
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.drawSliceTextEnabled = false
        pieChartView.legend.enabled = false // needs to happen before setting data
        
        let yVals = [BarChartDataEntry(value: 1, xIndex: 0), BarChartDataEntry(value: 2, xIndex: 1), BarChartDataEntry(value: 3, xIndex: 3)]
        let dataSet = PieChartDataSet(yVals: yVals, label: "Label")
        dataSet.colors = ChartColorTemplates.pastel()
        dataSet.selectionShift = 0
        let xVals = ["1", "2", "3"]
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        pieChartView.data = data
        
        let viewPortHandler = ChartViewPortHandler(width: rect.width, height: rect.height)
        let pieChartRenderer = PieChartRenderer(chart: pieChartView, animator: ChartAnimator(), viewPortHandler: viewPortHandler)
        
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        let image = renderer.image { context in
            pieChartRenderer.drawData(context: context.cgContext)
            pieChartRenderer.drawExtras(context: context.cgContext)
            pieChartRenderer.drawValues(context: context.cgContext)
        }
        
        return image
    }
}
