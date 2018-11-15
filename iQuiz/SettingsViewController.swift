//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Kyle Wistrand on 11/12/18.
//  Copyright © 2018 Kyle Wistrand. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var quizURLBox: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var checkNowButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        
        if !isKeyPresentInUserDefaults("quizURL") ||
            UserDefaults.standard.string(forKey: "quizURL") == "" {
            let defaultURL = "http://tednewardsandbox.site44.com/questions.json"
            UserDefaults.standard.set(defaultURL, forKey: "quizURL")
        }
        
        quizURLBox.text = UserDefaults.standard.string(forKey: "quizURL") ?? ""
    }
    
    // From https://stackoverflow.com/a/40964844
    func isKeyPresentInUserDefaults(_ key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBAction func checkNow(_ sender: Any) {
        if quizURLBox.text == "" {
            let defaultURL = "http://tednewardsandbox.site44.com/questions.json"
            UserDefaults.standard.set(defaultURL, forKey: "quizURL")
        } else {
            UserDefaults.standard.set(quizURLBox.text, forKey: "quizURL")
        }
        
        NSLog("Starting data load")
        spinner.startAnimating()
        checkNowButton.isEnabled = false
        cancelButton.isEnabled = false
        let url = URL(string: UserDefaults.standard.string(forKey: "quizURL")!)
        DispatchQueue.global().async {
            // Do HTTP Request
            print(NSData(contentsOf: url!) ?? "")
            DispatchQueue.main.async {
                // HTTP finished
                self.spinner.stopAnimating()
                self.checkNowButton.isEnabled = true
                self.cancelButton.isEnabled = true
                self.performSegue(withIdentifier: "backToHome", sender: nil)
            }
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
