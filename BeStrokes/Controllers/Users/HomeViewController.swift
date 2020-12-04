//
//  HomeController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import FirebaseAuth
import Firebase
import MSPeekCollectionViewDelegateImplementation

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var homeHeading1: UILabel!
    @IBOutlet weak var homeHeading2: UILabel!
    @IBOutlet weak var stickerButton: UIButton!
    
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var stickersCategoryCollectionView: UICollectionView!
    @IBOutlet weak var stickersCollectionView: UICollectionView!
    
    
    //MARK: - Private Constants/Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private let sampleArray = ["Francis", "Norman", "Creed", "Luther", "Apple", "Samsung"]
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    private var stickerDictionary: [String: Any] = [:]
    private var stickerArray = [Data?]()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designElements()
        setCollectionView()
        setDelegate()
        
    }
    
    func designElements() {
        
//        setProfilePicture()
        
    }
    
    func setCollectionView() {
    
        registerNib()
        
        viewPeekingBehavior = MSCollectionViewPeekingBehavior()
        setViewPeekingBehavior(using: viewPeekingBehavior)
        
        
        
        
    }
    
    func registerNib() {
        featuredCollectionView.register(UINib(nibName: "FeaturedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedCollectionViewCell")
//        featuredCollectionView.register(UINib(nibName: "StickersCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StickersCategoryCollectionViewCell")
//        featuredCollectionView.register(UINib(nibName: "StickersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StickersCollectionViewCell")
    }
    
    func setViewPeekingBehavior(using behavior: MSCollectionViewPeekingBehavior) {
        
        featuredCollectionView.configureForPeekingBehavior(behavior: behavior)
        behavior.cellPeekWidth = 10
        behavior.cellSpacing = 10
        
    }
    
    
    func setDelegate() {
        featuredCollectionView.delegate = self
//        stickersCategoryCollectionView.delegate = self
//        stickersCollectionView.delegate = self
        featuredCollectionView.dataSource = self
//        stickersCategoryCollectionView.dataSource = self
//        stickersCollectionView.dataSource = self
    }
    
    
    //MARK: - Setting Profile Picture Process
    
//    func setProfilePicture() {
//        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
//        profilePictureImageView.clipsToBounds = true
//        profilePictureImageView.contentMode = .scaleAspectFill
//        getProfilePicture()
//    }
    
    func getProfilePicture() {
        
        if user != nil {
            let UID = user?.uid
            let collectionReference = db.collection("users").whereField("UID", isEqualTo: UID)
            collectionReference.getDocuments { [self] (result, error) in
                if error != nil {
                    
                } else {
                    if let documents = result?.documents.first {
                        let profilePicture = documents["profilePic"] as! String
                        if let imageData = changeToData(link: profilePicture) {
                            profilePictureImageView.image = UIImage(data: imageData)
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
    
    
    //    func getNameOfSignedInUser() {
    //
    //        if user != nil {
    //            let UID = user?.uid
    //
    //            let collectionReference = db.collection(Strings.collectionName).whereField(Strings.UID, isEqualTo: UID)
    //            collectionReference.getDocuments { [self] (snapshot, error) in
    //                if error != nil {
    //                    print("Cannot retrieve data to database now.")
    //                } else {
    //                    guard let snapshotResult = snapshot?.documents.first else {
    //                        return
    //                    }
    //                    let firstName = snapshotResult[Strings.firstName] as! String
    //                    welcomeLabel.text = "Welcome \(firstName)"
    //                }
    //            }
    //        }
    //    }
    
    //    func checkIfEmailIsVerified() {
    //
    //        if user != nil {
    //            if user!.isEmailVerified {
    //                emailWarning.text = "Your email is verified."
    //            } else {
    //                emailWarning.text = "Your email is not yet verified. Check your email."
    //            }
    //        }
    //    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    func getSampleSticker(completion: @escaping([Data]) -> Void) {
    //
    //        var myArray = [Data]()
    //        let collectionReference = db.collection("stickers").document("sample-stickers")
    //        let sample = collectionReference.getDocument { [self] (result, error) in
    //
    //            if error != nil {
    //                // Show error
    //            } else {
    //
    //                if let result = result?.data() {
    //                    stickerDictionary = result
    //
    //                    for everySticker in stickerDictionary {
    //                        let stickerValue = everySticker.value as! String
    //
    //
    //                        let imageURL = URL(string: stickerValue)
    //
    //                        do {
    //                            let imageData = try Data(contentsOf: imageURL!)
    //
    //                            myArray.append(imageData)
    //                        } catch {
    //
    //                        }
    //
    //                    }
    //
    //                }
    //                completion(myArray)
    //            }
    //
    //        }
    //    }
}


//extension HomeViewController: UITableViewDataSource {
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return stickerArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StickerCell", for: indexPath) as! StickerCell
//        cell.stickerImageView.image = UIImage(data: stickerArray[indexPath.row]!)
//        return cell
//
//    }
//
//
//
//}



extension HomeViewController: UICollectionViewDelegate {
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sampleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionViewCell", for: indexPath) as! FeaturedCollectionViewCell
//        cell.sampleLabel.text = sampleArray[indexPath.row]
        return cell
        
    }
    
    
    
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        viewPeekingBehavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
}




