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
    
    var sampleCheck: Bool?
    
    
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
                sampleCheck = true

            } else {


                setHeartButttonDesign(using: "heart")
                sampleCheck = false

            }
        }
        
        
//        setDefaultHeartButtonValue(using: "heart")
        
        
    }
    
    func setDefaultHeartButtonValue(using value: String) {
        featuredHeartButtonLabel.setTitle("", for: .normal)
        featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: value), for: .normal)
        featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func setHeartButttonDesign(using value: String) {
        featuredHeartButtonLabel.setTitle("", for: .normal)
        featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: value), for: .normal)
        featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    
    
    //MARK: - Heart Button Logic
    
    //    func checkHeartButtonValue(completion: @escaping (Bool) -> Void) {
    //        let UID = user?.uid
    //
    //        if user != nil {
    //
    //            let collectionReference = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").whereField("UID", isEqualTo: UID)
    //            collectionReference.getDocuments { [self] (snapshot, error) in
    //                if error != nil {
    //                    // Show error
    //                    return
    //                }
    //                guard let result = snapshot?.documents.first else {
    //                    print(featuredStickerDocumentID)
    //                    completion(false)
    //                    return
    //                }
    //                completion(true)
    //            }
    //        }
    //    }
    
    
    //    func setHeartButtonValue(with value: Bool) {
    //        if value {
    //            featuredHeartButtonLabel.setTitle("", for: .normal)
    //            featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
    //            featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    //        } else {
    //            featuredHeartButtonLabel.setTitle("", for: .normal)
    //            featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
    //            featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    //        }
    //    }
    
    
    
    
    
    
    
    func setHeartButtonValue() {
        getSignedInUserData { [self] (result) in
            var userData = result
            let userLikedDocument = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").document()
            userData["documentID"] = userLikedDocument.documentID
            userLikedDocument.setData(userData)
            setHeartButttonDesign(using: "heart.fill")
        }
    }
    
    func checkHeartButtonValue(completed: @escaping (Bool)->Void) {
        if user != nil {
            let userID = user?.uid as! String
            
            let databaseReference = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: userID).getDocuments { (snapshot, error) in
                if error != nil {
                    
                }
                
                guard let result = snapshot?.documents.first else {
                    completed(false)
                    return
                    
                }
                completed(true)
                
            }
        }
    }
    
    @IBAction func featuredHeartButton(_ sender: UIButton) {
        
        guard let isWorking = sampleCheck else {return}
        
//        if isWorking == false {
//            setHeartButtonValue()
//        }
        
        if isWorking == true {
            
            setHeartButttonDesign(using: "heart")
            removeData()
        }
        
    
//        if !sampleCheck! {
//            setHeartButtonValue()
//        } else {
//            setHeartButttonDesign(using: "heart")
//            removeData()
//        }
        
        
    }
    
    
    func removeData() {
        if user != nil {
            let userID = user?.uid as! String
            let databaseReference = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: userID).getDocuments { [self] (snapshot, error) in
                if error != nil {
                    
                }
                
                guard let result = snapshot?.documents.first else {return}
                print(result)
                let userDocumentID = result["documentID"] as! String
                
                let dataDeletion = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").document(userDocumentID).delete()
           
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    //        getUserDocumentID()
    
    //        checkHeartButtonValue { [self] (heartValue) in
    //            if heartValue {
    //                print("Liked na!")
    //                remove(on: featuredStickerDocumentID!)
    //            } else {
    //                print("Di pa liked!")
    //                print("Document ng di pa liked: \(featuredStickerDocumentID)")
    //
    //            }
    //        }
    
    
    // Heart button logic
    //        if heartButtonValue == "heart" {
    //            heartButtonValue = "heart.fill"
    //            featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: heartButtonValue!), for: .normal)
    //
    //            getStickerDocumentID { [self] (featuredStickerDocumentID) in
    //                setHeartButtonValue(on: featuredStickerDocumentID)
    //            }
    //        } else {
    //            heartButtonValue = "heart"
    //            print("hello world!")
    //            featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: heartButtonValue!), for: .normal)
    //
    //            getStickerDocumentID { [self] (documentID) in
    //                remove(on: documentID)
    //            }
    //        }
    
    
    //    func getStickerDocumentID() {
    //        if user != nil {
    //            let name = featuredLabel.text
    //            let collectionReference = db.collection("stickers").whereField("documentID", isEqualTo: featuredStickerDocumentID).getDocuments { (snapshot, error) in
    //                if error != nil {
    //                    // Show error
    //                    return
    //                } else {
    //                    guard let result = snapshot?.documents.first else {return}
    //                    print(result.documentID)
    ////                    completed(result.documentID)
    //                }
    //            }
    //        }
    //    }
    
    
    //    func getUserDocumentID() {
    ////        checkMyName { [self] (firstName) in
    //            let UID = user?.uid
    ////            print(firstName)
    //            let collectionRefence = db.collection("stickers").document(featuredStickerDocumentID!).collection("likedBy").whereField("UID", isEqualTo: UID).getDocuments { (snapshot, error) in
    //                if error != nil {
    //                    // Show error
    //                    return
    //                }
    //                guard let result = snapshot?.documents.first else {
    //                    print("Walang user na nag like")
    //                    return
    //                }
    //                print("Meron ng user na nag liked!")
    //                print("Ito yung nag liked: \(result.documentID)")
    //            }
    ////        }
    //    }
    
    
    //    func setHeartButtonValue(on documentID: String, completed: @escaping (String)->Void) {
    //        checkMyName { [self] (firstName) in
    //            if user != nil {
    //                let UID = user?.uid
    //                let email = user?.email
    //                let collectionReference = db.collection("stickers").document(documentID).collection("likedBy").addDocument(data: ["UID" : UID, "email":email, "firstName":firstName]).documentID
    //                sample = collectionReference
    //            }
    //        }
    //    }
    //
    //    func remove(on documentID: String) {
    //        if user != nil {
    //            let UID = user?.uid
    //            let collectionReference = db.collection("stickers").document(documentID).collection("likedBy").document(sample).delete()
    //        }
    //    }
    //
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





