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
    
    
    //MARK: - Variables and Constants
    
    lazy var sample = String()
    var heartButtonValue: String?
    var featuredStickerDocumentID: String?
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
        
    }
    
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
    
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        
    }
    
    
    func setFeaturedLabelAndImage(with name: String, _ imageURL: URL) {
        
        featuredLabel.text = name
        featuredImageView.kf.setImage(with: imageURL.absoluteURL)
        
    }
    
    var isHeartButtonTapped: Bool?
    
    
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
    
    func setData(with data: FeaturedData) {
        
        featuredStickerDocumentID = data.documentID
        let featuredStickerName = data.name
        let featuredStickerImage = data.image
        
        hideLoadingSkeletonView()
        designElements()
        setFeaturedLabelAndImage(with: featuredStickerName, featuredStickerImage)
        
        
        
        
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
    
    override func prepareForReuse() {
        featuredHeartButtonLabel.setBackgroundImage(nil, for: .normal)
    }
    
    
    
    
    
    
    //MARK: - Heart Button Logic
    
    @IBAction func featuredHeartButton(_ sender: UIButton) {
        
        if !isHeartButtonTapped! {
            setHeartButtonValue()
            print("Not clicked")
        } else {
            removeData()
            print("Clicked")
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
    
    func setHeartButttonDesign(using value: String) {
        featuredHeartButtonLabel.setTitle("", for: .normal)
        featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: value), for: .normal)
        featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
                            print("May kapareho!")
                            completed(true)
                            return
                        }
                    }
                }
                print("Wala")
                completed(false)
            }
        }
    }
    
}





