//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Kyle Wistrand on 11/12/18.
//  Copyright © 2018 Kyle Wistrand. All rights reserved.
//

import UIKit
import SystemConfiguration

// From https://stackoverflow.com/a/39782859
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

class SettingsViewController: UIViewController {
    var appData = AppData.shared

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
        
        if UserDefaults.standard.object(forKey: "categoriesOnlineRaw") == nil {
            cancelButton.isEnabled = false
        }
    }
    
    // From https://stackoverflow.com/a/40964844
    func isKeyPresentInUserDefaults(_ key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBAction func checkNow(_ sender: Any) {
        if !Reachability.isConnectedToNetwork(){
            let alertController = UIAlertController(title: "Update Failed", message: "No Network Connection. Please try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
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
        DispatchQueue.global().async {
            // Do HTTP Request
            self.getQuestions()
        }
    }
    
    // From https://www.letsbuildthatapp.com/course_video?id=1562
    func getQuestions() {
        guard let url = URL(string: UserDefaults.standard.string(forKey: "quizURL")!) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if response == nil {
                self.error()
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode != 200 {
                self.error()
            } else {
                guard let data = data else { return }
                
                do {
                    let categoriesOnline = try JSONDecoder().decode([QuizCategory].self, from: data)
                    
                    let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: categoriesOnline, requiringSecureCoding: false)
                    UserDefaults.standard.set(encodedData, forKey: "categoriesOnlineRaw")
                    
                    DispatchQueue.main.async {
                        // HTTP finished
                        self.spinner.stopAnimating()
                        self.checkNowButton.isEnabled = true
                        self.cancelButton.isEnabled = true
                        self.performSegue(withIdentifier: "backToHome", sender: nil)
                    }
                    
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            
        }.resume()
    }
    
    func error() {
        print("ERROR: Loading Data Failed")
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.checkNowButton.isEnabled = true
            self.cancelButton.isEnabled = true
            let alertController = UIAlertController(title: "Update Failed", message: "There was a problem loading the URL you entered. Please try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
