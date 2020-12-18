//
//  FeaturedCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView
import Firebase

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredContentView: UIView!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var featuredHeartButtonLabel: UIButton!
    @IBOutlet weak var featuredTryMeButtonLabel: UIButton!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    
    var heartButtonValue: String?
    var featuredStickerDocumentID: String?
    lazy var sample = String()
    
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
        
        print("Try me is selected")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func featuredHeartButton(_ sender: UIButton) {
        
        // Heart button logic
        if heartButtonValue == "heart" {
            heartButtonValue = "heart.fill"
            featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: heartButtonValue!), for: .normal)
            
            getStickerDocumentID { [self] (featuredStickerDocumentID) in
                setHeartButtonValue(on: featuredStickerDocumentID)
                
                
                
            }
        } else {
            heartButtonValue = "heart"
            featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: heartButtonValue!), for: .normal)
            
            getStickerDocumentID { [self] (documentID) in
                remove(on: documentID)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    func getStickerDocumentID(completed: @escaping (String) -> Void) {
        if user != nil {
            let name = featuredLabel.text
            let collectionReference = db.collection("stickers").whereField("documentID", isEqualTo: featuredStickerDocumentID).getDocuments { (snapshot, error) in
                if error != nil {
                    // Show error
                } else {
                    guard let result = snapshot?.documents.first else {return}
                    completed(result.documentID)
                }
            }
        }
    }
    
    
    
    func setHeartButtonValuef() {
        
        heartButtonValue = "heart"
        featuredHeartButtonLabel.setTitle("", for: .normal)
        featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: heartButtonValue!), for: .normal)
        featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    
    
    
    
    
    func setHeartButtonValue(on documentID: String) {
        
        checkMyName { [self] (firstName) in
            if user != nil {
                let UID = user?.uid
                let email = user?.email
                
                let collectionReference = db.collection("stickers").document(documentID).collection("likedBy").addDocument(data: ["UID" : UID, "email":email, "firstName":firstName]).documentID
                sample = collectionReference
                
            }
        }
        
    }
    
    func remove(on documentID: String) {
        if user != nil {
            let UID = user?.uid
            
            
            
            let collectionReference = db.collection("stickers").document(documentID).collection("likedBy").document(sample).delete()
            
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    func checkMyName(completed: @escaping (String)-> Void) {
        
        if user != nil {
            let UID = user?.uid
            let collectionReference = db.collection("users").whereField("UID", isEqualTo: UID).getDocuments { (snapshot, error) in
                if error != nil {
                    // Show error
                } else {
                    guard let result = snapshot?.documents.first else {return}
                    let name = result["firstName"] as! String
                    completed(name)
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
        setHeartButtonValuef()
        setFeaturedLabelAndImage(with: featuredStickerName, featuredStickerImage)
        
    }
    
    let cache = NSCache<NSURL, UIImage>()
    var passedImageString: URL?
    var sessionTask: URLSessionDataTask!
    
    func setFeaturedLabelAndImage(with name: String, _ imageURL: URL) {
        
        featuredLabel.text = name
//        passedImageString = imageURL
        
        
        
        if let imageCached = cache.object(forKey: imageURL as NSURL) as? UIImage {
            print("Hey")
            featuredImageView.image = imageCached
            return
        }
        
        fetchImageData(using: imageURL)
        
    }
    
    
    
    func fetchImageData(using imageURL: URL) {
        featuredImageView.image = nil
        
        if let sessionTask = sessionTask {
            sessionTask.cancel()
        }
        
        sessionTask = URLSession.shared.dataTask(with: imageURL) { [self] (data, response, error) in
            if error != nil {
                // Show error
            }
            print("Networking")
            guard let result = data else {return}
            let image = UIImage(data: result)!
            cache.setObject(image, forKey: imageURL as NSURL)
            DispatchQueue.main.async { [self] in
                featuredImageView.image = image
            }
        }
        sessionTask.resume()
    }
    
}





