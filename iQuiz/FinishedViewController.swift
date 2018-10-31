//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Kyle Wistrand on 10/31/18.
//  Copyright © 2018 Kyle Wistrand. All rights reserved.
//

import UIKit

class FinishedViewController: UIViewController {
    var appData = AppData.shared
    
    @IBOutlet weak var resultOverview: UILabel!
    @IBOutlet weak var numCorrectLabel: UILabel!
    @IBOutlet weak var numTotalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentCategory = appData.quizController.categoryDataSource.quiz.categories[appData.quizController.currentCategory]
        var totalCorrect = 0
        
        for (index, answer) in appData.quizController.answers.enumerated() {
            if answer == currentCategory.questions[index].answer {
                totalCorrect += 1
            }
        }
        
        numCorrectLabel.text = String(totalCorrect)
        numTotalLabel.text = String(currentCategory.questions.count)
        
        let percentageCorrect = Double(totalCorrect) / Double(currentCategory.questions.count)
        
        if percentageCorrect == 1.0 {
            resultOverview.text = "Perfect!"
        } else if percentageCorrect < 1.0 && percentageCorrect > 0.5 {
            resultOverview.text = "Almost There!"
        } else if percentageCorrect == 0.5 {
            resultOverview.text = "Halfway There!"
        } else {
            resultOverview.text = "Try Again!"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
