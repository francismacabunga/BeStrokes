//
//  HomeController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailWarning: UILabel!
    
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNameOfSignedInUser()
        checkIfEmailIsVerified()
        
    }
    
    func getNameOfSignedInUser() {
        
        if user != nil {
            let UID = user?.uid
            let collectionReference = db.collection(Strings.collectionName).whereField(Strings.UID, isEqualTo: UID)
            collectionReference.getDocuments { [self] (snapshot, error) in
                if error != nil {
                    print("Cannot retrieve data to database now.")
                } else {
                    guard let snapshotResult = snapshot?.documents.first else {
                        return
                    }
                    let firstName = snapshotResult[Strings.firstName] as! String
                    welcomeLabel.text = "Welcome \(firstName)"
                }
            }
        }
    }
    
    func checkIfEmailIsVerified() {
        
        if user != nil {
            if user!.isEmailVerified {
                emailWarning.text = "Your email is verified."
            } else {
                emailWarning.text = "Your email is not yet verified. Check your email."
            }
        }
    }
    
}




