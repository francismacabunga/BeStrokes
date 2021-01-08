//
//  HomeController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import Firebase
import MSPeekCollectionViewDelegateImplementation
import SkeletonView
import Kingfisher

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var homeContentStackView: UIStackView!
    @IBOutlet weak var homeFeaturedView: UIView!
    @IBOutlet weak var homeStickerView: UIView!
    @IBOutlet weak var homeProfilePictureImageView: UIImageView!
    @IBOutlet weak var homeFeaturedHeadingLabel: UILabel!
    @IBOutlet weak var homeStickerHeadingLabel: UILabel!
    @IBOutlet weak var homeFeaturedCollectionView: UICollectionView!
    @IBOutlet weak var homeStickerCategoryCollectionView: UICollectionView!
    @IBOutlet weak var homeStickerCollectionView: UICollectionView!
    @IBOutlet weak var homeLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private var featuredStickerViewModel: [FeaturedStickerViewModel]?
    private var stickerCategoryViewModel = [StickerCategoryViewModel]()
    private var stickerViewModel: [StickerViewModel]?
    
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    private let user = User()
    private let fetchStickerData = FetchStickerData()
    private let fetchCategoryData = FetchCategoryData()
    private let heartButtonLogic = HeartButtonLogic()
    
    private var stickerCategorySelected: String?
    private var featuredHeartButtonTapped: Bool?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        registerGestures()
        registerCollectionView()
        setProfilePicture()
        setCollectionViewData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        homeStickerCategoryCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .right)
    }
    
    
    //MARK: - Design Elements
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setDesignElements() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        Utilities.setDesignOn(view: view, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: homeFeaturedView, color: .clear)
        Utilities.setDesignOn(view: homeStickerView, color: .clear)
        Utilities.setDesignOn(stackView: homeContentStackView, color: .clear)
        
        Utilities.setDesignOn(imageView: homeProfilePictureImageView, isCircular: true)
        
        DispatchQueue.main.async { [self] in
            homeProfilePictureImageView.isSkeletonable = true
            Utilities.setDesignOn(imageView: homeProfilePictureImageView, isCircularSkeleton: true)
            homeProfilePictureImageView.showAnimatedSkeleton()
        }
        
        Utilities.setDesignOn(homeFeaturedHeadingLabel, label: Strings.featuredHeadingText, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1)
        Utilities.setDesignOn(homeStickerHeadingLabel, label: Strings.stickerHeadingText, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1)
        
        Utilities.setDesignOn(collectionView: homeFeaturedCollectionView, isTransparent: true, isHorizontalDirection: true, showIndicator: false)
        Utilities.setDesignOn(collectionView: homeStickerCategoryCollectionView, isTransparent: true, isHorizontalDirection: true, showIndicator: false)
        Utilities.setDesignOn(collectionView: homeStickerCollectionView, isTransparent: true, isHorizontalDirection: true, showIndicator: false)
        
        Utilities.setDesignOn(activityIndicatorView: homeLoadingIndicatorView, size: .medium, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        homeLoadingIndicatorView.startAnimating()
        homeLoadingIndicatorView.isHidden = true
    }
    
    func setProfilePicture() {
        user.getSignedInUserData { (result) in
            let profilePicImageURL = result.profilePic
            DispatchQueue.main.async { [self] in
                homeProfilePictureImageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
                homeProfilePictureImageView.kf.setImage(with: profilePicImageURL)
            }
        }
    }
    
    func setViewPeekingBehavior(using behavior: MSCollectionViewPeekingBehavior) {
        homeFeaturedCollectionView.configureForPeekingBehavior(behavior: behavior)
        behavior.cellPeekWidth = 10
        behavior.cellSpacing = 10
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        homeProfilePictureImageView.addGestureRecognizer(tapGesture)
        homeProfilePictureImageView.isUserInteractionEnabled = true
        
        let featuredDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(featuredDoubleTapGestureHandler))
        featuredDoubleTapGesture.numberOfTapsRequired = 2
        homeFeaturedCollectionView.addGestureRecognizer(featuredDoubleTapGesture)
        
    }
    
    @objc func tapGestureHandler() {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let profileVC = storyboard.instantiateViewController(identifier: Strings.profileVC) as! ProfileViewController
        present(profileVC, animated: true)
        
    }
    
    @objc func featuredDoubleTapGestureHandler(doubleTap: UITapGestureRecognizer) {
        
        let doubleTapLocation = doubleTap.location(in: homeFeaturedCollectionView)
        guard let cellIndexPath = homeFeaturedCollectionView.indexPathForItem(at: doubleTapLocation) else {return}
        if featuredStickerViewModel != nil {
            let stickerDocumentID = featuredStickerViewModel![cellIndexPath.row].stickerDocumentID
            if featuredHeartButtonTapped != nil {
                if featuredHeartButtonTapped! {
                    heartButtonLogic.removeUserData(using: stickerDocumentID)
                } else {
                    heartButtonLogic.saveUserData(using: stickerDocumentID)
                }
            }
        }
        
    }
    
    
    //MARK: - Collection View Process
    
    func registerCollectionView() {
        
        setDataSourceAndDelegate()
        registerNib()
        
        viewPeekingBehavior = MSCollectionViewPeekingBehavior()
        setViewPeekingBehavior(using: viewPeekingBehavior)
        
    }
    
    func setDataSourceAndDelegate() {
        homeFeaturedCollectionView.dataSource = self
        homeStickerCategoryCollectionView.dataSource = self
        homeStickerCollectionView.dataSource = self
        
        homeFeaturedCollectionView.delegate = self
        homeStickerCategoryCollectionView.delegate = self
        homeStickerCollectionView.delegate = self
    }
    
    func registerNib() {
        homeFeaturedCollectionView.register(UINib(nibName: Strings.featuredStickerCell, bundle: nil), forCellWithReuseIdentifier: Strings.featuredStickerCell)
        homeStickerCategoryCollectionView.register(UINib(nibName: Strings.stickerCategoryCell, bundle: nil), forCellWithReuseIdentifier: Strings.stickerCategoryCell)
        homeStickerCollectionView.register(UINib(nibName: Strings.stickerCell, bundle: nil), forCellWithReuseIdentifier: Strings.stickerCell)
    }
    
    func setCollectionViewData() {
        getFeaturedCollectionViewData()
        getStickerCategoryCollectionViewData()
        getStickerCollectionViewData(onCategory: Strings.allStickers)
    }
    
    func getFeaturedCollectionViewData() {
        fetchStickerData.forFeaturedCollectionView() { [self] (result) in
            featuredStickerViewModel = result
            DispatchQueue.main.async {
                homeFeaturedCollectionView.reloadData()
            }
        }
    }
    
    func getStickerCategoryCollectionViewData() {
        let stickerCategory = fetchCategoryData.stickerCategory()
        stickerCategoryViewModel = stickerCategory
    }
    
    func getStickerCollectionViewData(onCategory stickerCategory: String) {
        
        fetchStickerData.forStickerCollectionView(category: stickerCategory) { [self] (result) in
            stickerViewModel = result
            DispatchQueue.main.async { [self] in
                homeStickerCollectionView.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                homeLoadingIndicatorView.isHidden = true
                homeStickerCollectionView.isHidden = false
            }
        }
        
    }
    
}


