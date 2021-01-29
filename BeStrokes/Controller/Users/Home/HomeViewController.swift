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
    @IBOutlet weak var homeHeading1Label: UILabel!
    @IBOutlet weak var homeHeading2Label: UILabel!
    @IBOutlet weak var homeProfilePictureButton: UIButton!
    @IBOutlet weak var homeFeaturedStickerCollectionView: UICollectionView!
    @IBOutlet weak var homeStickerCategoryCollectionView: UICollectionView!
    @IBOutlet weak var homeStickerCollectionView: UICollectionView!
    @IBOutlet weak var homeLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private var featuredStickerViewModel: [FeaturedStickerViewModel]?
    private var stickerCategoryViewModel = [StickerCategoryViewModel]()
    private var stickerViewModel: [StickerViewModel]?
    private let user = User()
    private let fetchStickerData = FetchStickerData()
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    private var stickerCategorySelected: String?
    private var featuredHeartButtonTapped: Bool?
    private var alertControllerErrorMessage: String?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setProfilePicture()
        registerCollectionView()
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
        homeLoadingIndicatorView.isHidden = true
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: homeFeaturedView, backgroundColor: .clear)
        Utilities.setDesignOn(view: homeStickerView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: homeContentStackView, backgroundColor: .clear)
        DispatchQueue.main.async { [self] in
            homeProfilePictureButton.isSkeletonable = true
            Utilities.setDesignOn(button: homeProfilePictureButton, isSkeletonCircular: true)
            homeProfilePictureButton.showAnimatedSkeleton()
        }
        Utilities.setDesignOn(label: homeHeading1Label, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, text: Strings.homeHeading1Text)
        Utilities.setDesignOn(label: homeHeading2Label, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, text: Strings.homeHeading2Text)
        Utilities.setDesignOn(collectionView: homeFeaturedStickerCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(collectionView: homeStickerCategoryCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(collectionView: homeStickerCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(activityIndicatorView: homeLoadingIndicatorView, size: .medium, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
    }
    
    func showErrorFetchingAlert(usingError error: Bool, withErrorMessage: Error? = nil, withCustomizedString: String? = nil) {
        var alert = UIAlertController()
        if error {
            alert = UIAlertController(title: Strings.homeAlertTitle, message: withErrorMessage?.localizedDescription, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: Strings.homeAlertTitle, message: withCustomizedString, preferredStyle: .alert)
        }
        let tryAgainAction = UIAlertAction(title: Strings.homeAlert1Action, style: .default) { [self] (alertAction) in
            dismiss(animated: true)
        }
        alert.addAction(tryAgainAction)
        present(alert, animated: true)
    }
    
    func showNoSignedInUserAlert() {
        let alert = UIAlertController(title: Strings.homeAlertTitle, message: Strings.homeAlertMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Strings.homeAlert2Action, style: .default) { [self] (alertAction) in
            transitionToLandingVC()
        }
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    func transitionToLandingVC() {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
        view.window?.rootViewController = landingVC
        view.window?.makeKeyAndVisible()
    }
    
    func setProfilePicture() {
        user.getSignedInUserData { [self] (error, isUserSignedIn, userData) in
            if error != nil {
                showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
                return
            }
            guard let isUserSignedIn = isUserSignedIn else {return}
            if !isUserSignedIn {
                showNoSignedInUserAlert()
                return
            }
            guard let userData = userData else {return}
            DispatchQueue.main.async { [self] in
                homeProfilePictureButton.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
                Utilities.setDesignOn(button: homeProfilePictureButton, isCircular: true)
                homeProfilePictureButton.kf.setBackgroundImage(with: URL(string: userData.profilePic), for: .normal)
            }
        }
    }
    
    func setViewPeekingBehavior(using behavior: MSCollectionViewPeekingBehavior) {
        homeFeaturedStickerCollectionView.configureForPeekingBehavior(behavior: behavior)
        behavior.cellPeekWidth = 10
        behavior.cellSpacing = 10
    }
    
    
    //MARK: - Collection View Process
    
    func registerCollectionView() {
        setDataSourceAndDelegate()
        registerNib()
        viewPeekingBehavior = MSCollectionViewPeekingBehavior()
        setViewPeekingBehavior(using: viewPeekingBehavior)
    }
    
    func setDataSourceAndDelegate() {
        homeFeaturedStickerCollectionView.dataSource = self
        homeStickerCategoryCollectionView.dataSource = self
        homeStickerCollectionView.dataSource = self
        homeFeaturedStickerCollectionView.delegate = self
        homeStickerCategoryCollectionView.delegate = self
        homeStickerCollectionView.delegate = self
    }
    
    func registerNib() {
        homeFeaturedStickerCollectionView.register(UINib(nibName: Strings.featuredStickerCell, bundle: nil), forCellWithReuseIdentifier: Strings.featuredStickerCell)
        homeStickerCategoryCollectionView.register(UINib(nibName: Strings.stickerCategoryCell, bundle: nil), forCellWithReuseIdentifier: Strings.stickerCategoryCell)
        homeStickerCollectionView.register(UINib(nibName: Strings.stickerCell, bundle: nil), forCellWithReuseIdentifier: Strings.stickerCell)
    }
    
    func setCollectionViewData() {
        getFeaturedCollectionViewData()
        getStickerCategoryCollectionViewData()
        getStickerCollectionViewData(onCategory: Strings.allStickers)
    }
    
    func getFeaturedCollectionViewData() {
        fetchStickerData.featuredCollectionView { [self] (error, result) in
            if error != nil {
                showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
                return
            }
            guard let result = result else {return}
            featuredStickerViewModel = result
            DispatchQueue.main.async {
                homeFeaturedStickerCollectionView.reloadData()
            }
        }
    }
    
    func getStickerCategoryCollectionViewData() {
        let stickerCategory = fetchStickerData.stickerCategory()
        stickerCategoryViewModel = stickerCategory
    }
    
    func getStickerCollectionViewData(onCategory stickerCategory: String) {
        fetchStickerData.stickerCollectionView(category: stickerCategory) { [self] (error, result) in
            if error != nil {
                showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
                return
            }
            guard let result = result else {return}
            stickerViewModel = result
            DispatchQueue.main.async {
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
        if skeletonView == homeFeaturedStickerCollectionView {
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
        if collectionView == homeFeaturedStickerCollectionView {
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
        if collectionView == homeFeaturedStickerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.featuredStickerCell, for: indexPath) as! FeaturedStickerCollectionViewCell
            if featuredStickerViewModel != nil {
                DispatchQueue.main.async() { [self] in
                    cell.featuredStickerCellDelegate = self
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
            homeLoadingIndicatorView.startAnimating()
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
                let stickerOptionVC = storyboard.instantiateViewController(identifier: Strings.stickerOptionVC) as! StickerOptionViewController
                stickerOptionVC.setDesignElements()
                stickerOptionVC.registerGestures()
                stickerOptionVC.setStickerData(using: stickerViewModel![indexPath.row])
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


//MARK: - Featured Sticker Cell Delegate

extension HomeViewController: FeaturedStickerCellDelegate {
    
    func getError(using error: Error) {
        showErrorFetchingAlert(usingError: true, withErrorMessage: error)
    }
    
    func getUserAuthenticationState(with isUserSignedIn: Bool) {
        if !isUserSignedIn {
            showNoSignedInUserAlert()
        }
    }
    
}
