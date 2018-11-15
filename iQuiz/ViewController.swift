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

    @IBOutlet weak var categoriesTable: UITableView!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appData.quizController.reset(indexPath.row)
        
        self.performSegue(withIdentifier: "toQuestion", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appData.quizController = QuizController(quizCategories: ["Math", "Marvel Super Heroes", "Science"])
        categoriesTable.dataSource = appData.quizController.categoryDataSource
        categoriesTable.delegate = self
    }


}