//MARK: - Collection View Data Source

extension HomeViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        if skeletonView == homeFeaturedCollectionView {
            return Strings.featuredStickerCell
        }
        if skeletonView == homeStickerCollectionView {
            return Strings.stickerCell
        }
        
        return ReusableCellIdentifier()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == homeFeaturedCollectionView {
            return featuredStickerViewModel?.count ?? 2
        }
        if collectionView == homeStickerCategoryCollectionView {
            return stickerCategoryViewModel.count
        }
        if collectionView == homeStickerCollectionView {
            return stickerViewModel?.count ?? 6
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == homeFeaturedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.featuredStickerCell, for: indexPath) as! FeaturedCollectionViewCell
            if featuredStickerViewModel != nil {
                DispatchQueue.main.async() { [self] in
                    cell.featuredStickerViewModel = featuredStickerViewModel![indexPath.row]
                    cell.prepareFeatureCollectionViewCell()
                }
                return cell
            }
            return cell
        }
        
        if collectionView == homeStickerCategoryCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCategoryCell, for: indexPath) as? StickerCategoryCollectionViewCell {
                DispatchQueue.main.async { [self] in
                    cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
                    cell.setDesignElements()
                }
                return cell
            }
        }
        
        if collectionView == homeStickerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCell, for: indexPath) as! StickerCollectionViewCell
            if stickerViewModel != nil {
                DispatchQueue.main.async { [self] in
                    cell.stickerViewModel = stickerViewModel![indexPath.row]
                    cell.prepareStickerCollectionViewCell()
                }
                return cell
            }
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
}


//MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == homeStickerCategoryCollectionView {
            stickerCategorySelected = stickerCategoryViewModel[indexPath.row].category
            stickerCategoryViewModel[indexPath.row].isCategorySelected = true
            stickerCategoryViewModel[0].selectedOnStart = false
            
            if let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell {
                cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
            }
            
            homeStickerCollectionView.isHidden = true
            homeLoadingIndicatorView.isHidden = false
            
            DispatchQueue.main.async { [self] in
                homeStickerCollectionView.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                getStickerCollectionViewData(onCategory: stickerCategorySelected!)
            }
        }
        
        if collectionView == homeStickerCollectionView {
            if stickerViewModel != nil {
                let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
                let stickerOptionVC = storyboard.instantiateViewController(identifier: Strings.stickerOptionCell) as! StickerOptionViewController
                stickerOptionVC.stickerViewModel = stickerViewModel![indexPath.row]
                present(stickerOptionVC, animated: true)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == homeStickerCategoryCollectionView {
            stickerCategoryViewModel[indexPath.row].isCategorySelected = false
            if let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell {
                cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
            }
        }
        
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
        
        if collectionView == homeStickerCategoryCollectionView {
            let stickerCategoryCollectionViewLayout = homeStickerCategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            stickerCategoryCollectionViewLayout.sectionInset.left = 25
            return CGSize(width: 100, height: 30)
        }
        
        if collectionView == homeStickerCollectionView {
            let stickersCollectionViewLayout = homeStickerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            stickersCollectionViewLayout.sectionInset.left = 25
            return CGSize(width: 140, height: 140)
        }
        
        return CGSize()
        
    }
    
}
