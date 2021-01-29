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
    private var stickerViewModel: StickerViewModel?
    private var lovedStickerViewModel: LovedStickerViewModel?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        Utilities.setDesignOn(label: stickerNameLabel, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(label: stickerCategoryLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .center, isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: stickerTagLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .center, isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: stickerDescriptionLabel, font: Strings.defaultFont, fontSize: 17, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping)
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
    
    func getHeartButtonValue(using stickerViewModel: StickerViewModel) {
        heartButtonLogic.checkIfStickerIsLoved(using: stickerViewModel.stickerID) { [self] (error, isUserSignedIn, isStickerLoved) in
            if error != nil {
                showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
                return
            }
            guard let isUserSignedIn = isUserSignedIn else {return}
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
        }
    }
    
    func getHeartButtonValue(using lovedStickerViewModel: LovedStickerViewModel) {
        heartButtonLogic.checkIfStickerIsLoved(using: lovedStickerViewModel.stickerID) { [self] (error, isUserSignedIn, isStickerLoved) in
            if error != nil {
                showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
                return
            }
            guard let isUserSignedIn = isUserSignedIn else {return}
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
        }
    }
    
    func setStickerData(using stickerViewModel: StickerViewModel) {
        self.stickerViewModel = stickerViewModel
        stickerImageView.kf.setImage(with: URL(string: stickerViewModel.image))
        stickerNameLabel.text = stickerViewModel.name
        getHeartButtonValue(using: stickerViewModel)
        stickerCategoryLabel.text = stickerViewModel.category
        if stickerViewModel.tag != Strings.tagNoStickers {
            stickerTagLabel.text = stickerViewModel.tag
        } else {
            stickerTagLabel.isHidden = true
        }
        stickerDescriptionLabel.text = stickerViewModel.description
    }
    
    func setStickerData(using lovedStickerViewModel: LovedStickerViewModel) {
        self.lovedStickerViewModel = lovedStickerViewModel
        stickerImageView.kf.setImage(with: URL(string: lovedStickerViewModel.image))
        stickerNameLabel.text = lovedStickerViewModel.name
        getHeartButtonValue(using: lovedStickerViewModel)
        stickerCategoryLabel.text = lovedStickerViewModel.category
        if lovedStickerViewModel.tag != Strings.tagNoStickers {
            stickerTagLabel.text = lovedStickerViewModel.tag
        } else {
            stickerTagLabel.isHidden = true
        }
        stickerDescriptionLabel.text = lovedStickerViewModel.description
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        stickerHeartButtonImageView.isUserInteractionEnabled = true
        stickerHeartButtonImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureHandler(tap: UITapGestureRecognizer) {
        if heartButtonTapped! {
            if let stickerViewModel = stickerViewModel {
                untapHeartButton(using: stickerViewModel)
            }
            if let lovedStickerViewModel = lovedStickerViewModel {
                dismiss(animated: true)
                untapHeartButton(using: lovedStickerViewModel)
            }
        } else {
            if let stickerViewModel = stickerViewModel {
                tapHeartButton(using: stickerViewModel)
            }
        }
    }
    
    func untapHeartButton(using stickerViewModel: StickerViewModel) {
        heartButtonLogic.untapHeartButton(using: stickerViewModel.stickerID) { [self] (error, isUserSignedIn) in
            print("hello")
            if error == nil {
                // Show error
                showErrorFetchingAlert(usingError: false, withCustomizedString: "Home")
                //showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
//                return
            }
            guard let isUserSignedIn = isUserSignedIn else {return}
            if !isUserSignedIn {
                // Show error
                showNoSignedInUserAlert()
                return
            }
        }
    }
    
    func untapHeartButton(using lovedStickerViewModel: LovedStickerViewModel) {
        heartButtonLogic.untapHeartButton(using: lovedStickerViewModel.stickerID) { [self] (error, isUserSignedIn) in
            print("hello")
            if error == nil {
                // Show error
                showErrorFetchingAlert(usingError: false, withCustomizedString: "Account")
                //showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
//                return
            }
            guard let isUserSignedIn = isUserSignedIn else {return}
            if !isUserSignedIn {
                // Show error
                showNoSignedInUserAlert()
                return
            }
        }
    }
    
    func tapHeartButton(using stickerViewModel: StickerViewModel) {
        let stickerDataDictionary = [Strings.stickerIDField : stickerViewModel.stickerID,
                                     Strings.stickerNameField : stickerViewModel.name,
                                     Strings.stickerImageField : stickerViewModel.image,
                                     Strings.stickerDescriptionField : stickerViewModel.description,
                                     Strings.stickerCategoryField : stickerViewModel.category,
                                     Strings.stickerTagField : stickerViewModel.tag]
        heartButtonLogic.tapHeartButton(using: stickerViewModel.stickerID, with: stickerDataDictionary) { [self] (error, isUserSignedIn) in
            if error != nil {
                print("from tap")
                // Show error
                showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
                return
            }
            guard let isUserSignedIn = isUserSignedIn else {return}
            if !isUserSignedIn {
                // Show error
                showNoSignedInUserAlert()
                return
            }
        }
    }
    
}
