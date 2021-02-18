//
//  HomeViewController.swift
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
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let user = User()
    private var featuredStickerViewModel: [FeaturedStickerViewModel]?
    private var stickerCategoryViewModel = [StickerCategoryViewModel]()
    private var stickerViewModel: [StickerViewModel]?
    private let fetchStickerData = FetchStickerData()
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    private var stickerCategorySelected: String?
    private var featuredHeartButtonTapped: Bool?
    private var isLightMode = false
    
    
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
        if isLightMode {
            return .darkContent
        } else {
            return .lightContent
        }
    }
    
    func setDesignElements() {
        Utilities.setDesignOn(view: homeFeaturedView, backgroundColor: .clear)
        Utilities.setDesignOn(view: homeStickerView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: homeContentStackView, backgroundColor: .clear)
        Utilities.setDesignOn(label: homeHeading1Label, font: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), text: Strings.homeHeading1Text)
        Utilities.setDesignOn(label: homeHeading2Label, font: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), text: Strings.homeHeading2Text)
        Utilities.setDesignOn(collectionView: homeFeaturedStickerCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(collectionView: homeStickerCategoryCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(collectionView: homeStickerCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(activityIndicatorView: homeLoadingIndicatorView, size: .medium, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isHidden: true)
        checkThemeAppearance()
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        showLoadingProfilePicDesign()
    }
    
    func checkThemeAppearance() {
        if appDelegate.isLightModeOn {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        print("Light Mode Activated - HomeVC")
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: view, backgroundColor: .white)
            isLightMode = true
            setNeedsStatusBarAppearanceUpdate()
            
            homeProfilePictureButton.layer.shadowColor = UIColor.red.cgColor
            homeProfilePictureButton.layer.shadowOpacity = 1
            homeProfilePictureButton.layer.shadowOffset = CGSize(width: 5, height: 5)
            homeProfilePictureButton.layer.shadowRadius = 50
            homeProfilePictureButton.layer.masksToBounds = false
            Utilities.setDesignOn(button: homeProfilePictureButton, isCircular: true)
            
            homeHeading1Label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            homeHeading2Label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @objc func setDarkMode() {
        print("Dark Mode Activated - HomeVC")
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            isLightMode = false
            setNeedsStatusBarAppearanceUpdate()
            
            homeProfilePictureButton.layer.shadowColor = nil
            homeProfilePictureButton.layer.shadowOpacity = 0
            homeProfilePictureButton.layer.shadowOffset = .zero
            homeProfilePictureButton.layer.shadowRadius = 0
            homeProfilePictureButton.layer.masksToBounds = true
            Utilities.setDesignOn(button: homeProfilePictureButton, isCircular: true)
            
            homeHeading1Label.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            homeHeading2Label.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        }
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
    
    func showLoadingProfilePicDesign() {
        DispatchQueue.main.async { [self] in
            homeProfilePictureButton.isSkeletonable = true
            Utilities.setDesignOn(button: homeProfilePictureButton, isSkeletonCircular: true)
            homeProfilePictureButton.showAnimatedSkeleton()
        }
    }
    
    func showLoadingStickersDesign() {
        homeStickerCollectionView.isHidden = true
        homeLoadingIndicatorView.isHidden = false
        homeLoadingIndicatorView.startAnimating()
        DispatchQueue.main.async { [self] in
            homeStickerCollectionView.reloadData()
        }
    }
    
    func showStickers() {
        DispatchQueue.main.async { [self] in
            homeStickerCollectionView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            homeLoadingIndicatorView.isHidden = true
            homeStickerCollectionView.isHidden = false
        }
    }
    
    func setProfilePicture() {
        user.getSignedInUserData { [self] (error, isUserSignedIn, userData) in
            guard let error = error else {
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
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
    }
    
    func setViewPeekingBehavior(using behavior: MSCollectionViewPeekingBehavior) {
        homeFeaturedStickerCollectionView.configureForPeekingBehavior(behavior: behavior)
        behavior.cellPeekWidth = 10
        behavior.cellSpacing = 10
    }
    
    func transitionToLandingVC() {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
        view.window?.rootViewController = landingVC
        view.window?.makeKeyAndVisible()
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
        getFeaturedStickersCollectionViewData()
        getStickersCategoryCollectionViewData()
        getStickersCollectionViewData(onCategory: Strings.allStickers)
    }
    
    func getFeaturedStickersCollectionViewData() {
        fetchStickerData.featuredStickerCollectionView { [self] (error, featuredStickerData) in
            guard let error = error else {
                guard let featuredStickerData = featuredStickerData else {return}
                featuredStickerViewModel = featuredStickerData
                DispatchQueue.main.async {
                    homeFeaturedStickerCollectionView.reloadData()
                }
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
    }
    
    func getStickersCategoryCollectionViewData() {
        stickerCategoryViewModel = fetchStickerData.stickerCategory()
    }
    
    func getStickersCollectionViewData(onCategory stickerCategory: String) {
        fetchStickerData.stickerCollectionView(category: stickerCategory) { [self] (error, stickerData) in
            guard let error = error else {
                guard let stickerData = stickerData else {return}
                stickerViewModel = stickerData
                showStickers()
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
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
            guard let featuredStickerViewModel = featuredStickerViewModel else {return cell}
            DispatchQueue.main.async {
                cell.featuredStickerViewModel = featuredStickerViewModel[indexPath.row]
                cell.featuredStickerCellDelegate = self
                cell.prepareFeaturedStickerCell()
            }
            return cell
        }
        if collectionView == homeStickerCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCategoryCell, for: indexPath) as! StickerCategoryCollectionViewCell
            DispatchQueue.main.async { [self] in
                cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
                cell.setDesignElements()
            }
            return cell
        }
        if collectionView == homeStickerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCell, for: indexPath) as! StickerCollectionViewCell
            guard let stickerViewModel = stickerViewModel else {return cell}
            DispatchQueue.main.async {
                cell.stickerViewModel = stickerViewModel[indexPath.row]
                cell.prepareStickerCollectionViewCell()
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
            stickerCategoryViewModel[indexPath.row].isCategorySelected = true
            let cell = collectionView.cellForItem(at: indexPath) as! StickerCategoryCollectionViewCell
            cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
            stickerCategorySelected = stickerCategoryViewModel[indexPath.row].category
            showLoadingStickersDesign()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                getStickersCollectionViewData(onCategory: stickerCategorySelected!)
            }
        }
        if collectionView == homeStickerCollectionView {
            guard let stickerViewModel = stickerViewModel else {return}
            let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
            let stickerOptionVC = storyboard.instantiateViewController(identifier: Strings.stickerOptionVC) as! StickerOptionViewController
            DispatchQueue.main.async { [self] in
                stickerOptionVC.prepareStickerOptionVC()
                stickerOptionVC.stickerViewModel = stickerViewModel[indexPath.row]
                present(stickerOptionVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == homeStickerCategoryCollectionView {
            stickerCategoryViewModel[indexPath.row].isCategorySelected = false
            let cell = collectionView.cellForItem(at: indexPath) as! StickerCategoryCollectionViewCell
            cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.row]
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
            let stickerCollectionViewLayout = homeStickerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            stickerCollectionViewLayout.sectionInset.left = 25
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
    
    func getVC(using viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
}
