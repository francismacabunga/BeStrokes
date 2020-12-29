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
import SkeletonView


//MARK: - Models

struct CollectionViewData {
    var name: String
    var image: String
}

struct FeaturedData {
    var documentID: String
    var name: String
    var image: URL
    var tag: String?
}

struct StickerData {
    var documentID: String
    var name: String
    var image: URL
    var tag: String?
}

struct Sample {
    var data: Data
}

struct StickerCategory {
    var category: String
    var isCategorySelected: Bool?
}

class HomeViewController: UIViewController  {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var featuredView: UIView!
    @IBOutlet weak var stickersView: UIView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var featuredHeading: UILabel!
    @IBOutlet weak var stickerHeading: UILabel!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var stickersCategoryCollectionView: UICollectionView!
    @IBOutlet weak var stickersCollectionView: UICollectionView!
    
    
    //MARK: - Constants / Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    var stickerViewModels: [StickerViewModel]?
//    private var stickerCategory = [
//        StickerCategory(category: "All", isCategorySelected: nil),
//        StickerCategory(category: "Animals", isCategorySelected: nil),
//        StickerCategory(category: "Food", isCategorySelected: nil),
//        StickerCategory(category: "Objects", isCategorySelected: nil),
//        StickerCategory(category: "Colored", isCategorySelected: nil),
//        StickerCategory(category: "Travel", isCategorySelected: nil)]
//    private var stickerData: [StickerData]?
//    private var stickerCategoryCollectionViewCell = StickersCategoryCollectionViewCell()
//    private var stickerCategoryValue: Bool?
    var isHeartButtonTapped: Bool?
    var stickerDocumentID: String?
//    var homeVCDelegate: HomeViewControllerDelegate?
//    var categorySelected: String?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designElements()
        setCollectionView()
        getCollectionViewData()
        registerGestures()
        
    }
    
    
    //MARK: - Design Elements
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func designElements() {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        featuredView.backgroundColor = .clear
        stickersView.backgroundColor = .clear
        
        designProfilePictureImageView()
        getProfilePicture()
        
        featuredHeading.text = "Featured"
        featuredHeading.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        featuredHeading.font = UIFont(name: "Futura-Bold", size: 35)
        
        stickerHeading.text = "Stickers"
        stickerHeading.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerHeading.font = UIFont(name: "Futura-Bold", size: 35)
        
        featuredCollectionView.backgroundColor = UIColor.clear
        featuredCollectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
        featuredCollectionView.showsHorizontalScrollIndicator = false
        
//        stickersCategoryCollectionView.backgroundColor = UIColor.clear
//        stickersCategoryCollectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
//        stickersCategoryCollectionView.showsHorizontalScrollIndicator = false
//
//        stickersCollectionView.backgroundColor = UIColor.clear
//        stickersCollectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
//        stickersCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func designProfilePictureImageView() {
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .scaleAspectFit
        DispatchQueue.main.async { [self] in
            profilePictureImageView.isSkeletonable = true
            profilePictureImageView.skeletonCornerRadius = Float(profilePictureImageView.frame.size.width / 2)
            profilePictureImageView.showAnimatedSkeleton()
        }
    }
    
    func getProfilePicture() {
        if user != nil {
            
            let userID = user?.uid
            let collectionReference = db.collection("users").whereField("userID", isEqualTo: userID!)
            
            collectionReference.getDocuments { [self] (result, error) in
                if error != nil {
                    // Show error
                } else {
                    guard let documents = result?.documents.first else {return}
                    let imageURL = URL(string: documents["profilePic"] as! String)
                    
                    DispatchQueue.main.async {
                        profilePictureImageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
                        profilePictureImageView.kf.setImage(with: imageURL)
                    }
                }
            }
        }
    }
    
    func setViewPeekingBehavior(using behavior: MSCollectionViewPeekingBehavior) {
        
        featuredCollectionView.configureForPeekingBehavior(behavior: behavior)
        behavior.cellPeekWidth = 10
        behavior.cellSpacing = 10
        
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        profilePictureImageView.addGestureRecognizer(tapGesture)
        profilePictureImageView.isUserInteractionEnabled = true
        
//        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureHandler))
//        doubleTapGesture.numberOfTapsRequired = 2
//        stickersCollectionView.addGestureRecognizer(doubleTapGesture)
        
    }
    
    @objc func tapGestureHandler() {
        let profileVC = ProfileViewController()
        profileVC.modalPresentationStyle = .automatic
        present(profileVC, animated: true)
    }
    
