//
//  ProfileViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/24/20.
//

import UIKit
import Kingfisher
import Firebase




class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileNavigationBar: UINavigationBar!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var profileHeadingLabel: UILabel!
    @IBOutlet weak var profileTrademarkLabel1: UILabel!
    @IBOutlet weak var profileTrademarkLabel2: UILabel!
    
    @IBOutlet weak var profileTableView: UITableView!

    let settingsContent = ["Notifications", "Light Appearance", "Logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profileTableView.rowHeight = 50
        
        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        
        profileTableView.backgroundColor = .clear
        dividerView.backgroundColor = .gray
        
        profileHeadingLabel.text = "Settings"
        profileHeadingLabel.font = UIFont(name: "Futura-Bold", size: 20)
        profileHeadingLabel.textColor = .black
        
        
        profileNameLabel.numberOfLines = 1
        profileNameLabel.adjustsFontSizeToFitWidth = true
        profileEmailLabel.minimumScaleFactor = 0.8
        profileNameLabel.font = UIFont(name: "Futura-Bold", size: 20)
        profileNameLabel.textColor = .black
        
        
        
        
        
        profileEmailLabel.font = UIFont(name: "Futura-Bold", size: 15)
        profileEmailLabel.adjustsFontSizeToFitWidth = true
        profileEmailLabel.numberOfLines = 1
        profileEmailLabel.minimumScaleFactor = 0.7
        profileEmailLabel.textColor = .black
        
        
        profileTrademarkLabel1.text = "BeStrokes"
        profileTrademarkLabel1.textAlignment = .center
        profileTrademarkLabel1.font = UIFont(name: "Futura-Bold", size: 18)
        profileTrademarkLabel1.textColor = .black
        
        profileTrademarkLabel2.text = "made by Francis "
        profileTrademarkLabel2.textAlignment = .center
        profileTrademarkLabel2.font = UIFont(name: "Futura", size: 12)
        profileTrademarkLabel2.textColor = .black
        
        
        
        
        
      
        
        designNavigationBar()
        designProfilePictureImageView()
        
        
        
        
        
        
        
        
        getSignedInUserData()
        
        
    }
    
    
    
    func designProfilePictureImageView() {
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        
    }
    
    
    func designNavigationBar() {
        let image = UIImage(named: "White_Bar")
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        profileNavigationBar.topItem?.titleView = imageView
        profileNavigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileNavigationBar.isTranslucent = true
    }
    
    
    
    
    func getSignedInUserData() {
        
        let user = Auth.auth().currentUser
        let userID = user?.uid
        let db = Firestore.firestore()
        
        
        if user != nil {
            
            let firebaseQuery = db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { [self] (snapshot, error) in
                if error != nil {
                    // Show error
                }
                guard let result = snapshot?.documents.first else {return}
                let profilePictureURL = URL(string: result["profilePic"] as! String)!
                let firstName = result["firstName"] as! String
                
                
                profileNameLabel.text = firstName
                profileEmailLabel.text = user?.email!
                profileImageView.kf.setImage(with: profilePictureURL)
                
            }
            
        }
        
    }
    
    
    
    
    
    
}


extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        cell.setData(with: settingsContent[indexPath.row])
        return cell
        
    }
    
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = settingsContent[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
        if selectedCell == "Logout" {
         
            
            let user = Auth.auth().currentUser
            
            if user != nil {
                
                
                do {
                    let signOutUser = try Auth.auth().signOut()
                    
                    print("Success!")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(identifier: "LandingViewController") as! LandingViewController
                    view.window?.rootViewController = destinationVC
                    view.window?.makeKeyAndVisible()
                    
                } catch {
                    
                }
                
                
                
                
            }
            
           
            
            
           
        }
       
    }
    
}
