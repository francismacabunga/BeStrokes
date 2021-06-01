//
//  HomeViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import MSPeekCollectionViewDelegateImplementation
import SkeletonView
import Kingfisher
import UserNotifications

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var homeContentStackView: UIStackView!
    @IBOutlet weak var homeFeaturedView: UIView!
    @IBOutlet weak var homeProfilePicContentView: UIView!
    @IBOutlet weak var homeStickerView: UIView!
    @IBOutlet weak var homeHeading1Label: UILabel!
    @IBOutlet weak var homeHeading2Label: UILabel!
    @IBOutlet weak var homeProfilePictureButton: UIButton!
    @IBOutlet weak var homeFeaturedStickerCollectionView: UICollectionView!
    @IBOutlet weak var homeStickerCategoryCollectionView: UICollectionView!
    @IBOutlet weak var homeStickerCollectionView: UICollectionView!
    @IBOutlet weak var homeLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private let firebase = Firebase()
    private var homeViewModel = HomeViewModel()
    private var stickerViewModel: [StickerViewModel]?
    private var featuredStickerViewModel: [FeaturedStickerViewModel]?
    private var stickerCategoryViewModel: [StickerCategoryViewModel]!
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    private var skeletonColor: UIColor?
    private var hasProfilePicLoaded = false
    private let notificationCenter = UNUserNotificationCenter.current()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfNotificationIsPermitted()
        setDesignElements()
        setProfilePicture()
        registerCollectionView()
        setCollectionViewData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserDefaults.standard.setValue(true, forKey: Strings.homePageKey)
        checkIfUserIsSignedIn()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: homeFeaturedView, backgroundColor: .clear)
        Utilities.setDesignOn(view: homeProfilePicContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: homeStickerView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: homeContentStackView, backgroundColor: .clear)
        Utilities.setDesignOn(label: homeHeading1Label, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, text: Strings.homeHeading1Text)
        Utilities.setDesignOn(label: homeHeading2Label, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, text: Strings.homeHeading2Text)
        Utilities.setDesignOn(collectionView: homeFeaturedStickerCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(collectionView: homeStickerCategoryCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(collectionView: homeStickerCollectionView, backgroundColor: .clear, isHorizontalDirection: true, showScrollIndicator: false)
        Utilities.setDesignOn(activityIndicatorView: homeLoadingIndicatorView, size: .medium, isStartAnimating: false, isHidden: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProfilePic), name: Utilities.reloadProfilePic, object: nil)
        checkThemeAppearance()
        showLoadingProfilePicDesign()
        viewPeekingBehavior = MSCollectionViewPeekingBehavior()
        homeViewModel.setViewPeekingBehavior(using: viewPeekingBehavior, on: homeFeaturedStickerCollectionView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            return .darkContent
        } else {
            return .lightContent
        }
    }
    
    func checkThemeAppearance() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        setNeedsStatusBarAppearanceUpdate()
        if homeViewModel.shouldReloadCategoryCollectionView {
            homeViewModel.reload(homeStickerCategoryCollectionView)
        }
        UIView.animate(withDuration: 0.3) { [self] in
            if hasProfilePicLoaded {
                Utilities.setShadowOn(view: homeProfilePicContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 5)
            }
            Utilities.setDesignOn(scrollView: homeScrollView, indicatorColor: .black)
            Utilities.setDesignOn(view: view, backgroundColor: .white)
            Utilities.setDesignOn(label: homeHeading1Label, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(label: homeHeading2Label, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(activityIndicatorView: homeLoadingIndicatorView, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isStartAnimating: false, isHidden: true)
        }
    }
    
    @objc func setDarkMode() {
        setNeedsStatusBarAppearanceUpdate()
        if homeViewModel.shouldReloadCategoryCollectionView {
            homeViewModel.reload(homeStickerCategoryCollectionView)
        }
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(scrollView: homeScrollView, indicatorColor: .white)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setShadowOn(view: homeProfilePicContentView, isHidden: true)
            Utilities.setDesignOn(label: homeHeading1Label, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(label: homeHeading2Label, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(activityIndicatorView: homeLoadingIndicatorView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isStartAnimating: false, isHidden: true)
        }
    }
    
    func setSkeletonColor() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            skeletonColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        } else {
            skeletonColor = #colorLiteral(red: 0.2006691098, green: 0.200709641, blue: 0.2006634176, alpha: 1)
        }
    }
    
    @objc func reloadProfilePic() {
        setProfilePicture()
    }
    
    func showLoadingProfilePicDesign() {
        setSkeletonColor()
        homeProfilePicContentView.isSkeletonable = true
        Utilities.setDesignOn(view: homeProfilePicContentView, isSkeletonCircular: true)
        homeProfilePicContentView.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
        homeProfilePictureButton.showAnimatedSkeleton()
    }
    
    func showLoadingStickersDesign() {
        homeStickerCollectionView.isHidden = true
        Utilities.setDesignOn(activityIndicatorView: homeLoadingIndicatorView, isStartAnimating: true, isHidden: false)
        homeStickerCollectionView.reloadData()
    }
    
    func showStickers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            homeLoadingIndicatorView.isHidden = true
            homeStickerCollectionView.isHidden = false
        }
    }
    
    func showAlertController(alertMessage: String, withHandler: Bool) {
        if UserDefaults.standard.bool(forKey: Strings.homePageKey) {
            if self.presentedViewController as? UIAlertController == nil {
                if withHandler {
                    let alertWithHandler = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: true) { [weak self] in
                        guard let self = self else {return}
                        DispatchQueue.main.async {
                            _ = Utilities.transition(from: self.view, to: Strings.landingVC, onStoryboard: Strings.guestStoryboard, canAccessDestinationProperties: false)
                        }
                    }
                    present(alertWithHandler!, animated: true)
                    return
                }
                let alert = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: false) {}
                present(alert!, animated: true)
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func homeProfilePictureButton(_ sender: UIButton) {
        let profileVC = homeViewModel.profileVC()
        present(profileVC, animated: true)
    }
    
    
    //MARK: - Fetching of User Data
    
    func setProfilePicture() {
        firebase.getSignedInUserData { [weak self] (error, isUserSignedIn, userData) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                }
                return
            }
            guard let userData = userData else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.homeProfilePictureButton.kf.setBackgroundImage(with: URL(string: userData.profilePic), for: .normal)
                Utilities.setDesignOn(button: self.homeProfilePictureButton, backgroundColor: .clear, isCircular: true)
                self.homeProfilePicContentView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
                self.hasProfilePicLoaded = true
                if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
                    Utilities.setShadowOn(view: self.homeProfilePicContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 5)
                }
            }
        }
    }
    
    func checkIfUserIsSignedIn() {
        firebase.checkIfUserIsSignedIn { [weak self] (error, isUserSignedIn, _) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
        }
    }
    
    
    //MARK: - Fetching of Collection View Data
    
    func getFeaturedStickersCollectionViewData() {
        homeViewModel.fetchFeaturedSticker { [weak self] (error, featuredStickerData) in
            guard let self = self else {return}
            guard let error = error else {
                guard let featuredStickerData = featuredStickerData else {return}
                DispatchQueue.main.async {
                    self.featuredStickerViewModel = featuredStickerData
                    self.homeFeaturedStickerCollectionView.reloadData()
                }
                return
            }
            DispatchQueue.main.async {
                self.showAlertController(alertMessage: error.localizedDescription, withHandler: false)
            }
        }
    }
    
    func getStickersCategoryCollectionViewData() {
        stickerCategoryViewModel = homeViewModel.stickerCategory()
        homeStickerCategoryCollectionView.reloadData()
        homeViewModel.setInitialSelectedCell(on: homeStickerCategoryCollectionView)
    }
    
    func getStickersCollectionViewData(onCategory stickerCategory: String) {
        homeViewModel.fetchSticker(onCategory: stickerCategory) { [weak self] (error, stickerData) in
            guard let self = self else {return}
            guard let error = error else {
                guard let stickerData = stickerData else {return}
                DispatchQueue.main.async {
                    self.stickerViewModel = stickerData
                    self.homeStickerCollectionView.reloadData()
                    self.changeStickerStatusOnFirstTimeLogin(using: stickerData)
                    self.setStickerDataToUserID(using: stickerData)
                    self.removeDeletedStickersInUserCollection()
                    self.showBannerNotification()
                    self.updateBadgeCounter()
                    self.showStickers()
                }
                return
            }
            DispatchQueue.main.async {
                self.showAlertController(alertMessage: error.localizedDescription, withHandler: false)
            }
        }
    }
    
    
    //MARK: - Sticker Maintenance Functions
    
    func changeStickerStatusOnFirstTimeLogin(using stickerData: [StickerViewModel]) {
        if UserDefaults.standard.bool(forKey: Strings.userFirstTimeLoginKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.userFirstTimeLoginKey)
            homeViewModel.uploadStickerInUserCollection(from: stickerData, isRecentlyUploaded: false, isNew: false) { [weak self] (error, isUserSignedIn) in
                guard let self = self else {return}
                if !isUserSignedIn {
                    guard let error = error else {return}
                    DispatchQueue.main.async {
                        self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                    }
                    return
                }
                if error != nil {
                    DispatchQueue.main.async {
                        self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                    }
                }
            }
        }
    }
    
    func setStickerDataToUserID(using stickerViewModel: [StickerViewModel]) {
        if !UserDefaults.standard.bool(forKey: Strings.userFirstTimeLoginKey) {
            homeViewModel.checkIfStickerExistsInUserCollection(stickerViewModel: stickerViewModel) { [weak self] (error, isUserSignedIn, isStickerPresent, newSticker) in
                guard let self = self else {return}
                if !isUserSignedIn {
                    guard let error = error else {return}
                    DispatchQueue.main.async {
                        self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                    }
                    return
                }
                if error != nil {
                    DispatchQueue.main.async {
                        self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                    }
                    return
                }
                if isStickerPresent != nil {
                    if !isStickerPresent! {
                        guard let newSticker = newSticker else {return}
                        DispatchQueue.main.async {
                            self.uploadStickerInUserCollection(using: [newSticker])
                        }
                    }
                }
            }
        }
    }
    
    func uploadStickerInUserCollection(using stickerViewModel: [StickerViewModel]) {
        homeViewModel.uploadStickerInUserCollection(from: stickerViewModel, isRecentlyUploaded: true, isNew: true) { [weak self] (error, isUserSignedIn) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                }
            }
        }
    }
    
    func removeDeletedStickersInUserCollection() {
        homeViewModel.checkIfUserStickerExistsInStickerCollection { [weak self] (error, isUserSignedIn) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                }
            }
        }
    }
    
    
    //MARK: - In-App Notification Process
    
    func checkIfNotificationIsPermitted() {
        homeViewModel.checkIfNotificationIsPermitted { [weak self] (error) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.showAlertController(alertMessage: error.localizedDescription, withHandler: false)
            }
        }
    }
    
    func showBannerNotification() {
        homeViewModel.fetchRecentlyUploadedSticker { [weak self] (error, isUserSignedIn, userStickerData) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                }
                return
            }
            guard let userStickerData = userStickerData else {return}
            DispatchQueue.main.async {
                self.triggerNotification()
                self.updateRecentlyUploadedSticker(using: userStickerData.stickerID)
            }
        }
    }
    
    func updateRecentlyUploadedSticker(using stickerID: String) {
        homeViewModel.updateRecentlyUploadedSticker(on: stickerID) { [weak self] (error, isUserSignedIn) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                }
                return
            }
        }
    }
    
    func updateBadgeCounter() {
        firebase.fetchNewSticker { [weak self] (error, isUserSignedIn, numberOfNewStickers, _) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                }
                return
            }
            guard let numberOfNewStickers = numberOfNewStickers else {return}
            UserDefaults.standard.setValue(numberOfNewStickers, forKey: Strings.notificationBadgeCounterKey)
            NotificationCenter.default.post(name: Utilities.setBadgeCounterToNotificationIcon, object: nil)
        }
    }
    
    func triggerNotification() {
        let notificationRequest = homeViewModel.notificationRequest()
        notificationCenter.add(notificationRequest) { [weak self] (error) in
            guard let self = self else {return}
            guard let error = error else {return}
            DispatchQueue.main.async {
                self.showAlertController(alertMessage: error.localizedDescription, withHandler: false)
            }
        }
    }
    
    
    //MARK: - Collection View Process
    
    func registerCollectionView() {
        setDataSourceAndDelegate()
        registerNIB()
    }
    
    func setDataSourceAndDelegate() {
        homeFeaturedStickerCollectionView.dataSource = self
        homeStickerCategoryCollectionView.dataSource = self
        homeStickerCollectionView.dataSource = self
        homeFeaturedStickerCollectionView.delegate = self
        homeStickerCategoryCollectionView.delegate = self
        homeStickerCollectionView.delegate = self
        notificationCenter.delegate = self
    }
    
    func registerNIB() {
        homeFeaturedStickerCollectionView.register(UINib(nibName: Strings.featuredStickerCell, bundle: nil), forCellWithReuseIdentifier: Strings.featuredStickerCell)
        homeStickerCategoryCollectionView.register(UINib(nibName: Strings.stickerCategoryCell, bundle: nil), forCellWithReuseIdentifier: Strings.stickerCategoryCell)
        homeStickerCollectionView.register(UINib(nibName: Strings.stickerCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Strings.stickerCollectionViewCell)
    }
    
    func setCollectionViewData() {
        getFeaturedStickersCollectionViewData()
        getStickersCategoryCollectionViewData()
        getStickersCollectionViewData(onCategory: Strings.allStickers)
    }
    
}


