//
//  AppDelegate.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 9/21/20.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        
        
        
        
        
        //        Auth.auth().addStateDidChangeListener { [self] (auth, user) in
        //            if user == nil {
        //                // Do nothing
        //                print("The user is not signed in!")
        //            } else {
        //                //There is a user signed in
        //                Auth.auth().currentUser?.reload(completion: { (error) in
        //                    if error != nil {
        //                        if let err = error as NSError? {
        //                            if let error = AuthErrorCode(rawValue: err.code) {
        //                                switch error {
        //                                // You need to prompt the user login interface
        //                                case .invalidCredential: print("Invalid credentials")
        //                                case .invalidUserToken: print("Invalid User Token")
        //                                case .userTokenExpired: print("User Token Expired")
        //                                case .invalidCustomToken: print("Invalid Custom Token")
        //                                case .customTokenMismatch: print("Custom token mismatch")
        //                                case .userDisabled: print("User disabled")
        //                                case .userNotFound: print("User not found")
        //                                default: print("call default error")
        //                                }
        //                            }
        //                        }
        //                    }
        //                    else {
        //                        print("Valid Token")
        //
        //                        if let accountCreationDate = user?.metadata.creationDate,
        //                           let lastSignIn = user?.metadata.lastSignInDate {
        //
        //                            if accountCreationDate == lastSignIn {
        //                                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
        //                                    if error != nil {
        //
        //                                    } else {
        //
        ////                                        print("AppDelegate: \(signUpViewController?.indicator)")
        //
        //                                        // Successfuly sent an email verification
        //                                        // Do an if statement and only proceeed to show the homescreen if the boolean is false
        //
        //
        //                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        //                                            // Redirect to home
        //                                            let HomeViewController = Utilities.transitionTo(storyboardName: Strings.userStoryboard, identifier: Strings.tabBarStoryboardID)
        //                                            window?.rootViewController = HomeViewController
        //                                            window?.makeKeyAndVisible()
        //
        //
        //                                        }
        //
        //
        //
        //
        //                                    }
        //                                })
        //                            }
        //
        //
        //
        //                        } else {
        //                            print("Can't get creation date and last sign in of user.")
        //                        }
        //
        //
        //                    }
        //                })
        //            }
        //        }
        
        return true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
}

