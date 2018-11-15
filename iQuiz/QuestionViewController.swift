//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Kyle Wistrand on 10/31/18.
//  Copyright © 2018 Kyle Wistrand. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    var appData = AppData.shared
    var currentCategoty : QuizCategory = QuizCategory()
    var currentAnswer : Int = -1
    
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func answer1(_ sender: Any) {
        updateAnswer(0)
    }
    @IBAction func answer2(_ sender: Any) {
        updateAnswer(1)
    }
    @IBAction func answer3(_ sender: Any) {
        updateAnswer(2)
    }
    @IBAction func answer4(_ sender: Any) {
        updateAnswer(3)
    }
    
    func updateAnswer(_ ansNum: Int) {
        self.currentAnswer = ansNum
        submitButton.isEnabled = true
        answer1.isSelected = false
        answer2.isSelected = false
        answer3.isSelected = false
        answer4.isSelected = false
        switch self.currentAnswer {
        case 0:
            answer1.isSelected = true
            break
        case 1:
            answer2.isSelected = true
            break
        case 2:
            answer3.isSelected = true
            break
        case 3:
            answer4.isSelected = true
            break
        default:
            assert(false, "Unknown answer in QuestionViewController")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        
        currentCategoty = appData.quizController.quiz.categories[appData.quizController.currentCategory]

        questionNum.text = String(appData.quizController.currentQuestion + 1)
        questionText.text = currentCategoty.questions[appData.quizController.currentQuestion]!.text
        answer1.setTitle(currentCategoty.questions[appData.quizController.currentQuestion]!.answers[0], for: .normal)
        answer2.setTitle(currentCategoty.questions[appData.quizController.currentQuestion]!.answers[1], for: .normal)
        answer3.setTitle(currentCategoty.questions[appData.quizController.currentQuestion]!.answers[2], for: .normal)
        answer4.setTitle(currentCategoty.questions[appData.quizController.currentQuestion]!.answers[3], for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        appData.quizController.answers.append(self.currentAnswer)
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