//MARK: - Collection View Data Source

extension HomeViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == homeFeaturedStickerCollectionView {
            return Strings.featuredStickerCell
        }
        if skeletonView == homeStickerCollectionView {
            return Strings.stickerCollectionViewCell
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
            let featuredStickerCell = homeViewModel.featuredStickerCell(homeFeaturedStickerCollectionView, indexPath)
            guard let featuredStickerViewModel = featuredStickerViewModel else {return featuredStickerCell}
            homeViewModel.setup(featuredStickerCell, indexPath, featuredStickerViewModel, self)
            return featuredStickerCell
        }
        if collectionView == homeStickerCategoryCollectionView {
            let stickerCategoryCell = homeViewModel.setupStickerCategoryCell(homeStickerCategoryCollectionView, indexPath, stickerCategoryViewModel)
            return stickerCategoryCell
        }
        if collectionView == homeStickerCollectionView {
            let stickerCell = homeViewModel.stickerCell(homeStickerCollectionView, indexPath)
            guard let stickerViewModel = stickerViewModel else {return stickerCell}
            homeViewModel.setup(stickerCell, indexPath, stickerViewModel)
            return stickerCell
        }
        return UICollectionViewCell()
    }
    
}


//MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == homeStickerCategoryCollectionView {
            let selectedStickerCategory = homeViewModel.selectStickerCategory(homeStickerCategoryCollectionView, indexPath, &stickerCategoryViewModel)!
            showLoadingStickersDesign()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                getStickersCollectionViewData(onCategory: selectedStickerCategory)
            }
        }
        if collectionView == homeStickerCollectionView {
            guard let stickerViewModel = stickerViewModel else {return}
            let stickerOptionVC = homeViewModel.stickerOptionVC(stickerViewModel, indexPath)
            present(stickerOptionVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == homeStickerCategoryCollectionView {
            homeViewModel.deselectStickerCategory(homeStickerCategoryCollectionView, indexPath, &stickerCategoryViewModel)
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
            Utilities.setMeasurementsOn(collectionViewFlowLayout: stickerCategoryCollectionViewLayout, leftSectionInset: 25, rightSectionInset: 10, minimumLineSpacing: 10)
            return CGSize(width: 105, height: 40)
        }
        if collectionView == homeStickerCollectionView {
            let stickerCollectionViewLayout = homeStickerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            Utilities.setMeasurementsOn(collectionViewFlowLayout: stickerCollectionViewLayout, leftSectionInset: 25, rightSectionInset: 10)
            return CGSize(width: 145, height: 145)
        }
        return CGSize()
    }
    
}


//MARK: - Featured Sticker Cell Delegate

extension HomeViewController: FeaturedStickerCellDelegate {
    
    func getVC(using viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
}


//MARK: - Notifications

extension HomeViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
}
