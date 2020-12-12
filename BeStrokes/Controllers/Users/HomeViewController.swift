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

struct CollectionViewData {
    var name: String
    var image: Data
}

struct FeaturedData {
    var name: String
    var image: Data
}

struct StickerData {
    var name: String
    var image: Data
    var tag: String?
}

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var featuredView: UIView!
    @IBOutlet weak var stickersView: UIView!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var featuredHeading: UILabel!
    @IBOutlet weak var stickerHeading: UILabel!
    
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var stickersCategoryCollectionView: UICollectionView!
    @IBOutlet weak var stickersCollectionView: UICollectionView!
    
    
    //MARK: - Private Constants/Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    
    private var featuredData = [FeaturedData]()
    private var stickerCategory = ["All", "Animals", "Food", "Objects", "Colored", "Travel"]
    private var sticker: [StickerData]?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designElements()
        //        setCollectionView()
        //        getCollectionViewData()
        
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
        
        stickersCategoryCollectionView.backgroundColor = UIColor.clear
        stickersCategoryCollectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
        stickersCategoryCollectionView.showsHorizontalScrollIndicator = false
        
        stickersCollectionView.backgroundColor = UIColor.clear
        stickersCollectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
        stickersCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func designProfilePictureImageView() {
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.contentMode = .scaleAspectFill
        DispatchQueue.main.async { [self] in
            profilePictureImageView.isSkeletonable = true
            profilePictureImageView.skeletonCornerRadius = Float(profilePictureImageView.frame.size.width / 2)
            profilePictureImageView.showAnimatedSkeleton()
        }
    }
    
    func getProfilePicture() {
        if user != nil {
            let UID = user?.uid
            let collectionReference = db.collection("users").whereField("UID", isEqualTo: UID!)
            collectionReference.getDocuments { [self] (result, error) in
                if error != nil {
                } else {
                    if let documents = result?.documents.first {
                        let imageString = documents["profilePic"] as! String
                        downloadData(using: imageString) { (imageData) in
                            DispatchQueue.main.async {
                                profilePictureImageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                profilePictureImageView.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
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
        stickersCategoryCollectionView.delegate = self
        stickersCollectionView.delegate = self
        featuredCollectionView.dataSource = self
        stickersCategoryCollectionView.dataSource = self
        stickersCollectionView.dataSource = self
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
    
    func getCollectionViewData() {
        
        getCollectionViewData(category: "featured") { [self] (results) in
            for result in results {
                featuredData.append(FeaturedData(name: result.name, image: result.image))
            }
            featuredCollectionView.reloadData()
        }
        
        getCollectionViewData(category: "stickers") { [self] (results) in
            sticker = [StickerData]()
            for result in results {
                sticker?.append(StickerData(name: result.name, image: result.image))
            }
            stickersCollectionView.reloadData()
        }
    }
    
    
    
    
    
    func getCollectionViewData(category: String, completed: @escaping ([CollectionViewData]) -> Void) {
        if user != nil {
            var featuredDataArray = [CollectionViewData]()
            var collectionReference: Query?
            if category == "featured" {
                collectionReference = db.collection("stickers").whereField("tag", isEqualTo: "featured")
            }
            if category == "stickers" {
                collectionReference = db.collection("stickers")
            }
            collectionReference!.getDocuments { [self] (snapshot, error) in
                if error != nil {
                } else {
                    guard let result = snapshot?.documents else {return}
                    for everyResult in result {
                        let name = everyResult["name"] as! String
                        let imageString = everyResult["image"] as! String
                        
                        
                        
                    }
                }
                completed(featuredDataArray)
            }
        }
    }
    
    
    //MARK: - Networking
    
    func downloadData(using dataString: String, completed: @escaping (Data) -> Void) {
        if let url = URL(string: dataString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // Show error
                } else {
                    if let result = data {
                        completed(result)
                    }
                }
            }
            task.resume()
        }
    }
    
}


//MARK: - Collection View Data Source

extension HomeViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "FeaturedCollectionViewCell"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == featuredCollectionView {
            return featuredData.count
        }
        
        if collectionView == stickersCategoryCollectionView {
            return stickerCategory.count
        }
        
        if collectionView == stickersCollectionView {
            return sticker?.count ?? 6
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == featuredCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionViewCell", for: indexPath) as! FeaturedCollectionViewCell
            cell.setData(with: featuredData[indexPath.row])
            return cell
        }
        
        if collectionView == stickersCategoryCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickersCategoryCollectionViewCell", for: indexPath) as! StickersCategoryCollectionViewCell
            cell.setData(with: stickerCategory[indexPath.row])
            return cell
        }
        
        if collectionView == stickersCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickersCollectionViewCell", for: indexPath) as! StickersCollectionViewCell
            
            if sticker != nil {
                cell.hideLoadingSkeleton()
                cell.setData(with: sticker![indexPath.row])
                return cell
            }
            
            cell.showLoadingSkeleton()
            return cell
        }
        return UICollectionViewCell()
    }
    
}


//MARK: - Collection View Design Update

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        viewPeekingBehavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == stickersCategoryCollectionView {
            let stickersCategoryCollectionViewLayout = stickersCategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            stickersCategoryCollectionViewLayout.sectionInset.left = 25
            return CGSize(width: 100, height: 30)
        }
        
        if collectionView == stickersCollectionView {
            let stickersCollectionViewLayout = stickersCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            stickersCollectionViewLayout.sectionInset.left = 25
            return CGSize(width: 140, height: 140)
        }
        return CGSize()
    }
    
}
