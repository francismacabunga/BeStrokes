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
    
    @IBOutlet weak var stickerNavigationBar: UINavigationBar!
    @IBOutlet weak var stickerStackContentView: UIStackView!
    @IBOutlet weak var stickerTopView: UIView!
    @IBOutlet weak var stickerMiddleView: UIView!
    @IBOutlet weak var stickerBottomView: UIView!
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerNameLabel: UILabel!
    @IBOutlet weak var stickerCategoryLabel: UILabel!
    @IBOutlet weak var stickerTagLabel: UILabel!
    @IBOutlet weak var stickerDescriptionLabel: UILabel!
    @IBOutlet weak var stickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var stickerTryMeButton: UIButton!
    
    
    //MARK: - Constants / Variables
    
    private let heartButtonLogic = HeartButtonLogic()
    private var heartButtonTapped: Bool?
    var stickerViewModel: StickerViewModel! {
        didSet {
            getHeartButtonValue(stickerViewModel: stickerViewModel)
            setStickerData(stickerImageName: stickerViewModel.image,
                           stickerName: stickerViewModel.name,
                           stickerCategory: stickerViewModel.category,
                           stickerTag: stickerViewModel.tag,
                           stickerDescription: stickerViewModel.description)
        }
    }
    var lovedStickerViewModel: LovedStickerViewModel! {
        didSet {
            getHeartButtonValue(lovedStickerViewModel: lovedStickerViewModel)
            setStickerData(stickerImageName: lovedStickerViewModel.image,
                           stickerName: lovedStickerViewModel.name,
                           stickerCategory: lovedStickerViewModel.category,
                           stickerTag: lovedStickerViewModel.tag,
                           stickerDescription: lovedStickerViewModel.description)
        }
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(view: stickerTopView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerMiddleView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerBottomView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: stickerStackContentView, backgroundColor: .clear)
        Utilities.setDesignOn(navigationBar: stickerNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(imageView: stickerHeartButtonImageView, image: UIImage(systemName: Strings.loveStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: stickerNameLabel, font: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(label: stickerCategoryLabel, font: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: stickerTagLabel, font: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: stickerDescriptionLabel, font: Strings.defaultFont, fontSize: 17, numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(button: stickerTryMeButton, title: Strings.tryMeButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
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
    
    func transitionToCaptureVC() {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let captureVC = storyboard.instantiateViewController(identifier: Strings.captureVC) as! CaptureViewController
        captureVC.stickerViewModel = stickerViewModel
        captureVC.lovedStickerViewModel = lovedStickerViewModel
        captureVC.isStickerPicked = true
        captureVC.modalPresentationStyle = .fullScreen
        present(captureVC, animated: true)
    }
    
    func prepareStickerOptionVC() {
        setDesignElements()
        registerGestures()
    }
    
    func getHeartButtonValue(stickerViewModel: StickerViewModel? = nil, lovedStickerViewModel: LovedStickerViewModel? = nil) {
        if stickerViewModel != nil {
            checkIfStickerIsLoved(stickerViewModel!.stickerID)
        }
        if lovedStickerViewModel != nil {
            checkIfStickerIsLoved(lovedStickerViewModel!.stickerID)
        }
    }
    
    func checkIfStickerIsLoved(_ stickerID: String) {
        heartButtonLogic.checkIfStickerIsLoved(using: stickerID) { [self] (error, isUserSignedIn, isStickerLoved) in
            guard let error = error else {
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                    return
                }
                guard let isStickerLoved = isStickerLoved else {return}
                if isStickerLoved {
                    Utilities.setDesignOn(imageView: stickerHeartButtonImageView, image: UIImage(systemName: Strings.lovedStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    heartButtonTapped = true
                } else {
                    Utilities.setDesignOn(imageView: stickerHeartButtonImageView, image: UIImage(systemName: Strings.loveStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    heartButtonTapped = false
                }
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
    }
    
    func setStickerData(stickerImageName: String,
                        stickerName: String,
                        stickerCategory: String,
                        stickerTag: String,
                        stickerDescription: String)
    {
        stickerImageView.kf.setImage(with: URL(string: stickerImageName))
        stickerNameLabel.text = stickerName
        stickerCategoryLabel.text = stickerCategory
        if stickerTag != Strings.tagNoStickers {
            stickerTagLabel.text = stickerTag
        } else {
            stickerTagLabel.isHidden = true
        }
        stickerDescriptionLabel.text = stickerDescription
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        stickerHeartButtonImageView.isUserInteractionEnabled = true
        stickerHeartButtonImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureHandler(tap: UITapGestureRecognizer) {
        if heartButtonTapped! {
            untapHeartButtonUsing(stickerViewModel: stickerViewModel) { (isErrorPresent) in}
            untapHeartButtonUsing(lovedStickerViewModel: lovedStickerViewModel) { [self] (isErrorPresent) in
                if !isErrorPresent {
                    self.dismiss(animated: true)
                }
            }
        } else {
            tapHeartButton(using: stickerViewModel)
        }
    }
    
    func untapHeartButtonUsing(stickerViewModel: StickerViewModel? = nil, lovedStickerViewModel: LovedStickerViewModel? = nil, completion: @escaping (Bool) -> Void) {
        if stickerViewModel != nil {
            untapHeartButtonProcess(using: stickerViewModel!.stickerID) { (isErrorPresent) in
            }
        }
        if lovedStickerViewModel != nil {
            untapHeartButtonProcess(using: lovedStickerViewModel!.stickerID) { (isErrorPresent) in
                if isErrorPresent {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func untapHeartButtonProcess(using stickerID: String, completion: @escaping (Bool) -> Void) {
        heartButtonLogic.untapHeartButton(using: stickerID) { [self] (error, isUserSignedIn, isProcessDone) in
            guard let error = error else {
                if !isUserSignedIn {
                    completion(true)
                    showNoSignedInUserAlert()
                    return
                }
                if isProcessDone {
                    completion(false)
                }
                return
            }
            completion(true)
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
    }
    
    func tapHeartButton(using stickerViewModel: StickerViewModel) {
        let stickerDataDictionary = [Strings.stickerIDField : stickerViewModel.stickerID,
                                     Strings.stickerNameField : stickerViewModel.name,
                                     Strings.stickerImageField : stickerViewModel.image,
                                     Strings.stickerDescriptionField : stickerViewModel.description,
                                     Strings.stickerCategoryField : stickerViewModel.category,
                                     Strings.stickerTagField : stickerViewModel.tag]
        heartButtonLogic.tapHeartButton(using: stickerViewModel.stickerID, with: stickerDataDictionary) { [self] (error, isUserSignedIn, isProcessDone) in
            guard let error = error else {
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                }
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func stickerOptionTryMeButton(_ sender: UIButton) {
        transitionToCaptureVC()
    }
    
}
