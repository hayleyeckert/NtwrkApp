//
//  ViewController.swift
//  Ntwrk
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "77tn2ar7gq6lgv", clientSecret: "iqkDGYpWdhf7WKzA", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"))
    
    
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
        
        /**
        *  Yeah, Just this simple, try with Linkedin installed and without installed
        *
        *   Check installed if you want to do different UI: linkedinHelper.isLinkedinAppInstalled()
        *   Access token later after login: linkedinHelper.lsAccessToken
        */
        
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
            self.requestProfile()
           // self.writeConsoleLine("Login success") //lsToken: \(lsToken)
        }, error: { [unowned self] (error) -> Void in
            
            //self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
        }, cancel: { [unowned self] () -> Void in
            
          //  self.writeConsoleLine("User Cancelled!")
        })
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            
           // self.writeConsoleLine("Request success with response: \(response)")
            let firstName = response.jsonObject["firstName"]!
            let lastName = response.jsonObject["lastName"]!
            let emailAdress = response.jsonObject["emailAddress"]!
            let location = response.jsonObject["location"]!
            let pictureUrl = response.jsonObject["pictureUrl"]!
            let positions = response.jsonObject["positions"]!
            
            print(response.jsonObject["emailAddress"]!)
            print(firstName, lastName)
            print(response.jsonObject["location.name"])
            
        }) { [unowned self] (error) -> Void in
            
           // self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
        }

    }

    /**
     Request profile for your just logged in account
     */
    //let response = jsonWithArrayRoot as? [Any]
    @IBAction func requestProfile() {
        
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            print(response)
            //self.writeConsoleLine("Request success with response: \(response)")
            let firstName = response.jsonObject["firstName"]!
            let lastName = response.jsonObject["lastName"]!
            let emailAdress = response.jsonObject["emailAddress"]!
            let location : Dictionary = response.jsonObject["location"]! as! Dictionary<String, Any>
            var City: String = location["name"]! as! String
            let pictureUrls : Dictionary = response.jsonObject["pictureUrls"]! as! Dictionary<String, Any>
            let pictureArray : Array<NSObject> = pictureUrls["values"] as! Array<NSObject>
            let picture = pictureArray[0]
            let positions = response.jsonObject["positions"]!
            print(positions)
            
            let titlePositions : Dictionary = response.jsonObject["positions"]! as! Dictionary<String, Any>
            print(titlePositions["_total"] as! Int)
            print("hello")
            var title = String()
            if (titlePositions["_total"] as! Int != 0) {
             let PositionObjects : Array<Dictionary> = titlePositions["values"] as! Array<Dictionary<String,Any>>
             title = PositionObjects[0]["title"]! as! String
            }
            else {
                 title  = ""
            }
            print(title)
            print(firstName, lastName)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ProfileController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            
            ProfileController.NameString = (firstName as! String) + " " + (lastName as! String)
            ProfileController.LocString = City
            ProfileController.PosString = title //positions as! String
            //ProfileController.PicString = picture as! String
            let URL_IMAGE = URL(string: picture as! String)
            let session = URLSession(configuration: .default)
            let getImageFromURL = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
                if let e = error
                {
                    print("Error occurred: \(e)")
                }
                else {
                    if (response as! HTTPURLResponse) != nil {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            ProfileController.PicString = image!
                        }
                        else {
                            print("Image is corrupted")
                        }
                    }
                    else {
                        print("No response from server")
                    }
                }
            }
            getImageFromURL.resume()
            self.present(ProfileController, animated: true, completion: nil)
            
            
        }) { [unowned self] (error) -> Void in
                
            //self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
        }
        
        //print(LSResponse);
    }
    
}

