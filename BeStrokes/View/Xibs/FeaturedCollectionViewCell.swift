//
//  FeaturedCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView
import Firebase
import Kingfisher

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var featuredContentView: UIView!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var featuredHeartButtonLabel: UIButton!
    @IBOutlet weak var featuredTryMeButtonLabel: UIButton!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    
    //MARK: - Constants / Variables
    
    lazy var sample = String()
    var heartButtonValue: String?
    var featuredStickerDocumentID: String?
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var isHeartButtonTapped: Bool?
    
    var stickerViewModel: StickerViewModel! {
        didSet {
            featuredLabel.text = stickerViewModel.name
            featuredImageView.kf.setImage(with: stickerViewModel.image)
            featuredStickerDocumentID = stickerViewModel.stickerID
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
        
    }
    
    override func prepareForReuse() {
        featuredHeartButtonLabel.setBackgroundImage(nil, for: .normal)
    }
    
    
    //MARK: - Design Elements
    
    func designElements() {
        
        featuredContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        featuredContentView.layer.cornerRadius = 40
        featuredContentView.clipsToBounds = true
        
        featuredLabel.numberOfLines = 0
        featuredLabel.lineBreakMode = .byWordWrapping
        featuredLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        featuredLabel.font = UIFont(name: "Futura-Bold", size: 25)
        
        featuredTryMeButtonLabel.setTitle("Try me", for: .normal)
        featuredTryMeButtonLabel.layer.cornerRadius = featuredTryMeButtonLabel.bounds.height / 2
        featuredTryMeButtonLabel.clipsToBounds = true
        featuredTryMeButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 15)
        featuredTryMeButtonLabel.setTitleColor(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), for: .normal)
        featuredTryMeButtonLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        featuredImageView.contentMode = .scaleAspectFit
        
    }
    
    func setHeartButttonDesign(using value: String) {
        featuredHeartButtonLabel.setTitle("", for: .normal)
        featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: value), for: .normal)
        featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func setFeaturedLabelAndImage(with name: String, _ imageURL: URL) {
        featuredLabel.text = name
        featuredImageView.kf.setImage(with: imageURL.absoluteURL)
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            featuredContentView.isSkeletonable = true
            featuredContentView.skeletonCornerRadius = 40
            featuredContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        featuredContentView.hideSkeleton(reloadDataAfter: false, transition: SkeletonTransitionStyle.crossDissolve(0.1))
    }
    
    
    //MARK: - Fetch Data
    
    func setData() {
        
//        featuredStickerDocumentID = data.documentID
//        let featuredStickerName = data.name
//        let featuredStickerImage = data.image
//        
//        hideLoadingSkeletonView()
//        designElements()
//        setFeaturedLabelAndImage(with: featuredStickerName, featuredStickerImage)
        
        checkHeartButtonValue { [self] (result) in
            if result {
                setHeartButttonDesign(using: "heart.fill")
                isHeartButtonTapped = true
            } else {
                setHeartButttonDesign(using: "heart")
                isHeartButtonTapped = false
            }
        }
    }
    
    
    //MARK: - Heart Button Logic
    
    @IBAction func featuredHeartButton(_ sender: UIButton) {
        
        if !isHeartButtonTapped! {
            setHeartButtonValue()
        } else {
            removeData()
        }
        
    }
    
    func checkHeartButtonValue(completed: @escaping (Bool) -> Void) {
        if user != nil {
            let signedInUserID = user?.uid as! String
            let databaseReference = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    // Show error
                }
                if let documents = snapshot?.documents {
                    for document in documents {
                        let userID = document["userID"] as! String
                        if userID == signedInUserID {
                            completed(true)
                            return
                        }
                    }
                }
                completed(false)
            }
        }
    }
    
    func setHeartButtonValue() {
        getSignedInUserData { [self] (result) in
            var userData = result
            let userLikedDocument = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").document()
            userData["documentID"] = userLikedDocument.documentID
            userLikedDocument.setData(userData)
            setHeartButttonDesign(using: "heart.fill")
        }
    }
    
    func removeData() {
        if user != nil {
            let userID = user?.uid as! String
            let databaseReference = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: userID).getDocuments { [self] (snapshot, error) in
                if error != nil {
                    // Show error
                }
                guard let result = snapshot?.documents.first else {return}
                let userDocumentID = result["documentID"] as! String
                let dataDeletion = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").document(userDocumentID).delete()
                setHeartButttonDesign(using: "heart")
            }
        }
    }
    
    func getSignedInUserData(completed: @escaping ([String:String])-> Void) {
        
        if user != nil {
            let userID = user?.uid as! String
            let userEmail = user?.email as! String
            let collectionReference = db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { (snapshot, error) in
                if error != nil {
                    // Show error
                } else {
                    guard let result = snapshot?.documents.first else {return}
                    let uid = result["userID"] as! String
                    let firstName = result["firstName"] as! String
                    completed(["userID": userID, "firstName": firstName, "email": userEmail])
                }
            }
        }
    }
    
    
    //MARK: - Try Me Button Logic
    
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        
    }
    
}









