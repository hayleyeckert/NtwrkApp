//
//  AppDelegate.swift
//  Ntwrk
//
import UIKit
import CoreLocation
import Foundation
import Firebase
import GoogleSignIn

// Constants for ProfileController
var NameString = String()
var LocString = String()
var PosString = String()
var PicString = String()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Launch Google sign in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Linkedin sdk handle redirect
        if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return false
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    // Google Sign In Process
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Google sign in error:", error)
        }
        
        /********* Authenticate user **********/
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        /********* Add new user **********/
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let currentUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser?.uid
        print(userID)
        
        // Check if user already exists
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists()) {
                print("No user")
                ref.child("users").child(userID!).setValue(["username": user.profile.email])
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Check if user has set up profile
        ref.child("users").child(userID!).child("Job").observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists()) {
                print("Need to update profile with information from LinkedIn")
                // FIXME: Now, make sure the LinkedIn log in is called here (fake pushing the Log In with LinkedIn button?)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

}

