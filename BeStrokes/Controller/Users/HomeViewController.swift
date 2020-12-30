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

class HomeViewController: UIViewController  {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var featuredView: UIView!
    @IBOutlet weak var stickersView: UIView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var featuredHeading: UILabel!
    @IBOutlet weak var stickerHeading: UILabel!
    
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var stickerCategoryCollectionView: UICollectionView!
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    
    
    //MARK: - Constants / Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    
    private var stickerViewModel: [StickerViewModel]?
    private var stickerCategoryViewModel: [StickerCategoryViewModel]?
    
    
    //    private var stickerData: [StickerData]?
    //    private var stickerCategoryCollectionViewCell = StickersCategoryCollectionViewCell()
    //    private var stickerCategoryValue: Bool?
    var isHeartButtonTapped: Bool?
    var stickerDocumentID: String?
    //    var homeVCDelegate: HomeViewControllerDelegate?
    var stickerCategorySelected: String?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designElements()
        setCollectionView()
        getCollectionViewData(on: "Featured")
        setStickerCategoryCollectionViewData()
        getCollectionViewData(category: "All")
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
        
        stickerCategoryCollectionView.backgroundColor = UIColor.clear
        stickerCategoryCollectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
        stickerCategoryCollectionView.showsHorizontalScrollIndicator = false
        
