//
//  CaptureViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 9/21/20.
//

import UIKit
import ARKit
import Kingfisher

class CaptureViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var captureSceneView: ARSCNView!
    @IBOutlet weak var captureVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var captureStackView: UIStackView!
    @IBOutlet weak var captureTutorialContentView: UIView!
    @IBOutlet weak var captureStickerContentView: UIView!
    @IBOutlet weak var capture1SpacerView: UIView!
    @IBOutlet weak var capture2SpacerView: UIView!
    @IBOutlet weak var captureExitButtonImageView: UIImageView!
    @IBOutlet weak var captureDeleteButtonImageView: UIImageView!
    @IBOutlet weak var captureChooseImageButtonImageView: UIImageView!
    @IBOutlet weak var captureTutorialImageView: UIImageView!
    @IBOutlet weak var captureStickerImageView: UIImageView!
    @IBOutlet weak var captureTutorial1Label: UILabel!
    @IBOutlet weak var captureTutorial2Label: UILabel!
    @IBOutlet weak var captureTutorial3Label: UILabel!
    @IBOutlet weak var captureStickerLabel: UILabel!
    @IBOutlet weak var captureStickerNameLabel: UILabel!
    @IBOutlet weak var captureDontShowAgainButton: UIButton!
    @IBOutlet weak var captureTutorialContentViewTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - Constants / Variables
    
    private let firebase = Firebase()
    private let imagePicker = UIImagePickerController()
    var captureViewModel = CaptureViewModel()
    var featuredStickerViewModel: FeaturedStickerViewModel? {
        didSet {
            guard let featuredStickerData = featuredStickerViewModel else {return}
            downloadStickerImage(using: featuredStickerData.image)
        }
    }
    var stickerViewModel: StickerViewModel? {
        didSet {
            guard let stickerData = stickerViewModel else {return}
            downloadStickerImage(using: stickerData.image)
        }
    }
    var userStickerViewModel: UserStickerViewModel? {
        didSet {
            guard let userStickerData = userStickerViewModel else {return}
            downloadStickerImage(using: userStickerData.image)
        }
    }
    
    
    //MARK: - View Controller Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        registerGestures()
        setDataSourceAndDelegate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureViewModel.presentedFromLandingPage {
            presentCapturePageFromLanding()
            return
        }
        if !presentedWithTabBar() {
            presentCapturePageFromTryMeButton()
        } else {
            presentCapturePageFromCaptureTab()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureViewModel.reset(captureSceneView)
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(visualEffectView: captureVisualEffectView, blurEffect: UIBlurEffect(style: .regular), isHidden: true)
        Utilities.setDesignOn(stackView: captureStackView, isCircular: true, isHidden: true)
        Utilities.setDesignOn(view: captureTutorialContentView, backgroundColor: .clear, isHidden: true)
        Utilities.setDesignOn(view: captureStickerContentView, isCircular: true, isHidden: true)
        Utilities.setShadowOn(view: captureStickerContentView, isHidden: false, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
        Utilities.setDesignOn(imageView: captureTutorialImageView, image: UIImage(named: Strings.tutorialDialogueImage))
        Utilities.setDesignOn(imageView: captureStickerImageView, image: UIImage(named: Strings.defaultStickerImage))
        Utilities.setDesignOn(imageView: captureExitButtonImageView, image: UIImage(systemName: Strings.exitIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(imageView: captureDeleteButtonImageView, image: UIImage(systemName: Strings.captureDeleteIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(imageView: captureChooseImageButtonImageView, image: UIImage(systemName: Strings.captureChooseImageIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: captureTutorial1Label, fontName: Strings.defaultFontBold, fontSize: 12, numberofLines: 1, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), text: Strings.captureTutorial1Text)
        Utilities.setDesignOn(label: captureTutorial2Label, fontName: Strings.defaultFontBold, fontSize: 25, numberofLines: 0, textAlignment: .center, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), text: Strings.captureTutorial2Text)
        Utilities.setDesignOn(label: captureTutorial3Label, fontName: Strings.defaultFontBold, fontSize: 12, numberofLines: 0, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.captureTutorial3Text, isHidden: true)
        Utilities.setDesignOn(label: captureStickerLabel, fontName: Strings.defaultFont, fontSize: 12, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.captureStickerText)
        Utilities.setDesignOn(label: captureStickerNameLabel, fontName: Strings.defaultFontBold, fontSize: 20, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.captureDefaultStickerNameText, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(button: captureDontShowAgainButton, title: Strings.dontShowAgainButtonText, fontName: Strings.defaultFontBold, fontSize: 16, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
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
            Utilities.setDesignOn(stackView: captureStackView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(imageView: captureExitButtonImageView, tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(imageView: captureDeleteButtonImageView, tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(imageView: captureChooseImageButtonImageView, tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(view: captureStickerContentView, backgroundColor: .white)
            Utilities.setShadowOn(view: captureStackView, isHidden: false, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(stackView: captureStackView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(imageView: captureExitButtonImageView, tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(imageView: captureDeleteButtonImageView, tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(imageView: captureChooseImageButtonImageView, tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(view: captureStickerContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: captureStackView, isHidden: true)
        }
    }
    
    func getStickerInformation() {
        if featuredStickerViewModel != nil {
            setStickerInformation(stickerImage: featuredStickerViewModel!.image, stickerName: featuredStickerViewModel!.name)
        }
        if stickerViewModel != nil {
            setStickerInformation(stickerImage: stickerViewModel!.image, stickerName: stickerViewModel!.name)
        }
        if userStickerViewModel != nil {
            setStickerInformation(stickerImage: userStickerViewModel!.image, stickerName: userStickerViewModel!.name)
        }
    }
    
    func setStickerInformation(stickerImage: String, stickerName: String) {
        captureStickerContentView.isHidden = false
        captureStickerImageView.kf.setImage(with: URL(string: stickerImage))
        captureStickerNameLabel.text = stickerName
    }
    
    func setQuickOptionsDesignWithTabBar() {
        captureStackView.isHidden = false
        captureExitButtonImageView.isHidden = true
    }
    
    func setQuickOptionsDesignWithoutTabBar() {
        captureStackView.isHidden = false
        captureStickerContentView.isHidden = false
        captureExitButtonImageView.isHidden = false
        captureChooseImageButtonImageView.isHidden = true
    }
    
    func hideCapturePageTutorial() {
        captureTutorialContentView.isHidden = true
        captureTutorial3Label.isHidden = true
    }
    
    func cleanupCapturePageAfterChoosingSticker() {
        captureTutorialContentView.isHidden = true
        captureStickerContentView.isHidden = true
        captureTutorial3Label.text = Strings.captureTutorial4Text
    }
    
    func presentedWithTabBar() -> Bool {
        if self.tabBarController?.isBeingPresented == nil {
            return false
        } else {
            return true
        }
    }
    
    func presentCapturePageFromLanding() {
        UserDefaults.standard.setValue(true, forKey: Strings.capturePageKey)
        showTutorial(onLandingPage: true)
    }
    
    func presentCapturePageFromTryMeButton() {
        UserDefaults.standard.setValue(true, forKey: Strings.capturePageKey)
        captureViewModel.setUserDefaultsKeysOnWillAppear()
        checkIfUserIsSignedIn()
        if !UserDefaults.standard.bool(forKey: Strings.capturePageOpenedFromTryMeButtonKey) {
            showTutorial(onCapturePageWithoutTabBar: true)
        } else {
            showDefaultDesign(onCapturePageWithoutTabBar: true)
        }
    }
    
    func presentCapturePageFromCaptureTab() {
        checkIfUserIsSignedIn()
        if !UserDefaults.standard.bool(forKey: Strings.capturePageOpenedFromCaptureTabKey) {
            showTutorial(onCapturePageWithTabBar: true)
        } else {
            showDefaultDesign(onCapturePageWithTabBar: true)
        }
    }
    
    func showTutorial(onLandingPage: Bool? = nil,
                      onCapturePageWithTabBar: Bool? = nil,
                      onCapturePageWithoutTabBar: Bool? = nil,
                      afterChoosingSticker: Bool? = nil)
    {
        if onLandingPage != nil {
            if onLandingPage! {
                captureVisualEffectView.isHidden = false
                captureTutorial3Label.isHidden = false
                registerTapGestureOnStickerContentView()
            }
        }
        if onCapturePageWithTabBar != nil {
            if onCapturePageWithTabBar! {
                setQuickOptionsDesignWithTabBar()
                captureDeleteButtonImageView.isHidden = true
                captureTutorialContentView.isHidden = false
            }
        }
        if onCapturePageWithoutTabBar != nil {
            if onCapturePageWithoutTabBar! {
                captureVisualEffectView.isHidden = false
            }
        }
        if afterChoosingSticker != nil {
            if afterChoosingSticker! {
                if !captureViewModel.presentedFromLandingPage {
                    if !UserDefaults.standard.bool(forKey: Strings.capturePageOpenedFromCaptureTabKey) {
                        captureVisualEffectView.isHidden = false
                    }
                }
            }
        }
    }
    
    func showDefaultDesign(onCapturePageWithTabBar: Bool? = nil, onCapturePageWithoutTabBar: Bool? = nil) {
        if onCapturePageWithTabBar != nil {
            if onCapturePageWithTabBar! {
                captureViewModel.setPlaneDetection(on: captureSceneView)
                setQuickOptionsDesignWithTabBar()
                captureDeleteButtonImageView.isHidden = false
                captureTutorialContentView.isHidden = true
            }
        }
        if onCapturePageWithoutTabBar != nil {
            if onCapturePageWithoutTabBar! {
                captureViewModel.setPlaneDetection(on: captureSceneView)
                setQuickOptionsDesignWithoutTabBar()
                getStickerInformation()
            }
        }
    }
    
    func showAlertController(alertMessage: String, withHandler: Bool) {
        if UserDefaults.standard.bool(forKey: Strings.capturePageKey) {
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
    
    @IBAction func captureDontShowAgainButton(_ sender: UIButton) {
        captureVisualEffectView.isHidden = true
        captureViewModel.setPlaneDetection(on: captureSceneView)
        if captureViewModel.presentedFromLandingPage {
            setQuickOptionsDesignWithoutTabBar()
            captureChooseImageButtonImageView.isHidden = false
            captureTutorialContentView.isHidden = false
            captureTutorialContentViewTopConstraint.constant = 128
            return
        }
        if presentedWithTabBar() {
            UserDefaults.standard.setValue(true, forKey: Strings.capturePageOpenedFromCaptureTabKey)
            setQuickOptionsDesignWithTabBar()
            captureDeleteButtonImageView.isHidden = false
        } else {
            UserDefaults.standard.setValue(true, forKey: Strings.capturePageOpenedFromTryMeButtonKey)
            setQuickOptionsDesignWithoutTabBar()
            getStickerInformation()
        }
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapExitButton = UITapGestureRecognizer(target: self, action: #selector(tapToExitGestureHandler))
        let tapDeleteButton = UITapGestureRecognizer(target: self, action: #selector(tapToDeleteGestureHandler))
        let tapChooseImageButton = UITapGestureRecognizer(target: self, action: #selector(tapToChooseImageGestureHandler))
        let tapSticker = UITapGestureRecognizer(target: self, action: #selector(tapToStickerGestureHandler(tapGesture:)))
        let longPressSticker = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressStickerGestureHandler(longPressGesture:)))
        let pinchSticker = UIPinchGestureRecognizer(target: self, action: #selector(Self.pinchStickerGestureHandler(pinchGesture:)))
        let rotateSticker = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateStickerGestureHandler(rotateGesture:)))
        Utilities.setDesignOn(imageView: captureExitButtonImageView, isUserInteractionEnabled: true, gestureRecognizer: tapExitButton)
        Utilities.setDesignOn(imageView: captureDeleteButtonImageView, isUserInteractionEnabled: true, gestureRecognizer: tapDeleteButton)
        Utilities.setDesignOn(imageView: captureChooseImageButtonImageView, isUserInteractionEnabled: true, gestureRecognizer: tapChooseImageButton)
        captureSceneView.addGestureRecognizer(tapSticker)
        captureSceneView.addGestureRecognizer(longPressSticker)
        captureSceneView.addGestureRecognizer(pinchSticker)
        captureSceneView.addGestureRecognizer(rotateSticker)
    }
    
    func registerTapGestureOnStickerContentView() {
        let tapStickerName = UITapGestureRecognizer(target: self, action: #selector(tapToStickerNameGestureHandler))
        captureStickerContentView.addGestureRecognizer(tapStickerName)
    }
    
    @objc func tapToExitGestureHandler() {
        captureViewModel.setUserDefaultsKeysOnExitButton()
        if UserDefaults.standard.bool(forKey: Strings.notificationTabKey) {
            guard let userStickerData = userStickerViewModel else {return}
            firebase.updateNewSticker(on: userStickerData.stickerID) { [weak self] (error, userIsSignedIn) in
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
                }
            }
        }
        dismiss(animated: true)
    }
    
    @objc func tapToDeleteGestureHandler() {
        captureViewModel.tapToDeleteGesture()
    }
    
    @objc func tapToChooseImageGestureHandler() {
        present(imagePicker, animated: true)
    }
    
    @objc func tapToStickerNameGestureHandler() {
        Utilities.animate(view: captureStickerContentView)
        captureViewModel.stickerMaterial.diffuse.contents = UIImage(named: Strings.defaultStickerImage)
        captureViewModel.stickerIsPicked = true
        captureTutorial3Label.text = Strings.captureTutorial4Text
    }
    
    @objc func tapToStickerGestureHandler(tapGesture: UITapGestureRecognizer) {
        captureViewModel.tapStickerGesture(with: tapGesture) { [weak self] (stickerIsPicked, stickerSuccesfullyAppeared, noStickerErrorMessage, raycastErrorMessage, excessStickerErrorMessage) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if !stickerIsPicked {
                    self.showAlertController(alertMessage: noStickerErrorMessage!, withHandler: false)
                    return
                }
                if !stickerSuccesfullyAppeared {
                    if raycastErrorMessage != nil {
                        self.showAlertController(alertMessage: raycastErrorMessage!, withHandler: false)
                    }
                    if excessStickerErrorMessage != nil {
                        self.showAlertController(alertMessage: excessStickerErrorMessage!, withHandler: false)
                    }
                    return
                }
                self.hideCapturePageTutorial()
            }
        }
    }
    
    @objc func longPressStickerGestureHandler(longPressGesture: UILongPressGestureRecognizer) {
        captureViewModel.longPressStickerGesture(with: longPressGesture)
    }
    
    @objc func pinchStickerGestureHandler(pinchGesture: UIPinchGestureRecognizer) {
        captureViewModel.pinchStickerGesture(with: pinchGesture)
    }
    
    @objc func rotateStickerGestureHandler(rotateGesture: UIRotationGestureRecognizer) {
        captureViewModel.rotateStickerGesture(with: rotateGesture)
    }
    
    
    //MARK: - Fetching of User Data
    
    func checkIfUserIsSignedIn() {
        firebase.checkIfUserIsSignedIn { [weak self] (error, userIsSignedIn, _) in
            guard let self = self else {return}
            if !userIsSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
        }
    }
    
    
    //MARK: - Fetching of Sticker Data
    
    func downloadStickerImage(using stickerURL: String) {
        captureViewModel.downloadStickerImage(using: stickerURL) { [weak self] (error) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.showAlertController(alertMessage: error.localizedDescription, withHandler: false)
            }
        }
    }
    
    
    //MARK: - Data Source And Delegate
    
    func setDataSourceAndDelegate() {
        captureSceneView.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
}


//MARK: - Image Picker & Navigation Controller Delegate

extension CaptureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        captureViewModel.stickerMaterial.diffuse.contents = imagePicked
        captureViewModel.stickerIsPicked = true
        cleanupCapturePageAfterChoosingSticker()
        showTutorial(afterChoosingSticker: true)
        imagePicker.dismiss(animated: true)
    }
    
}


//MARK: - ARSCN View Delegate

extension CaptureViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        captureViewModel.didAddNode(with: anchor, on: node) { [weak self] (anchorErrorMessage) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.showAlertController(alertMessage: anchorErrorMessage, withHandler: false)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        captureViewModel.didUpdateNode(with: anchor, on: node) { [weak self] (anchorErrorMessage) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.showAlertController(alertMessage: anchorErrorMessage, withHandler: false)
            }
        }
    }
    
}