//    @objc func doubleTapGestureHandler(doubleTap: UITapGestureRecognizer) {
//
//        let doubleTapLocation = doubleTap.location(in: stickersCollectionView)
//        guard let cellIndexPath = stickersCollectionView.indexPathForItem(at: doubleTapLocation) else {return}
//
//        if stickerData != nil {
//            stickerDocumentID = stickerData![cellIndexPath.row].documentID
//            checkHeartButtonValue { [self] (result) in
//                if result {
//                    removeData()
//                } else {
//                    setHeartButtonValue()
//                }
//            }
//        }
//    }
    
    
    //MARK: - Collection View Process
    
    func setCollectionView() {
        
        setDelegate()
        registerNib()
        
        viewPeekingBehavior = MSCollectionViewPeekingBehavior()
        setViewPeekingBehavior(using: viewPeekingBehavior)
        
    }
    
    func setDelegate() {
        featuredCollectionView.delegate = self
//        stickersCategoryCollectionView.delegate = self
//        stickersCollectionView.delegate = self
        featuredCollectionView.dataSource = self
//        stickersCategoryCollectionView.dataSource = self
//        stickersCollectionView.dataSource = self
    }
    
    func registerNib() {
        featuredCollectionView.register(UINib(nibName: "FeaturedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedCollectionViewCell")
//        stickersCategoryCollectionView.register(UINib(nibName: "StickersCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StickersCategoryCollectionViewCell")
//        stickersCollectionView.register(UINib(nibName: "StickersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StickersCollectionViewCell")
    }
    
    func getCollectionViewData() {
        
        getFeaturedCollectionViewData()
//        getStickersCollectionViewData(category: nil)
        
    }
    
    func getFeaturedCollectionViewData() {
        
        if user != nil {
            
            let tag = "Featured"
            var sticker = [Sticker]()
            let collectionReference = db.collection("stickers").whereField("tag", isEqualTo: tag)
            
            collectionReference.getDocuments { [self] (snapshot, error) in
                
                if error != nil {
                } else {
                    
                    guard let results = snapshot?.documents else {return}
                 
                    for result in results {
                        let documentID = result["documentID"] as! String
                        let name = result["name"] as! String
                        let imageLink = URL(string: result["image"] as! String)!
                        let tag = result["tag"] as! String
                        
                        
                        sticker.append(Sticker(stickerID: documentID, name: name, image: imageLink, tag: tag))
                    }
                    print(sticker)
                    stickerViewModels = sticker.map({return StickerViewModel(sticker: $0)})
                    
                    DispatchQueue.main.async { [self] in
                        featuredCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
//    func getStickersCollectionViewData(category: String?) {
//
//        if user != nil {
//
//            let collectionReference: Query
//
//            if category == nil || category == "All" {
//                collectionReference = db.collection("stickers")
//            } else {
//                collectionReference = db.collection("stickers").whereField("category", isEqualTo: category)
//            }
//
//            collectionReference.getDocuments { [self] (snapshot, error) in
//                if error != nil {
//                } else {
//                    guard let results = snapshot?.documents else {return}
//                    stickerData = [StickerData]()
//                    for result in results {
//                        let documentID = result["documentID"] as! String
//                        let name = result["name"] as! String
//                        let imageLink = URL(string: result["image"] as! String)!
//                        stickerData?.append((StickerData(documentID: documentID, name: name, image: imageLink)))
//                    }
//
//                    DispatchQueue.main.async {
//                        stickersCollectionView.reloadData()
//                    }
//                }
//            }
//        }
//    }
    
    
    //MARK: - Heart Button Logic
    
    func checkHeartButtonValue(completed: @escaping (Bool) -> Void) {
        if user != nil {
            let signedInUserID = user?.uid as! String
            let databaseReference = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: signedInUserID).getDocuments { (snapshot, error) in
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
            let userLikedDocument = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").document()
            userData["documentID"] = userLikedDocument.documentID
            userLikedDocument.setData(userData)
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


//MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if collectionView == stickersCategoryCollectionView {
//
//            categorySelected = stickerCategory[indexPath.row].category
//            stickerCategory[indexPath.row].isCategorySelected = true
//
//            if let cell = collectionView.cellForItem(at: indexPath) as? StickersCategoryCollectionViewCell {
//                cell.setStickerCategoryValue(true)
//            }
//
//            stickerData = nil
//
//            DispatchQueue.main.async { [self] in
//                stickersCollectionView.reloadData()
//            }
//            getStickersCollectionViewData(category: categorySelected)
//        }
//
//        if collectionView == stickersCollectionView {
//
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
//        if collectionView == stickersCategoryCollectionView {
//
//            stickerCategory[indexPath.row].isCategorySelected = false
//            if let cell = collectionView.cellForItem(at: indexPath) as? StickersCategoryCollectionViewCell {
//                cell.setStickerCategoryValue(false)
//            }
//        }
//    }
    
}


//MARK: - Collection View Data Source

extension HomeViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        if skeletonView == featuredCollectionView {
            return "FeaturedCollectionViewCell"
        }
//        if skeletonView == stickersCollectionView {
//            return "StickersCollectionViewCell"
//        }
        return ReusableCellIdentifier()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == featuredCollectionView {
            return stickerViewModels?.count ?? 2
        }
//        if collectionView == stickersCategoryCollectionView {
//            return stickerCategory.count
//        }
//        if collectionView == stickersCollectionView {
//            return stickerData?.count ?? 6
//        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == featuredCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionViewCell", for: indexPath) as! FeaturedCollectionViewCell
            
            if stickerViewModels != nil {
                DispatchQueue.main.async() { [self] in
                    let sticker = stickerViewModels![indexPath.row]
                    cell.stickerViewModel = sticker
                    cell.hideLoadingSkeletonView()
                    cell.designElements()
                    cell.setData()
                }
                return cell
            }
            return cell
        }
        
//        if collectionView == stickersCategoryCollectionView {
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickersCategoryCollectionViewCell", for: indexPath) as! StickersCategoryCollectionViewCell
//            cell.setData(with: stickerCategory[indexPath.row].category)
//            cell.setStickerCategoryValue(stickerCategory[indexPath.row].isCategorySelected)
//            return cell
//        }
//
//        if collectionView == stickersCollectionView {
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickersCollectionViewCell", for: indexPath) as! StickersCollectionViewCell
//            if stickerData != nil {
//                DispatchQueue.main.async { [self] in
//                    cell.setData(with: stickerData![indexPath.row])
//
//                }
//                return cell
//            }
//            return cell
//        }
        return UICollectionViewCell()
    }
    
}


//MARK: - Collection View Delegate Flow Layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.frame.height == 280 {
            viewPeekingBehavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if collectionView == stickersCategoryCollectionView {
//            let stickersCategoryCollectionViewLayout = stickersCategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//            stickersCategoryCollectionViewLayout.sectionInset.left = 25
//            return CGSize(width: 100, height: 30)
//        }
//
//        if collectionView == stickersCollectionView {
//            let stickersCollectionViewLayout = stickersCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//            stickersCollectionViewLayout.sectionInset.left = 25
//            return CGSize(width: 140, height: 140)
//        }
        return CGSize()
    }
    
}


