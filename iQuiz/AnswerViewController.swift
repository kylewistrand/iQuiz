//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Kyle Wistrand on 10/31/18.
//  Copyright © 2018 Kyle Wistrand. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    var appData = AppData.shared
    
    @IBOutlet weak var correctIncorrectLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBAction func nextButton(_ sender: Any) {
        appData.quizController.currentQuestion += 1
        if appData.quizController.currentQuestion == appData.quizController.quiz.categories[appData.quizController.currentCategory].questions.count {
            self.performSegue(withIdentifier: "toFinished", sender: self)
        } else {
            self.performSegue(withIdentifier: "nextQuestion", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = appData.quizController.quiz.categories[appData.quizController.currentCategory].questions[appData.quizController.currentQuestion]

        questionLabel.text = currentQuestion!.text
        answerLabel.text = currentQuestion!.answers[Int(currentQuestion!.answer!)! - 1]
        
        switch appData.quizController.answers[appData.quizController.currentQuestion] {
        case Int(currentQuestion!.answer!)! - 1:
            correctIncorrectLabel.text = "Correct!"
            break
        default:
            correctIncorrectLabel.text = "Incorrect..."
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
