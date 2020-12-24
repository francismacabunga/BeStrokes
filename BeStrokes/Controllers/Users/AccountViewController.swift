//
//  ProfileController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var savedStickersView: UIView!
    
    
    
    
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    
    @IBOutlet weak var profileHeading: UILabel!
    @IBOutlet weak var profileNameHeading: UILabel!
    @IBOutlet weak var profileEmailHeading: UILabel!
    
    @IBOutlet weak var savedStickersHeading: UILabel!
    @IBOutlet weak var savedStickersTableView: UITableView!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().currentUser?.reload(completion: nil)
        //getProfileIcon()
        
        
        savedStickersTableView.dataSource = self
        savedStickersTableView.register(UINib(nibName: "SavedStickersTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedStickersTableViewCell")
        
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileView.backgroundColor = .clear
        savedStickersView.backgroundColor = .clear
        
        
        
        notificationButton.setTitle("", for: .normal)
        notificationButton.setBackgroundImage(UIImage(systemName: "bell.badge.fill"), for: .normal)
        notificationButton.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        editProfileButton.setTitle("", for: .normal)
        editProfileButton.setBackgroundImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        editProfileButton.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        
        
        
        
        profilePictureImageView.image = UIImage(named: "Avatar")
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.bounds.height / 2
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .scaleAspectFit
        
        
        profileHeading.text = "Profile"
        profileHeading.textAlignment = .center
        profileHeading.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        profileHeading.font = UIFont(name: "Futura-Bold", size: 35)
        
        
        
        profileNameHeading.text = "Francis Norman"
        profileNameHeading.textAlignment = .center
        profileNameHeading.numberOfLines = 1
        profileNameHeading.adjustsFontSizeToFitWidth = true
        profileNameHeading.minimumScaleFactor = 0.6
        profileNameHeading.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        profileNameHeading.font = UIFont(name: "Futura-Bold", size: 25)
        
        
        profileEmailHeading.text = "normanfrancism@gmail.com"
        profileEmailHeading.textAlignment = .center
        profileEmailHeading.numberOfLines = 1
        profileEmailHeading.adjustsFontSizeToFitWidth = true
        profileEmailHeading.minimumScaleFactor = 0.8
        profileEmailHeading.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        profileEmailHeading.font = UIFont(name: "Futura-Bold", size: 15)
        
        
        
        savedStickersHeading.text = "Saved Stickers"
        savedStickersHeading.font = UIFont(name: "Futura-Bold", size: 25)
        savedStickersHeading.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        
        
        
        savedStickersTableView.rowHeight = 170
        savedStickersTableView.separatorStyle = .none
        savedStickersTableView.backgroundColor = .clear
        
        
        
    }
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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



extension AccountViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedStickersTableViewCell") as! SavedStickersTableViewCell
        
        
        return cell
    }
    
    
}


