//
//  ViewController.swift
//  iQuiz
//
//  Created by Kyle Wistrand on 10/28/18.
//  Copyright © 2018 Kyle Wistrand. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    var appData = AppData.shared
    var swiftTimer = Timer()

    @IBOutlet weak var categoriesTable: UITableView!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appData.quizController.reset(indexPath.row)
        
        self.performSegue(withIdentifier: "toQuestion", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appData.quizController = QuizController(quizCategories: ["No Categories"])
        
        if UserDefaults.standard.object(forKey: "categoriesOnlineRaw") == nil {
            print("No quiz loaded yet")
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toSettings", sender: nil)
            }
        } else {
            let decoded = UserDefaults.standard.object(forKey: "categoriesOnlineRaw") as! Data
            var decodedCategories : [QuizCategory]
            do {
                decodedCategories = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [QuizCategory.self, QuizQuestion.self, NSArray.self], from: decoded) as! [QuizCategory]
            } catch {
                decodedCategories = [QuizCategory()]
            }
            appData.quizController.quiz.categories = decodedCategories
            
            categoriesTable.dataSource = appData.quizController.categoryDataSource
            categoriesTable.delegate = self
            
            swiftTimer.invalidate()
            
            if UserDefaults.standard.object(forKey: "updateTime") == nil {
                UserDefaults.standard.set(10, forKey: "updateTime")
            }
            
            swiftTimer = Timer.scheduledTimer(withTimeInterval: UserDefaults.standard.object(forKey: "updateTime") as! Double * 60.0, repeats: true, block: { (Timer) in
                self.timerEnd()
            })
        }
    }
    
    func timerEnd() {
        print("Updating quiz at \(NSDate())")
        
        guard let url = URL(string: UserDefaults.standard.string(forKey: "quizURL")!) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200 {
                guard let data = data else { return }
                
                do {
                    let categoriesOnline = try JSONDecoder().decode([QuizCategory].self, from: data)
                    
                    let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: categoriesOnline, requiringSecureCoding: false)
                    UserDefaults.standard.set(encodedData, forKey: "categoriesOnlineRaw")
                    
                    let decoded = UserDefaults.standard.object(forKey: "categoriesOnlineRaw") as! Data
                    var decodedCategories : [QuizCategory]
                    do {
                        decodedCategories = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [QuizCategory.self, QuizQuestion.self, NSArray.self], from: decoded) as! [QuizCategory]
                    } catch {
                        decodedCategories = [QuizCategory()]
                    }
                    self.appData.quizController.quiz.categories = decodedCategories
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            
            }.resume()
    }


}

