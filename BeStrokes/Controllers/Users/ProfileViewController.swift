//
//  ProfileController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().currentUser?.reload(completion: nil)
        //getProfileIcon()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            print("Successfuly logged out")
            let LandingViewController = Utilities.transitionTo(storyboardName: Strings.mainStoryboard, identifier: Strings.landingStoryboardID)
            view.window?.rootViewController = LandingViewController
            view.window?.makeKeyAndVisible()
            
        } catch {
            let signOutError = NSError()
            print("Error in signing out \(signOutError)")
        }
    }
    
    
    
//    func getProfileIcon() {
//        
//        guard let user = Auth.auth().currentUser else {return}
//        let userID = user.uid
//        
//        let db = Firestore.firestore()
//        
//        let collectionRef = db.collection(Strings.collectionName).whereField("UID", isEqualTo: userID)
//        collectionRef.getDocuments { [self] (snapshotResult, error) in
//            
//            if error != nil {
//                print("There has been an error!")
//            } else {
//                if let profilePic = snapshotResult?.documents.first {
//                    if let profilePicLocation = profilePic["profilePic"] as? String {
//                     
//                        if let imageURL = URL(string: profilePicLocation) {
//                            
//                            do {
//                                print("Hello")
//                                let imageData = try Data(contentsOf: imageURL)
//                                profileIcon.image = UIImage(data: imageData)
//                                profileIcon.layer.cornerRadius = profileIcon.frame.size.width / 2
//                                profileIcon.clipsToBounds = true
//                                profileIcon.contentMode = .scaleAspectFill
//                            } catch {
//                                print("There has been an error")
//                            }
//                            
//                            
//                            
//                            
//                            
//                         
//                               
//                            
//                        }
//                        
//                            
//                        
//                        
//                        
//                    }
//                    
//                    
//                }
//                
//            }
//            
//        }
//        
//    }
    
    
}
