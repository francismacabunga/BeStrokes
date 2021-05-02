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
    
    private let userData = UserData()
    private let stickerData = StickerData()
    private var stickerViewModel: [StickerViewModel]?
    private var featuredStickerViewModel: [FeaturedStickerViewModel]?
    private var stickerCategoryViewModel = [StickerCategoryViewModel]()
    private var viewPeekingBehavior: MSCollectionViewPeekingBehavior!
    private var stickerCategorySelected: String?
    private var selectedIndexPath: IndexPath?
    private var shouldReloadStickerCategoryCollectionView = false
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
        
        UserDefaults.standard.setValue(true, forKey: Strings.isHomeVCLoadedKey)
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
        setViewPeekingBehavior(using: viewPeekingBehavior)
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
        if shouldReloadStickerCategoryCollectionView {
            reloadStickerCategoryCollection()
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
        if shouldReloadStickerCategoryCollectionView {
            reloadStickerCategoryCollection()
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
    
    func reloadStickerCategoryCollection() {
        homeStickerCategoryCollectionView.reloadData()
        homeStickerCategoryCollectionView.selectItem(at: selectedIndexPath!, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func setInitalSelectedCategoryCell() {
        selectedIndexPath = IndexPath(item: 0, section: 0)
        homeStickerCategoryCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .right)
        shouldReloadStickerCategoryCollectionView = true
    }
    
    func setViewPeekingBehavior(using behavior: MSCollectionViewPeekingBehavior) {
        homeFeaturedStickerCollectionView.configureForPeekingBehavior(behavior: behavior)
        behavior.cellPeekWidth = 15
        behavior.cellSpacing = 5
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
    
    func showAlertController(alertMessage: String,
                             withHandler: Bool)
    {
        if UserDefaults.standard.bool(forKey: Strings.isHomeVCLoadedKey) {
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
        let profileVC = Utilities.transition(to: Strings.profileVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! ProfileViewController
        profileVC.modalPresentationStyle = .popover
        present(profileVC, animated: true)
    }
    
    
    //MARK: - Fetching of User Data
    
    func setProfilePicture() {
        userData.getSignedInUserData { [weak self] (error, isUserSignedIn, userData) in
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
        userData.checkIfUserIsSignedIn { [weak self] (error, isUserSignedIn, _) in
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
        stickerData.fetchFeaturedSticker { [weak self] (error, featuredStickerData) in
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
        stickerCategoryViewModel = stickerData.fetchStickerCategories()
        homeStickerCategoryCollectionView.reloadData()
        setInitalSelectedCategoryCell()
    }
    
    func getStickersCollectionViewData(onCategory stickerCategory: String) {
        stickerData.fetchSticker(onCategory: stickerCategory) { [weak self] (error, stickerData) in
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
            self.stickerData.uploadStickerInUserCollection(from: stickerData, isRecentlyUploaded: false, isNew: false) { [weak self] (error, isUserSignedIn) in
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
            self.stickerData.checkIfStickerExistsInUserCollection(stickerViewModel: stickerViewModel) { [weak self] (error, isUserSignedIn, isStickerPresent, newSticker) in
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
        stickerData.uploadStickerInUserCollection(from: stickerViewModel, isRecentlyUploaded: true, isNew: true) { [weak self] (error, isUserSignedIn) in
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
        stickerData.checkIfUserStickerExistsInStickerCollection { [weak self] (error, isUserSignedIn) in
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
        Utilities.checkIfNotificationIsPermitted { [weak self] (permission) in
            guard let self = self else {return}
            if !permission {
                let options: UNAuthorizationOptions = [.alert, .sound]
                self.requestAuthorization(options)
            }
        }
    }
    
    func requestAuthorization(_ options: UNAuthorizationOptions) {
        notificationCenter.requestAuthorization(options: options) { (isPermissionGranted, error) in
            guard let error = error else {
                if isPermissionGranted {
                    UserDefaults.standard.setValue(true, forKey: Strings.notificationKey)
                } else {
                    UserDefaults.standard.setValue(false, forKey: Strings.notificationKey)
                }
                return
            }
            DispatchQueue.main.async { [self] in
                showAlertController(alertMessage: error.localizedDescription, withHandler: false)
            }
        }
    }
    
    func showBannerNotification() {
        stickerData.fetchRecentlyUploadedSticker { [weak self] (error, isUserSignedIn, userStickerData) in
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
        stickerData.updateRecentlyUploadedSticker(on: stickerID) { [weak self] (error, isUserSignedIn) in
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
        stickerData.fetchNewSticker { [weak self] (error, isUserSignedIn, numberOfNewStickers, _) in
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
        let notificationIdentifier = Strings.notificationIdentifier
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = Strings.notificationTitle
        notificationContent.body = Strings.notificationBody
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: notificationTrigger)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.featuredStickerCell, for: indexPath) as! FeaturedStickerCollectionViewCell
            guard let featuredStickerViewModel = featuredStickerViewModel else {return cell}
            cell.prepareFeaturedStickerCell()
            cell.featuredStickerViewModel = featuredStickerViewModel[indexPath.item]
            cell.featuredStickerCellDelegate = self
            return cell
        }
        if collectionView == homeStickerCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCategoryCell, for: indexPath) as! StickerCategoryCollectionViewCell
            cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.item]
            cell.setDesignElements()
            return cell
        }
        if collectionView == homeStickerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCollectionViewCell, for: indexPath) as! StickerCollectionViewCell
            guard let stickerViewModel = stickerViewModel else {return cell}
            cell.prepareStickerCell()
            cell.stickerViewModel = stickerViewModel[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
}


//MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == homeStickerCategoryCollectionView {
            selectedIndexPath = indexPath
            stickerCategoryViewModel[indexPath.item].isCategorySelected = true
            stickerCategorySelected = stickerCategoryViewModel[indexPath.item].category
            guard let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell else {return}
            cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.item]
            showLoadingStickersDesign()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                getStickersCollectionViewData(onCategory: stickerCategorySelected!)
            }
        }
        if collectionView == homeStickerCollectionView {
            UserDefaults.standard.setValue(false, forKey: Strings.isHomeVCLoadedKey)
            guard let stickerViewModel = stickerViewModel else {return}
            let stickerOptionVC = Utilities.transition(to: Strings.stickerOptionVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! StickerOptionViewController
            stickerOptionVC.stickerViewModel = stickerViewModel[indexPath.item]
            stickerOptionVC.modalPresentationStyle = .fullScreen
            present(stickerOptionVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == homeStickerCategoryCollectionView {
            stickerCategoryViewModel[indexPath.item].isCategorySelected = false
            guard let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell else {
                DispatchQueue.main.async { [self] in
                    homeStickerCategoryCollectionView.reloadData()
                    homeStickerCategoryCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
                }
                return
            }
            cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.item]
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
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
}


//MARK: - Notifications

extension HomeViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
}
