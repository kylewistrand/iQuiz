//
//  AppData.swift
//  iQuiz
//
//  Created by Kyle Wistrand on 10/31/18.
//  Copyright © 2018 Kyle Wistrand. All rights reserved.
//

import UIKit

class QuizQuestion: NSObject, NSCoding, NSSecureCoding, Decodable {
    static var supportsSecureCoding: Bool {
        get { return true }
    }
    
    let text : String?
    let answer : String?
    let answers : [String?]
    
    init(text : String, answer : String, answers : [String]) {
        self.text = text
        self.answer = answer
        self.answers = answers
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(answer, forKey: "answer")
        aCoder.encode(answers, forKey: "answers")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as? String? ?? "Default Question"
        answer = aDecoder.decodeObject(forKey: "answer") as? String? ?? "0"
        answers = aDecoder.decodeObject(forKey: "answers") as? [String?] ?? ["1", "2", "3", "4"]
    }
    
    override init() {
        self.text = "Default Question"
        self.answer = "0"
        self.answers = ["1", "2", "3", "4"]
    }
}

class QuizCategory: NSObject, NSCoding, NSSecureCoding, Decodable {
    static var supportsSecureCoding: Bool {
        get { return true }
    }
    
    let title : String?
    let desc : String?
    let questions : [QuizQuestion?]
    
    init(title : String, desc : String, questions : [QuizQuestion]) {
        self.title = title
        self.desc = desc
        self.questions = questions
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(questions, forKey: "questions")
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String? ?? ""
        desc = aDecoder.decodeObject(forKey: "desc") as? String? ?? ""
        questions = aDecoder.decodeObject(forKey: "questions") as? [QuizQuestion?] ?? []
    }
    
    override init() {
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
