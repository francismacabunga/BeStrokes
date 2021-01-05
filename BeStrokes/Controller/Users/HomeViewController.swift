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

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var contentStack: UIStackView!
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
    
    private var featuredStickerViewModel: [FeaturedStickerViewModel]?
    private var stickerCategoryViewModel = [StickerCategoryViewModel]()
    private var stickerViewModel: [StickerViewModel]?
    
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    private var fetchUserData = FetchUserData()
    private var fetchStickerData = FetchStickerData()
    private var fetchStickerCategoryData = FetchStickerCategoryData()
    private var heartButtonLogic = HeartButtonLogic()
    
    private var stickerCategorySelected: String?
    var featuredHeartButtonTapped: Bool?
    var stickerHeartButtonTapped: Bool?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        registerGestures()
        registerCollectionView()
        setCollectionViewData()
        
    }
    
    
    //MARK: - Design Elements
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setDesignElements() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentStack.backgroundColor = .clear
        featuredView.backgroundColor = .clear
        stickersView.backgroundColor = .clear
        
        setDesignProfilePictureImageView()
        getProfilePicture()
        
        Utilities.setDesignOn(featuredHeading, label: Strings.featuredHeadingText)
        Utilities.setDesignOn(stickerHeading, label: Strings.stickerHeadingText)
        
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
    
    func setDesignProfilePictureImageView() {
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
        fetchUserData.getProfilePicture { (result) in
            let profilePicImageURL = result
            DispatchQueue.main.async { [self] in
                profilePictureImageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
                profilePictureImageView.kf.setImage(with: profilePicImageURL)
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
        
        let featuredDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(featuredDoubleTapGestureHandler))
        featuredDoubleTapGesture.numberOfTapsRequired = 2
        featuredCollectionView.addGestureRecognizer(featuredDoubleTapGesture)
        
        let stickerDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(stickerDoubleTapGestureHandler))
        stickerDoubleTapGesture.numberOfTapsRequired = 2
        stickerCollectionView.addGestureRecognizer(stickerDoubleTapGesture)
        
    }
    
    @objc func tapGestureHandler() {
        let profileVC = ProfileViewController()
        profileVC.modalPresentationStyle = .automatic
        present(profileVC, animated: true)
    }
    
    @objc func featuredDoubleTapGestureHandler(doubleTap: UITapGestureRecognizer) {
        
        let doubleTapLocation = doubleTap.location(in: featuredCollectionView)
        guard let cellIndexPath = featuredCollectionView.indexPathForItem(at: doubleTapLocation) else {return}
        if featuredStickerViewModel != nil {
            let stickerDocumentID = featuredStickerViewModel![cellIndexPath.row].stickerDocumentID
            print(stickerDocumentID)
            if featuredHeartButtonTapped != nil {
                if featuredHeartButtonTapped! {
                    heartButtonLogic.removeUserData(using: stickerDocumentID)
                } else {
                    heartButtonLogic.saveUserData(using: stickerDocumentID)
                }
            }
        }
        
    }
    
    @objc func stickerDoubleTapGestureHandler(doubleTap: UITapGestureRecognizer) {
        
        let doubleTapLocation = doubleTap.location(in: stickerCollectionView)
        guard let cellIndexPath = stickerCollectionView.indexPathForItem(at: doubleTapLocation) else {return}
        if stickerViewModel != nil {
            let stickerDocumentID = stickerViewModel![cellIndexPath.row].stickerDocumentID
            print(stickerDocumentID)
            if stickerHeartButtonTapped != nil {
                if stickerHeartButtonTapped! {
                    heartButtonLogic.removeUserData(using: stickerDocumentID)
                } else {
                    heartButtonLogic.saveUserData(using: stickerDocumentID)
                }
            }
        }
        
    }
    
    
    //MARK: - Collection View Process
    
    func registerCollectionView() {
        
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
        featuredCollectionView.register(UINib(nibName: Strings.featuredStickerCell, bundle: nil), forCellWithReuseIdentifier: Strings.featuredStickerCell)
        stickerCategoryCollectionView.register(UINib(nibName: Strings.stickerCategoryCell, bundle: nil), forCellWithReuseIdentifier: Strings.stickerCategoryCell)
        stickerCollectionView.register(UINib(nibName: Strings.stickerCell, bundle: nil), forCellWithReuseIdentifier: Strings.stickerCell)
    }
    
    func setCollectionViewData() {
        getFeaturedCollectionViewData()
        getStickerCategoryCollectionViewData()
        getStickerCollectionViewData(onCategory: Strings.allStickers)
    }
    
    func getFeaturedCollectionViewData() {
        fetchStickerData.onCollectionViewData(withTag: Strings.featuredStickers) { [self] (result) in
            featuredStickerViewModel = result.map({return FeaturedStickerViewModel(featuredSticker: $0)})
            DispatchQueue.main.async {
                featuredCollectionView.reloadData()
            }
        }
    }
    
    func getStickerCategoryCollectionViewData() {
        let stickerCategory = fetchStickerCategoryData.getCategoryData()
        stickerCategoryViewModel = stickerCategory.map({return StickerCategoryViewModel(stickerCategory: $0)})
    }
    
    func getStickerCollectionViewData(onCategory stickerCategory: String) {
        fetchStickerData.onCollectionViewData(category: stickerCategory) { [self] (result) in
            stickerViewModel = result.map({return StickerViewModel(sticker: $0)})
            DispatchQueue.main.async { [self] in
                stickerCollectionView.reloadData()
            }
        }
    }
    
}


//MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == stickerCategoryCollectionView {
            stickerCategorySelected = stickerCategoryViewModel[indexPath.row].category
            stickerCategoryViewModel[indexPath.row].isCategorySelected = true
            
            if let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell {
                cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
            }
            
            getStickerCollectionViewData(onCategory: stickerCategorySelected!)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == stickerCategoryCollectionView {
            stickerCategoryViewModel[indexPath.row].isCategorySelected = false
            if let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell {
                cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
            }
        }
    }
    
}


//MARK: - Collection View Datasource

extension HomeViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        if skeletonView == featuredCollectionView {
            return Strings.featuredStickerCell
        }
        if skeletonView == stickerCollectionView {
            return Strings.stickerCell
        }
        return ReusableCellIdentifier()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == featuredCollectionView {
            return featuredStickerViewModel?.count ?? 2
        }
        if collectionView == stickerCategoryCollectionView {
            return stickerCategoryViewModel.count
        }
        if collectionView == stickerCollectionView {
            return stickerViewModel?.count ?? 6
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == featuredCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.featuredStickerCell, for: indexPath) as! FeaturedCollectionViewCell
            if featuredStickerViewModel != nil {
                DispatchQueue.main.async() { [self] in
                    cell.featuredStickerViewModel = featuredStickerViewModel![indexPath.row]
                    cell.prepareFeatureCollectionViewCell()
                    cell.featuredCollectionViewCellDelegate = self
                }
                return cell
            }
            return cell
        }
        
        if collectionView == stickerCategoryCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCategoryCell, for: indexPath) as? StickerCategoryCollectionViewCell {
                DispatchQueue.main.async { [self] in
                    cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
                    cell.setDesignOnElements()
                }
                return cell
            }
        }
        
        if collectionView == stickerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCell, for: indexPath) as! StickerCollectionViewCell
            if stickerViewModel != nil {
                DispatchQueue.main.async { [self] in
                    cell.stickerViewModel = stickerViewModel![indexPath.row]
                    cell.prepareStickerCollectionViewCell()
                    cell.stickerCollectionViewCellDelegate = self
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


//MARK: - Protocols

extension HomeViewController: FeaturedCollectionViewCellDelegate, StickerCollectionViewCellDelegate {
    
    func isFeaturedHeartButtonTapped(_ value: Bool) {
        featuredHeartButtonTapped = value
    }
    
    func isStickerHeartButtonTapped(_ value: Bool) {
        stickerHeartButtonTapped = value
    }
    
}
