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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    

    
    
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var stickerDictionary: [String: Any] = [:]
    var stickerArray = [Data?]()
    
    
    let sampleArray = ["Francis", "Norman", "Creed"]
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StickerCell", bundle: nil), forCellReuseIdentifier: "StickerCell")
        tableView.dataSource = self
        
        featuredCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        featuredCollectionView.register(UINib(nibName: "FeaturedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedCollectionViewCell")
        
        
        
        
        
        
        
        
        
        getNameOfSignedInUser()
        checkIfEmailIsVerified()
        getProfilePicture()
        changeElements()
        
        getSampleSticker { [self] (result) in
            stickerArray = result
            tableView.reloadData()
        }
        
    }
    
    func changeElements() {
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
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
    
    
    

    func getProfilePicture() {
        
        if user != nil {
            let UID = user?.uid
            let collectionReference = db.collection("users").whereField("UID", isEqualTo: UID)
            collectionReference.getDocuments { [self] (result, error) in
                if error != nil {
                    // Show error
                } else {
                    if let documents = result?.documents.first {
                        let profilePicture = documents["profilePic"] as! String
                        
            
                        if let imageData = changeToData(link: profilePicture) {
                            profileImageView.image = UIImage(data: imageData)
                        }
                        
                      
                        
                    }
                }
            }
        }
        
        
        
    }
    
    
    
    func changeToData(link: String) -> Data? {
        
        if let imageURL = URL(string: link) {
            
            do {
                let imageData = try Data(contentsOf: imageURL)
                
                return imageData
            } catch {
                
            }
            
            
        
        
        
        }
        
        
        return nil
    }
    
    
    
    
    func getSampleSticker(completion: @escaping([Data]) -> Void) {
        
        var myArray = [Data]()
        let collectionReference = db.collection("stickers").document("sample-stickers")
        let sample = collectionReference.getDocument { [self] (result, error) in
            
            if error != nil {
                // Show error
            } else {
                
                if let result = result?.data() {
                    stickerDictionary = result
                    
                    for everySticker in stickerDictionary {
                        let stickerValue = everySticker.value as! String
                        
                        
                        let imageURL = URL(string: stickerValue)
                        
                        do {
                            let imageData = try Data(contentsOf: imageURL!)
                            
                            myArray.append(imageData)
                        } catch {
                            
                        }
                        
                    }
                    
                }
                completion(myArray)
            }
            
        }
    }
}


extension HomeViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stickerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StickerCell", for: indexPath) as! StickerCell
        cell.stickerImageView.image = UIImage(data: stickerArray[indexPath.row]!)
        return cell
        
    }
    
}



extension HomeViewController: UICollectionViewDelegate {
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sampleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionViewCell", for: indexPath) as! FeaturedCollectionViewCell
        cell.sampleLabel.text = sampleArray[indexPath.row]
        return cell
        
    }
    
    
    
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        var cellWidth = collectionViewWidth - 20
        
        
        return CGSize(width: cellWidth, height: 280)
    }
}

