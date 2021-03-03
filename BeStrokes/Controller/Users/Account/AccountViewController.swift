//
//  AccountViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import Kingfisher
import SkeletonView

class AccountViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var accountTopView: UIView!
    @IBOutlet weak var accountImageContentView: UIView!
    @IBOutlet weak var accountBottomStackView: UIStackView!
    @IBOutlet weak var accountBottomSearchContentView: UIView!
    @IBOutlet weak var accountTextFieldContentView: UIView!
    @IBOutlet weak var accountHeading1Label: UILabel!
    @IBOutlet weak var accountHeading2Label: UILabel!
    @IBOutlet weak var accountNameHeadingLabel: UILabel!
    @IBOutlet weak var accountEmailHeadingLabel: UILabel!
    @IBOutlet weak var accountWarningLabel: UILabel!
    @IBOutlet weak var accountEditButton: UIButton!
    @IBOutlet weak var accountSearchButton: UIButton!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountSearchTextField: UITextField!
    @IBOutlet weak var accountLovedStickerTableView: UITableView!
    @IBOutlet weak var accountLoadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var accountNoLovedStickerLabelConstraint: NSLayoutConstraint!
    
    
    //MARK: - Constants / Variables
    
    private let user = User()
    private let stickerData = StickerData()
    private var lovedStickerViewModel: [LovedStickerViewModel]?
    private var userViewModel: UserViewModel?
    private let heartButtonLogic = HeartButtonLogic()
    private var isButtonPressed = false
    private var hasPerformedSearch = false
    private var skeletonColor: UIColor?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setDataSourceAndDelegate()
        registerNIB()
        showLoadingSkeletonView()
        setSignedInUserData()
        setLovedStickersData()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: accountTopView, setCustomCircleCurve: 30)
        Utilities.setDesignOn(view: accountImageContentView, backgroundColor: .clear, isCircular: true)
        Utilities.setDesignOn(stackView: accountBottomStackView, backgroundColor: .clear, isHidden: true)
        Utilities.setDesignOn(view: accountBottomSearchContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: accountTextFieldContentView, backgroundColor: .clear, isHidden: true)
        Utilities.setDesignOn(button: accountEditButton, backgroundImage: UIImage(systemName: Strings.accountEditAccountIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(button: accountSearchButton, backgroundImage: UIImage(systemName: Strings.accountSearchStickerIcon))
        Utilities.setDesignOn(textField: accountSearchTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, capitalization: .words, returnKeyType: .search, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholder: Strings.searchTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(imageView: accountImageView, isCircular: true)
        Utilities.setDesignOn(label: accountHeading1Label, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.accountHeading1Text)
        Utilities.setDesignOn(label: accountNameHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 25, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: " ", canResize: true, minimumScaleFactor: 0.6)
        Utilities.setDesignOn(label: accountEmailHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: " ", canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(label: accountHeading2Label, fontName: Strings.defaultFontBold, fontSize: 25, numberofLines: 1, textAlignment: .left, text: Strings.accountHeading2Text)
        Utilities.setDesignOn(label: accountWarningLabel, fontName: Strings.defaultFontBold, fontSize: 20, numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, isHidden: true)
        Utilities.setDesignOn(tableView: accountLovedStickerTableView, backgroundColor: .clear, separatorStyle: .none, showVerticalScrollIndicator: false, rowHeight: 170, isHidden: true)
        Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, size: .medium, isStartAnimating: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
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
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: view, backgroundColor: .white)
            Utilities.setDesignOn(view: accountTopView, backgroundColor: .white)
            Utilities.setDesignOn(label: accountHeading2Label, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(button: accountSearchButton, tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(textField: accountSearchTextField, backgroundColor: .white)
            Utilities.setDesignOn(label: accountWarningLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setShadowOn(view: accountTopView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: accountSearchTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    @objc func setDarkMode() {
        setNeedsStatusBarAppearanceUpdate()
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(view: accountTopView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(label: accountHeading2Label, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(button: accountSearchButton, tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: accountSearchTextField, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(label: accountWarningLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: accountTopView, isHidden: true)
            Utilities.setShadowOn(textField: accountSearchTextField, isHidden: true)
            Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        }
    }
    
    func setSkeletonColor() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            skeletonColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        } else {
            skeletonColor = #colorLiteral(red: 0.2006691098, green: 0.200709641, blue: 0.2006634176, alpha: 1)
        }
    }
    
    func showLoadingSkeletonView() {
        setSkeletonColor()
        DispatchQueue.main.async { [self] in
            accountImageContentView.isSkeletonable = true
            Utilities.setDesignOn(view: accountImageContentView, isSkeletonCircular: true)
            accountNameHeadingLabel.isSkeletonable = true
            accountEmailHeadingLabel.isSkeletonable = true
            accountImageContentView.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
            accountNameHeadingLabel.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
            accountEmailHeadingLabel.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
            accountImageContentView.showAnimatedSkeleton()
            accountNameHeadingLabel.showAnimatedSkeleton()
            accountEmailHeadingLabel.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        accountImageContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountNameHeadingLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountEmailHeadingLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        Utilities.setShadowOn(view: accountImageContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 5)
    }
    
    func showSearchTextField() {
        accountTextFieldContentView.isHidden = false
        Utilities.setDesignOn(button: accountSearchButton, backgroundImage: UIImage(systemName: Strings.accountArrowUpIcon))
    }
    
    func hideSearchTextField() {
        accountTextFieldContentView.isHidden = true
        accountSearchTextField.text = nil
        accountSearchTextField.resignFirstResponder()
        Utilities.setDesignOn(button: accountSearchButton, backgroundImage: UIImage(systemName: Strings.accountSearchStickerIcon))
        if hasPerformedSearch {
            setLovedStickersData()
            hasPerformedSearch = false
        }
    }
    
    func showSearchedSticker(using stickerData: [LovedStickerViewModel]) {
        hasPerformedSearch = true
        lovedStickerViewModel = stickerData
        DispatchQueue.main.async { [self] in
            accountLovedStickerTableView.reloadData()
        }
        accountWarningLabel.isHidden = true
        accountLovedStickerTableView.isHidden = false
    }
    
    func showNoStickerResultLabel() {
        accountLovedStickerTableView.isHidden = true
        accountWarningLabel.isHidden = false
        accountWarningLabel.text = Strings.accountInvalidStickerLabel
        accountNoLovedStickerLabelConstraint.constant = 115
    }
    
    func setSignedInUserData() {
        user.getSignedInUserData { [self] (error, isUserSignedIn, userData) in
            guard let error = error else {
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                    return
                }
                guard let userData = userData else {return}
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                    accountImageView.kf.setImage(with: URL(string: userData.profilePic)!)
                    accountNameHeadingLabel.text = "\(userData.firstName) \(userData.lastname)"
                    accountEmailHeadingLabel.text = userData.email
                    hideLoadingSkeletonView()
                }
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
    }
    
    func setLovedStickersData() {
        heartButtonLogic.showLovedSticker { [self] (error, isUserSignedIn, lovedStickerData) in
            guard let error = error else {
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                    return
                }
                guard let lovedStickerData = lovedStickerData else {return}
                lovedStickerViewModel = lovedStickerData
                checkIfStickerViewModelIsEmpty(withDelay: 0.5)
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
    }
    
    func checkIfStickerViewModelIsEmpty(withDelay delay: Double) {
        accountBottomStackView.isHidden = true
        accountWarningLabel.isHidden = true
        accountLovedStickerTableView.isHidden = true
        accountLoadingIndicatorView.isHidden = false
        if lovedStickerViewModel?.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                accountLoadingIndicatorView.isHidden = true
                accountWarningLabel.text = Strings.accountNoLovedStickerLabel
                accountWarningLabel.isHidden = false
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                accountBottomStackView.isHidden = false
                accountLovedStickerTableView.isHidden = false
                accountLoadingIndicatorView.isHidden = true
                accountWarningLabel.isHidden = true
                accountLovedStickerTableView.reloadData()
            }
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
    
    func transitionToLandingVC() {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
        view.window?.rootViewController = landingVC
        view.window?.makeKeyAndVisible()
    }
    
    
    //MARK: - Buttons
    
    @IBAction func accountSearchButton(_ sender: UIButton) {
        isButtonPressed = !isButtonPressed
        if isButtonPressed {
            showSearchTextField()
        } else {
            hideSearchTextField()
        }
        if accountLovedStickerTableView.isHidden == true {
            accountNoLovedStickerLabelConstraint.constant = 100
            checkIfStickerViewModelIsEmpty(withDelay: 0)
        }
    }
    
    
    //MARK: - Table View Process
    
    func setDataSourceAndDelegate() {
        accountLovedStickerTableView.dataSource = self
        accountLovedStickerTableView.delegate = self
        accountSearchTextField.delegate = self
    }
    
    func registerNIB() {
        accountLovedStickerTableView.register(UINib(nibName: Strings.stickerTableViewCell, bundle: nil), forCellReuseIdentifier: Strings.stickerTableViewCell)
    }
    
}


//MARK: - Table View Data Source

extension AccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lovedStickerViewModel?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.stickerTableViewCell) as! StickerTableViewCell
        guard let lovedStickerViewModel = lovedStickerViewModel else {return cell}
        DispatchQueue.main.async {
            cell.lovedStickerViewModel = lovedStickerViewModel[indexPath.item]
            cell.stickerCellDelegate = self
            cell.prepareStickerTableViewCell()
        }
        return cell
    }
    
}


//MARK: - Table View Delegate

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let stickerOptionVC = storyboard.instantiateViewController(identifier: Strings.stickerOptionVC) as! StickerOptionViewController
        DispatchQueue.main.async { [self] in
            stickerOptionVC.prepareStickerOptionVC()
            stickerOptionVC.lovedStickerViewModel = lovedStickerViewModel![indexPath.item]
            present(stickerOptionVC, animated: true)
        }
    }
    
}


//MARK: - Loved Sticker Delegate

extension AccountViewController: StickerTableViewCellDelegate {
    
    func getVC(using viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
}


//MARK: - Text Field Delegate

extension AccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        accountSearchTextField.resignFirstResponder()
        stickerData.searchSticker(using: accountSearchTextField.text!) { [self] (error, isUserSignedIn, isStickerValid, stickerData) in
            guard let error = error else {
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                    return
                }
                guard let isStickerValid = isStickerValid else {return}
                if !isStickerValid {
                    showNoStickerResultLabel()
                    return
                }
                guard let stickerData = stickerData else {return}
                showSearchedSticker(using: [stickerData])
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
        return true
    }
    
}
