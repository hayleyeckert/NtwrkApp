//
//  ViewController.swift
//  Example
//
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Login with Linkedin
     */
    @IBAction func login() {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (success) in
            let session = LISDKSessionManager.sharedInstance().session
            
            let url = "https://api.linkedin.com/v1/people/~:(id,public-profile-url,first-name,last-name,email-address,industry,location,headline,picture-url,summary,positions:(title))?format=json"            
            
            if (LISDKSessionManager.hasValidSession()) {
                
                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) in
                    
                    print(url)
                    let dict = self.StringToDictionary(text: (response?.data)!)
 
                    let lastName = dict?["lastName"]!
                    let firstName = dict?["firstName"]!
                    let email = dict?["emailAddress"]! as! String
                    let profile = dict?["publicProfileUrl"]! as! String
                    let industry = dict?["industry"]! as! String
                    let summary = dict?["summary"] as! String
                    let location : Dictionary = dict?["location"]! as! Dictionary<String, Any>
                    let City: String = location["name"]! as! String

                    //print("Your first name is \(dict?["firstName"]!)")
                    //print("Your last name is \(dict?["lastName"]!)")
                    //print("Your email is ", email)
                    //print("Your industry is \(dict?["industry"]!)")
                    // print("Your summary is ", summary)
                    // print("Your city is ", City)
                    
                    let titlePositions : Dictionary = dict?["positions"]! as! Dictionary<String, Any>
                    var title = String()
                    if (titlePositions["_total"] as! Int != 0) {
                        let PositionObjects : Array<Dictionary> = titlePositions["values"] as! Array<Dictionary<String,Any>>
                        title = PositionObjects[0]["title"]! as! String
                        //print("Your title is ", title)
                    }
                    else {
                        title  = ""
                    }
                    
                    //let pictureUrls : Dictionary = dict?["pictureUrls"]! as! Dictionary<String, Any>
                    //print("Your photo is \(dict?["pictureUrl"]!)")
                    //let pictureArray : Array<NSObject> = pictureUrls["values"] as! Array<NSObject>
                    //let picture = pictureArray[0]
                    let picture = dict?["pictureUrl"]
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let ProfileController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                    
                    ProfileController.NameString = (firstName as! String) + " " + (lastName as! String)
                    ProfileController.LocString = City
                    ProfileController.PosString = title 
                    let URL_IMAGE = URL(string: picture as! String)
                
                    self.present(ProfileController, animated: true, completion: nil)
                    
                }, error: { (error) in
                    print("Error \(error)")
                })
            }
        }) { (error) in
            print("Error \(error)")
        }

    }
    func StringToDictionary(text: String)-> [String: Any]?{
        if let data = text.data(using: .utf8) {
            do{
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    fileprivate func writeConsoleLine(_ log: String, funcName: String = #function) {
        
        DispatchQueue.main.async { () -> Void in
            self.consoleTextView.insertText("\n")
            self.consoleTextView.insertText("-----------\(funcName) start:-------------")
            self.consoleTextView.insertText("\n")
            self.consoleTextView.insertText(log)
            self.consoleTextView.insertText("\n")
            self.consoleTextView.insertText("-----------\(funcName) end.----------------")
            self.consoleTextView.insertText("\n")
            
            let rect = CGRect(x: self.consoleTextView.contentOffset.x, y: self.consoleTextView.contentOffset.y, width: self.consoleTextView.contentSize.width, height: self.consoleTextView.contentSize.height)
            
            self.consoleTextView.scrollRectToVisible(rect, animated: true)
        }
    }
 
    
}

