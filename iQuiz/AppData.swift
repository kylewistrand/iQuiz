//
//  AppData.swift
//  iQuiz
//
//  Created by Kyle Wistrand on 10/31/18.
//  Copyright © 2018 Kyle Wistrand. All rights reserved.
//

import UIKit

class QuizQuestion {
    let text : String
    let answer : Int
    let answers : [String]
    
    init(text : String, answer : Int, answers : [String]) {
        self.text = text
        self.answer = answer
        self.answers = answers
    }
    
    init() {
        self.text = "Default Question"
        self.answer = 0
        self.answers = ["1", "2", "3", "4"]
    }
}

class QuizCategory {
    let title : String
    let desc : String
    let questions : [QuizQuestion]
    
    init(title : String, desc : String, questions : [QuizQuestion]) {
        self.title = title
        self.desc = desc
        self.questions = questions
    }
    
    init() {
        self.title = ""
        self.desc = ""
        self.questions = []
    }
}

class Quiz {
    var categories : [QuizCategory] = []
    
    init(_ categoryNames : [String]) {
        for name in categoryNames {
            self.categories.append(QuizCategory(title: name, desc: "Placeholder description", questions: [QuizQuestion(), QuizQuestion()]))
        }
    }
    
    public func getNumCategories() -> Int {
        return categories.count
    }
}

class QuizController {
    let quiz : Quiz
    let categoryDataSource : QuizCategoryDataSource
    var currentCategory : Int
    var currentQuestion : Int
    var answers : [Int]
    
    init(quizCategories : [String]) {
        self.quiz = Quiz(quizCategories)
        self.categoryDataSource = QuizCategoryDataSource(self.quiz)
        self.currentCategory = 0
        self.currentQuestion = 0
        self.answers = []
    }
    
    public func reset(_ currentCategory : Int) {
        self.currentCategory = currentCategory
        self.currentQuestion = 0
        self.answers = []
    }
}

class QuizCategoryDataSource : NSObject, UITableViewDataSource {
    let quiz : Quiz
    init(_ quiz: Quiz) {
        self.quiz = quiz
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.getNumCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CategoryTableIdentifier")
        }
        
        cell?.textLabel?.text = quiz.categories[indexPath.row].title
        cell?.detailTextLabel?.text = quiz.categories[indexPath.row].desc
        cell?.imageView?.image = [UIImage (named: "help")][0];
        
        return cell!
    }
}

class AppData: NSObject {
    static let shared = AppData()
    
    open var quizController : QuizController = QuizController(quizCategories: [])
}