        stickerCollectionView.backgroundColor = UIColor.clear
        stickerCollectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
        stickerCollectionView.showsHorizontalScrollIndicator = false
        
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
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureHandler))
        doubleTapGesture.numberOfTapsRequired = 2
        stickerCollectionView.addGestureRecognizer(doubleTapGesture)
        
    }
    
    @objc func tapGestureHandler() {
        let profileVC = ProfileViewController()
        profileVC.modalPresentationStyle = .automatic
        present(profileVC, animated: true)
    }
    
    @objc func doubleTapGestureHandler(doubleTap: UITapGestureRecognizer) {
        
        let doubleTapLocation = doubleTap.location(in: stickerCollectionView)
        guard let cellIndexPath = stickerCollectionView.indexPathForItem(at: doubleTapLocation) else {return}
        
        if stickerViewModel != nil {
            stickerDocumentID = stickerViewModel![cellIndexPath.row].stickerDocumentID
            //            checkHeartButtonValue { [self] (result) in
            //                if result {
            //                    removeData()
            //                } else {
            //                    setHeartButtonValue()
            //                }
            //            }
        }
    }
    
    
    //MARK: - Collection View Process
    
    func setCollectionView() {
        
        setDelegate()
        registerNib()
        
        viewPeekingBehavior = MSCollectionViewPeekingBehavior()
        setViewPeekingBehavior(using: viewPeekingBehavior)
        
    }
    
    func setDelegate() {
        featuredCollectionView.delegate = self
        stickerCategoryCollectionView.delegate = self
        stickerCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        stickerCategoryCollectionView.dataSource = self
        stickerCollectionView.dataSource = self
    }
    
    func registerNib() {
        featuredCollectionView.register(UINib(nibName: "FeaturedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedCollectionViewCell")
        stickerCategoryCollectionView.register(UINib(nibName: "StickerCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StickerCategoryCollectionViewCell")
        stickerCollectionView.register(UINib(nibName: "StickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StickerCollectionViewCell")
    }
    
    
    
    
    func getCollectionViewData(on stickerTag: String? = nil, category: String? = nil) {
        
        var firebaseQuery: Query
        
        if stickerTag == "Featured" {
            print("Hey")
            firebaseQuery = db.collection("stickers").whereField("tag", isEqualTo: stickerTag!)
            fetchData(with: firebaseQuery, collectionView: featuredCollectionView)
            return
        } else if category == nil || category == "All" {
            print("Hello")
            firebaseQuery = db.collection("stickers")
            fetchData(with: firebaseQuery, collectionView: stickerCollectionView)
            return
        } else if category != nil {
            print("Ugh")
            firebaseQuery = db.collection("stickers").whereField("category", isEqualTo: category!)
            fetchData(with: firebaseQuery, collectionView: stickerCollectionView)
            return
        }
        
    }
    
    func fetchData(with query: Query, collectionView: UICollectionView) {
        
        var stickerArray = [Sticker]()
        query.getDocuments { [self] (snapshot, error) in
            if error != nil {
                // Show error
            }
            guard let results = snapshot?.documents else {return}
            for result in results {
                let stickerDocumentID = result["documentID"] as! String
                let stickerName = result["name"] as! String
                let stickerImageURL = URL(string: result["image"] as! String)!
                let stickerTag = result["tag"] as! String
                stickerArray.append(Sticker(stickerDocumentID: stickerDocumentID, name: stickerName, image: stickerImageURL, tag: stickerTag))
            }
            
            
            
          
            
          
            
            

            stickerViewModel = stickerArray.map({return StickerViewModel(sticker: $0)})
            
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
        
    }
    
    
    func setStickerCategoryCollectionViewData() {
        let category = [StickerCategory(category: "All", isCategorySelected: nil),
                        StickerCategory(category: "Animals", isCategorySelected: nil),
                        StickerCategory(category: "Food", isCategorySelected: nil),
                        StickerCategory(category: "Objects", isCategorySelected: nil),
                        StickerCategory(category: "Colored", isCategorySelected: nil),
                        StickerCategory(category: "Travel", isCategorySelected: nil)]
        
        stickerCategoryViewModel = category.map({return StickerCategoryViewModel(stickerCategory: $0)})
    }
    
    
    
    
    //MARK: - Heart Button Logic
    
    //    func checkHeartButtonValue(completed: @escaping (Bool) -> Void) {
    //        if user != nil {
    //            let signedInUserID = user?.uid as! String
    //            let databaseReference = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: signedInUserID).getDocuments { (snapshot, error) in
    //                if error != nil {
    //                    // Show error
    //                }
    //                if let documents = snapshot?.documents {
    //                    for document in documents {
    //                        let userID = document["userID"] as! String
    //                        if userID == signedInUserID {
    //                            completed(true)
    //                            return
    //                        }
    //                    }
    //                }
    //                completed(false)
    //            }
    //        }
    //    }
    //
    //    func setHeartButtonValue() {
    //        getSignedInUserData { [self] (result) in
    //            var userData = result
    //            let userLikedDocument = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").document()
    //            userData["documentID"] = userLikedDocument.documentID
    //            userLikedDocument.setData(userData)
    //        }
    //    }
    //
    //    func removeData() {
    //        if user != nil {
    //            let userID = user?.uid as! String
    //            let databaseReference = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").whereField("userID", isEqualTo: userID).getDocuments { [self] (snapshot, error) in
    //                if error != nil {
    //                    // Show error
    //                }
    //                guard let result = snapshot?.documents.first else {return}
    //                let userDocumentID = result["documentID"] as! String
    //                let dataDeletion = db.collection("stickers").document(stickerDocumentID!).collection("likedBy").document(userDocumentID).delete()
    //            }
    //        }
    //    }
    //
    //    func getSignedInUserData(completed: @escaping ([String:String])-> Void) {
    //
    //        if user != nil {
    //            let userID = user?.uid as! String
    //            let userEmail = user?.email as! String
    //            let collectionReference = db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { (snapshot, error) in
    //                if error != nil {
    //                    // Show error
    //                } else {
    //                    guard let result = snapshot?.documents.first else {return}
    //                    let uid = result["userID"] as! String
    //                    let firstName = result["firstName"] as! String
    //                    completed(["userID": userID, "firstName": firstName, "email": userEmail])
    //                }
    //            }
    //        }
    //    }
    
}


//MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == stickerCategoryCollectionView {
            
            
            if stickerCategoryViewModel != nil {
                
                stickerCategorySelected = stickerCategoryViewModel![indexPath.row].category
                stickerCategoryViewModel![indexPath.row].isCategorySelected = true
                
                if let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell {
                    cell.getStickerCategoryStatus(using: stickerCategoryViewModel![indexPath.row])
                }
                
                stickerCategoryViewModel = nil
                DispatchQueue.main.async { [self] in
                    stickerCollectionView.reloadData()
                }
                getCollectionViewData(category: stickerCategorySelected)
                
                
            }
            
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == stickerCategoryCollectionView {
            
            if stickerCategoryViewModel != nil {
                stickerCategoryViewModel![indexPath.row].isCategorySelected = false
                if let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell {
                    cell.getStickerCategoryStatus(using: stickerCategoryViewModel![indexPath.row])
                }
            }
            
            
            
            
        }
    }
    
}


//MARK: - Collection View Data Source

extension HomeViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        if skeletonView == featuredCollectionView {
            return "FeaturedCollectionViewCell"
        }
        if skeletonView == stickerCollectionView {
            return "StickerCollectionViewCell"
        }
        return ReusableCellIdentifier()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == featuredCollectionView {
            return stickerViewModel?.count ?? 2
        }
        if collectionView == stickerCategoryCollectionView {
            return stickerCategoryViewModel?.count ?? 4
        }
        if collectionView == stickerCollectionView {
            return stickerViewModel?.count ?? 6
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == featuredCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionViewCell", for: indexPath) as! FeaturedCollectionViewCell
            
            if stickerViewModel != nil {
                
             
                
                
                
                DispatchQueue.main.async() { [self] in
                    cell.stickerViewModel = stickerViewModel![indexPath.row]
                    cell.prepareFeatureCollectionViewCell()
                }
                
                
                
                return cell
            }
            return cell
        }
        
        if collectionView == stickerCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCategoryCollectionViewCell", for: indexPath) as! StickerCategoryCollectionViewCell
            if stickerCategoryViewModel != nil {
                
                cell.stickerCategoryViewModel = stickerCategoryViewModel![indexPath.row]
                cell.putDesignOnElements()
                return cell
            }
            
            return cell
            
        }
        
        if collectionView == stickerCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCollectionViewCell", for: indexPath) as! StickerCollectionViewCell
            if stickerViewModel != nil {
                DispatchQueue.main.async { [self] in
                    cell.stickerViewModel = stickerViewModel![indexPath.row]
                    cell.setData()
                }
                return cell
            }
            return cell
        }
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
        
        if collectionView == stickerCategoryCollectionView {
            let stickerCategoryCollectionViewLayout = stickerCategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            stickerCategoryCollectionViewLayout.sectionInset.left = 25
            return CGSize(width: 100, height: 30)
        }
        
        if collectionView == stickerCollectionView {
            let stickersCollectionViewLayout = stickerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            stickersCollectionViewLayout.sectionInset.left = 25
            return CGSize(width: 140, height: 140)
        }
        return CGSize()
    }
    
}


