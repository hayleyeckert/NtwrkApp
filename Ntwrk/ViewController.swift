//
//  ViewController.swift
//  Ntwrk
//  This file manages the LinkedIn sign in process and also updates the user's Firebase profile with their info from LinkedIn.
// 

import UIKit
import Foundation
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
        
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "77tn2ar7gq6lgv", clientSecret: "iqkDGYpWdhf7WKzA", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Sign out button
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    /**
     Login with Linkedin
     */
    @IBAction func login() {
        
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
            self.requestProfile()
        }, error: { [unowned self] (error) -> Void in
            print("Error occurred: \(error)")
        }, cancel: { [unowned self] () -> Void in
            print("Log in cancelled")
        })
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            
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
            
        }

    }

    /**
     Request profile for your just logged in account
     */
    //let response = jsonWithArrayRoot as? [Any]
    @IBAction func requestProfile() {
        
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            
            /************ Obtain profile information ************/
            let emailAddress = response.jsonObject["emailAddress"]! as! String
            let firstName = response.jsonObject["firstName"]! as! String
            let lastName = response.jsonObject["lastName"]! as! String
            let fullName = firstName + " " + lastName
            let location : Dictionary = response.jsonObject["location"]! as! Dictionary<String, Any>
            var City: String = location["name"]! as! String
            let picture = response.jsonObject["pictureUrl"]
            let positions = response.jsonObject["positions"]!
            let titlePositions : Dictionary = response.jsonObject["positions"]! as! Dictionary<String, Any>
            var title = String()
            if (titlePositions["_total"] as! Int != 0) {
                let PositionObjects : Array<Dictionary> = titlePositions["values"] as! Array<Dictionary<String,Any>>
                title = PositionObjects[0]["title"]! as! String
            }
            else {
                title  = ""
            }
            
            // This code to get picture is currently broken
            //let pictureUrls : Dictionary = response.jsonObject["pictureUrls"]! as! Dictionary<String, Any>
            //let pictureArray : Array<NSObject> = pictureUrls["values"] as! Array<NSObject>
            //let picture = pictureArray[0]
    
            /************ Initialize Firebase profile ************/
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let currentUser = Auth.auth().currentUser
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).setValue(["Name": fullName, "Job": title, "Location": City, "Image": picture as! String])
            
            /************ Set up profile controller ************/
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ProfileController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            ProfileController.NameString = fullName
            ProfileController.LocString = City
            ProfileController.PosString = title //positions as! String
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
            print("Error occurred: \(error)")
        }
    }
    
}

