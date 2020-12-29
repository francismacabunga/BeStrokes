//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView
import Kingfisher
import Firebase

class StickersCollectionViewCell: UICollectionViewCell {
    
    func getHeartButtonValue(with: String) {
        print(with)
    }
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerHeartButtonLabel: UIButton!
    
    var isHeartButtonTapped: Bool?
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let connection = HomeViewController()
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stickerLabel.text = nil
        stickerImageView.image = nil
    }
    
    
    
    func designElements() {
        
        stickerHeartButtonLabel.setTitle("", for: .normal)
        stickerHeartButtonLabel.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        stickerHeartButtonLabel.tintColor = .black
        
        
        stickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerContentView.layer.cornerRadius = 30
        stickerContentView.clipsToBounds = true
        
        stickerLabel.textAlignment = .left
        stickerLabel.numberOfLines = 1
        stickerLabel.adjustsFontSizeToFitWidth = true
        stickerLabel.minimumScaleFactor = 0.8
        stickerLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        stickerImageView.contentMode = .scaleAspectFit
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            stickerContentView.isSkeletonable = true
            stickerContentView.skeletonCornerRadius = 40
            stickerContentView.showAnimatedSkeleton()
        }
    }
    
    var stickerDocumentID: String?
    
    func setData(with data: StickerData) {
        
        let stickerLabel = data.name
        let stickerImage = data.image
        stickerDocumentID = data.documentID
        
        
        hideLoadingSkeletonView()
        designElements()
        setStikcerLabelAndImage(with: stickerLabel, stickerImage)
        
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
    
    
    
    
    func setStikcerLabelAndImage(with name: String, _ imageURL: URL) {
        
        stickerLabel.text = name
        stickerImageView.kf.setImage(with: imageURL.absoluteURL)
        
        
        
        
        
    }
    
    
    
    
    func hideLoadingSkeletonView() {
        stickerContentView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.1))
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func stickerHeartButton(_ sender: UIButton) {
        
        if !isHeartButtonTapped! {
            setHeartButtonValue()
        } else {
            removeData()
        }
        
    }
    
    
    
    func setHeartButtonValue() {
        getSignedInUserData { [self] (result) in
            var userData = result
            let userLikedDocument = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").document()
            userData["documentID"] = userLikedDocument.documentID
            userLikedDocument.setData(userData)
            setHeartButttonDesign(using: "heart.fill")
        }
    }
    
    func removeData() {
        if user != nil {
            let userID = user?.uid as! String
            let databaseReference = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: userID).getDocuments { [self] (snapshot, error) in
                if error != nil {
                    // Show error
                }
                guard let result = snapshot?.documents.first else {return}
                let userDocumentID = result["documentID"] as! String
                let dataDeletion = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").document(userDocumentID).delete()
                setHeartButttonDesign(using: "heart")
            }
        }
    }
    
    func setHeartButttonDesign(using value: String) {
        stickerHeartButtonLabel.setTitle("", for: .normal)
        stickerHeartButtonLabel.setBackgroundImage(UIImage(systemName: value), for: .normal)
        stickerHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func checkHeartButtonValue(completed: @escaping (Bool) -> Void) {
        if user != nil {
            let signedInUserID = user?.uid as! String
            let databaseReference = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
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
    
    
}
