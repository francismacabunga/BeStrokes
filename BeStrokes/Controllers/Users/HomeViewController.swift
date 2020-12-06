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
    @IBOutlet weak var featuredHeading: UILabel!
    @IBOutlet weak var stickersHeading: UILabel!
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func designElements() {
        
        getProfilePicture()
        setProfilePicture()
        
    }
    
    func setCollectionView() {
        
        registerNib()
        viewPeekingBehavior = MSCollectionViewPeekingBehavior()
        setViewPeekingBehavior(using: viewPeekingBehavior)
        
    }
    
    func registerNib() {
        featuredCollectionView.register(UINib(nibName: "FeaturedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedCollectionViewCell")
        stickersCategoryCollectionView.register(UINib(nibName: "StickersCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StickersCategoryCollectionViewCell")
        stickersCollectionView.register(UINib(nibName: "StickersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StickersCollectionViewCell")
    }
    
    func setViewPeekingBehavior(using behavior: MSCollectionViewPeekingBehavior) {
        
        featuredCollectionView.configureForPeekingBehavior(behavior: behavior)
        behavior.cellPeekWidth = 10
        behavior.cellSpacing = 10
        
    }
    
    func setDelegate() {
        featuredCollectionView.delegate = self
        stickersCategoryCollectionView.delegate = self
        stickersCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        stickersCategoryCollectionView.dataSource = self
        stickersCollectionView.dataSource = self
    }
    
    
    //MARK: - Setting Profile Picture Process
    
    func setProfilePicture() {
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .scaleAspectFill
        
    }
    
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
    
}


extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == featuredCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionViewCell", for: indexPath)
            return cell
        }
        
        if collectionView == stickersCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickersCategoryCollectionViewCell", for: indexPath)
            return cell
        }
        
        if collectionView == stickersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickersCollectionViewCell", for: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        viewPeekingBehavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        
    }
    
}
