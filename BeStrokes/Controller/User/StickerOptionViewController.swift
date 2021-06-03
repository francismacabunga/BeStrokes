//
//  StickerOptionViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/5/21.
//

import UIKit
import Kingfisher

class StickerOptionViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerStackContentView: UIStackView!
    @IBOutlet weak var stickerTopView: UIView!
    @IBOutlet weak var stickerMiddleView: UIView!
    @IBOutlet weak var stickerCategoryView: UIView!
    @IBOutlet weak var stickerTagView: UIView!
    @IBOutlet weak var stickerBottomView: UIView!
    @IBOutlet weak var stickerExitImageView: UIImageView!
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var stickerNameLabel: UILabel!
    @IBOutlet weak var stickerCategoryLabel: UILabel!
    @IBOutlet weak var stickerTagLabel: UILabel!
    @IBOutlet weak var stickerDescriptionLabel: UILabel!
    @IBOutlet weak var stickerTryMeButton: UIButton!
    
    
    //MARK: - Constants / Variables
    
    private let service = Firebase()
    private var skeletonColor: UIColor?
    private var stickerOptionViewModel = StickerOptionViewModel()
    var stickerViewModel: StickerViewModel?
    var userStickerViewModel: UserStickerViewModel?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stickerOptionViewModel.setUserDefaultsTabKeys()
        setDesignElements()
        registerGestures()
        showStickerData()
        setSkeletonColor()
        showLoadingSkeletonView()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(view: stickerTopView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerMiddleView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerCategoryView, isCircular: true, isHidden: true)
        Utilities.setDesignOn(view: stickerTagView, isCircular: true, isHidden: true)
        Utilities.setDesignOn(view: stickerBottomView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: stickerStackContentView, backgroundColor: .clear)
        Utilities.setDesignOn(imageView: stickerExitImageView, image: UIImage(systemName: Strings.exitIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(imageView: stickerImageView, isHidden: true)
        Utilities.setDesignOn(imageView: stickerHeartButtonImageView, tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(label: stickerNameLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: true, minimumScaleFactor: 0.8, isHidden: true)
        Utilities.setDesignOn(label: stickerCategoryLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .center, isHidden: true)
        Utilities.setDesignOn(label: stickerTagLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .center, isHidden: true)
        Utilities.setDesignOn(label: stickerDescriptionLabel, fontName: Strings.defaultFont, fontSize: 17, numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(button: stickerTryMeButton, title: Strings.tryMeButtonText, fontName: Strings.defaultFontBold, fontSize: 20, isCircular: true, isHidden: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func checkThemeAppearance() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: stickerCategoryView, backgroundColor: .white)
            Utilities.setDesignOn(view: stickerTagView, backgroundColor: .white)
            Utilities.setDesignOn(label: stickerCategoryLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(label: stickerTagLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setShadowOn(view: stickerHeartButtonImageView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(view: stickerCategoryView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(view: stickerTagView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: stickerTryMeButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setDesignOn(button: stickerTryMeButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: stickerCategoryView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(view: stickerTagView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(label: stickerCategoryLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(label: stickerTagLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: stickerHeartButtonImageView, isHidden: true)
            Utilities.setShadowOn(view: stickerCategoryView, isHidden: true)
            Utilities.setShadowOn(view: stickerTagView, isHidden: true)
            Utilities.setShadowOn(button: stickerTryMeButton, isHidden: true)
            Utilities.setDesignOn(button: stickerTryMeButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func setSkeletonColor() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            skeletonColor = UIColor.white
        } else {
            skeletonColor = #colorLiteral(red: 0.2006691098, green: 0.200709641, blue: 0.2006634176, alpha: 1)
        }
    }
    
    func setStickerData(stickerImageName: String,
                        stickerName: String,
                        stickerCategory: String,
                        stickerTag: String,
                        stickerDescription: String)
    {
        stickerExitImageView.isHidden = false
        stickerImageView.kf.setImage(with: URL(string: stickerImageName))
        stickerImageView.isHidden = false
        Utilities.setDesignOn(label: stickerNameLabel, text: stickerName, isHidden: false)
        stickerCategoryLabel.text = stickerCategory
        stickerCategoryView.isHidden = false
        if stickerTag != Strings.tagNoStickers {
            stickerTagLabel.text = stickerTag
            stickerTagView.isHidden = false
        }
        Utilities.setDesignOn(label: stickerDescriptionLabel, text: stickerDescription, isHidden: false)
        stickerHeartButtonImageView.isHidden = false
    }
    
    func getHeartButtonValue(stickerViewModel: StickerViewModel? = nil,
                             userStickerViewModel: UserStickerViewModel? = nil)
    {
        if stickerViewModel != nil {
            checkIfStickerIsLoved(stickerViewModel!.stickerID)
        }
        if userStickerViewModel != nil {
            checkIfStickerIsLoved(userStickerViewModel!.stickerID)
        }
    }
    
    func hideLoadingSkeletonView() {
        stickerHeartButtonImageView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        stickerCategoryView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        stickerTagView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        stickerTryMeButton.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        stickerCategoryLabel.isHidden = false
        stickerTagLabel.isHidden = false
    }
    
    func showLoadingSkeletonView() {
        stickerHeartButtonImageView.isSkeletonable = true
        stickerCategoryView.isSkeletonable = true
        stickerTagView.isSkeletonable = true
        stickerTryMeButton.isSkeletonable = true
        Utilities.setDesignOn(imageView: stickerHeartButtonImageView, isSkeletonCircular: true)
        Utilities.setDesignOn(view: stickerCategoryView, isSkeletonCircular: true)
        Utilities.setDesignOn(view: stickerTagView, isSkeletonCircular: true)
        Utilities.setDesignOn(button: stickerTryMeButton, isSkeletonCircular: true, isHidden: false)
        stickerHeartButtonImageView.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
        stickerCategoryView.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
        stickerTagView.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
        stickerTryMeButton.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
        stickerHeartButtonImageView.showAnimatedSkeleton()
        stickerCategoryView.showAnimatedSkeleton()
        stickerTagView.showAnimatedSkeleton()
        stickerTryMeButton.showAnimatedSkeleton()
    }
    
    func showStickerData() {
        if stickerViewModel != nil {
            setStickerData(stickerImageName: stickerViewModel!.image,
                           stickerName: stickerViewModel!.name,
                           stickerCategory: stickerViewModel!.category,
                           stickerTag: stickerViewModel!.tag,
                           stickerDescription: stickerViewModel!.description)
            getHeartButtonValue(stickerViewModel: stickerViewModel!)
            return
        }
        if userStickerViewModel != nil {
            setStickerData(stickerImageName: userStickerViewModel!.image,
                           stickerName: userStickerViewModel!.name,
                           stickerCategory: userStickerViewModel!.category,
                           stickerTag: userStickerViewModel!.tag,
                           stickerDescription: userStickerViewModel!.description)
            getHeartButtonValue(userStickerViewModel: userStickerViewModel!)
            return
        }
    }
    
    func showAlertController(alertMessage: String, withHandler: Bool) {
        if UserDefaults.standard.bool(forKey: Strings.stickerOptionPageKey) {
            if self.presentedViewController as? UIAlertController == nil {
                if withHandler {
                    let alertWithHandler = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: true) { [weak self] in
                        guard let self = self else {return}
                        DispatchQueue.main.async {
                            _ = Utilities.transition(from: self.view, to: Strings.landingVC, onStoryboard: Strings.guestStoryboard, canAccessDestinationProperties: false)
                        }
                    }
                    show(alertWithHandler!, sender: nil)
                    return
                }
                let alert = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: false) {}
                show(alert!, sender: nil)
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func stickerOptionTryMeButton(_ sender: UIButton) {
        let captureVC = stickerOptionViewModel.captureVC(stickerViewModel, userStickerViewModel)
        present(captureVC, animated: true)
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapExitButton = UITapGestureRecognizer(target: self, action: #selector(tapToExitGestureHandler))
        let tapHeartButton = UITapGestureRecognizer(target: self, action: #selector(tapToHeartGestureHandler))
        Utilities.setDesignOn(imageView: stickerExitImageView, isUserInteractionEnabled: true, gestureRecognizer: tapExitButton)
        Utilities.setDesignOn(imageView: stickerHeartButtonImageView, isUserInteractionEnabled: true, gestureRecognizer: tapHeartButton)
    }
    
    @objc func tapToExitGestureHandler() {
        stickerOptionViewModel.setUserDefaultsOnExitButton()
        if UserDefaults.standard.bool(forKey: Strings.notificationTabKey) {
            UserDefaults.standard.setValue(true, forKey: Strings.notificationPageKey)
            if userStickerViewModel != nil {
                service.updateNewSticker(on: userStickerViewModel!.stickerID) { [weak self] (error, isUserSignedIn) in
                    guard let self = self else {return}
                    DispatchQueue.main.async {
                        if !isUserSignedIn {
                            guard let error = error else {return}
                            self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                            return
                        }
                        if error != nil {
                            self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                        }
                    }
                }
            }
        }
        dismiss(animated: true)
    }
    
    @objc func tapToHeartGestureHandler(tapGesture: UITapGestureRecognizer) {
        stickerOptionViewModel.tapToHeartGesture(with: tapGesture, on: stickerViewModel, userStickerViewModel) { [weak self] (heartButtonIsTapped, error, userIsSignedIn, untapHeartButtonProcessIsDone) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if !userIsSignedIn {
                    guard let error = error else {return}
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                    return
                }
                if error != nil {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                    return
                }
                if heartButtonIsTapped {
                    Utilities.setDesignOn(imageView: self.stickerHeartButtonImageView, image: UIImage(systemName: Strings.loveStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    if untapHeartButtonProcessIsDone {
                        self.dismiss(animated: true)
                    }
                } else {
                    Utilities.setDesignOn(imageView: self.stickerHeartButtonImageView, image: UIImage(systemName: Strings.lovedStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                }
            }
        }
    }
    
    
    //MARK: - Fetching of Sticker Data
    
    func checkIfStickerIsLoved(_ stickerID: String) {
        service.fetchLovedSticker(on: stickerID) { [weak self] (error, isUserSignedIn, isStickerLoved, _) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if !isUserSignedIn {
                    guard let error = error else {return}
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                    return
                }
                if error != nil {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                    return
                }
                guard let isStickerLoved = isStickerLoved else {return}
                if isStickerLoved {
                    Utilities.setDesignOn(imageView: self.stickerHeartButtonImageView, image: UIImage(systemName: Strings.lovedStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    self.stickerOptionViewModel.heartButtonTapped = true
                } else {
                    Utilities.setDesignOn(imageView: self.stickerHeartButtonImageView, image: UIImage(systemName: Strings.loveStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    self.stickerOptionViewModel.heartButtonTapped = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.hideLoadingSkeletonView()
                }
                
            }
        }
    }
    
}
