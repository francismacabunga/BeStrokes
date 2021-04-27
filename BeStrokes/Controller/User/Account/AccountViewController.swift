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
    @IBOutlet weak var accountBottomSearchContentView: UIView!
    @IBOutlet weak var accountTextFieldContentView: UIView!
    @IBOutlet weak var accountBottomStackView: UIStackView!
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
    
    private let userData = UserData()
    private let stickerData = StickerData()
    private var userStickerViewModel: [UserStickerViewModel]?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfUserIsSignedIn()
        
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
        Utilities.setDesignOn(tableView: accountLovedStickerTableView, backgroundColor: .clear, separatorStyle: UITableViewCell.SeparatorStyle.none, showVerticalScrollIndicator: false, rowHeight: 170, keyboardDismissMode: .onDrag, isHidden: true)
        Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, size: .medium, isStartAnimating: false, isHidden: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserData), name: Utilities.reloadUserData, object: nil)
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
            Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isStartAnimating: false, isHidden: true)
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
            Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isStartAnimating: false, isHidden: true)
        }
    }
    
    func setSkeletonColor() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            skeletonColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        } else {
            skeletonColor = #colorLiteral(red: 0.2006691098, green: 0.200709641, blue: 0.2006634176, alpha: 1)
        }
    }
    
    @objc func reloadUserData() {
        setSignedInUserData()
    }
    
    func hideSearchTextField() {
        accountTextFieldContentView.isHidden = true
        accountSearchTextField.text = nil
        accountSearchTextField.resignFirstResponder()
        accountSearchButton.setBackgroundImage(UIImage(systemName: Strings.accountSearchStickerIcon), for: .normal)
        if hasPerformedSearch {
            setLovedStickersData()
            hasPerformedSearch = false
        }
    }
    
    func hideLoadingSkeletonView() {
        accountImageContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountNameHeadingLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountEmailHeadingLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        Utilities.setShadowOn(view: accountImageContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 5)
    }
    
    func showLoadingSkeletonView() {
        setSkeletonColor()
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
    
    func showSearchTextField() {
        accountTextFieldContentView.isHidden = false
        Utilities.setDesignOn(button: accountSearchButton, backgroundImage: UIImage(systemName: Strings.accountArrowUpIcon))
    }
    
    func showSearchedSticker(using stickerData: [UserStickerViewModel]) {
        hasPerformedSearch = true
        userStickerViewModel = stickerData
        accountLovedStickerTableView.reloadData()
        accountWarningLabel.isHidden = true
        accountLovedStickerTableView.isHidden = false
    }
    
    func showNoStickerResultLabel() {
        accountLovedStickerTableView.isHidden = true
        Utilities.setDesignOn(label: accountWarningLabel, text: Strings.accountInvalidStickerLabel, isHidden: false)
        accountNoLovedStickerLabelConstraint.constant = 115
    }
    
    func showAlertController(alertMessage: String,
                             withHandler: Bool)
    {
        if UserDefaults.standard.bool(forKey: Strings.isAccountVCLoadedKey) {
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
    
    @IBAction func accountSearchButton(_ sender: UIButton) {
        isButtonPressed = !isButtonPressed
        if isButtonPressed {
            showSearchTextField()
        } else {
            hideSearchTextField()
        }
        if accountLovedStickerTableView.isHidden == true {
            accountNoLovedStickerLabelConstraint.constant = 100
            checkIfUserStickerViewModelIsEmpty(withDelay: 0)
        }
    }
    
    
    //MARK: - Fetching of User Data
    
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
    
    func setSignedInUserData() {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.accountImageView.kf.setImage(with: URL(string: userData.profilePic)!)
                self.accountNameHeadingLabel.text = "\(userData.firstName) \(userData.lastname)"
                self.accountEmailHeadingLabel.text = userData.email
                self.hideLoadingSkeletonView()
            }
        }
    }
    
    
    //MARK: - Fetching of Sticker Data
    
    func setLovedStickersData() {
        stickerData.fetchLovedSticker { [weak self] (error, isUserSignedIn, _, userStickerData) in
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
                self.userStickerViewModel = userStickerData
                self.checkIfUserStickerViewModelIsEmpty(withDelay: 0.5)
            }
        }
    }
    
    func checkIfUserStickerViewModelIsEmpty(withDelay delay: Double) {
        accountBottomStackView.isHidden = true
        accountWarningLabel.isHidden = true
        accountLovedStickerTableView.isHidden = true
        Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, isStartAnimating: true, isHidden: false)
        if userStickerViewModel?.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, isStartAnimating: false, isHidden: true)
                accountWarningLabel.text = Strings.accountNoLovedStickerLabel
                accountWarningLabel.isHidden = false
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                accountBottomStackView.isHidden = false
                accountLovedStickerTableView.isHidden = false
                Utilities.setDesignOn(activityIndicatorView: accountLoadingIndicatorView, isStartAnimating: false, isHidden: true)
                accountWarningLabel.isHidden = true
                accountLovedStickerTableView.reloadData()
            }
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
        return userStickerViewModel?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.stickerTableViewCell) as! StickerTableViewCell
        guard let userStickerViewModel = userStickerViewModel else {return cell}
        cell.prepareStickerTableViewCell()
        cell.userStickerViewModel = userStickerViewModel[indexPath.row]
        cell.stickerCellDelegate = self
        return cell
    }
    
}


//MARK: - Table View Delegate

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userStickerViewModel = userStickerViewModel else {return}
        let stickerOptionVC = Utilities.transition(to: Strings.stickerOptionVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! StickerOptionViewController
        stickerOptionVC.userStickerViewModel = userStickerViewModel[indexPath.row]
        stickerOptionVC.modalPresentationStyle = .fullScreen
        present(stickerOptionVC, animated: true)
    }
    
}


//MARK: - Sticker Cell Delegate

extension AccountViewController: StickerTableViewCellDelegate {
    
    func getVC(using viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
}


//MARK: - Text Field Delegate

extension AccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        accountSearchTextField.resignFirstResponder()
        if accountSearchTextField.text != nil {
            stickerData.searchSticker(using: accountSearchTextField.text!) { [weak self] (error, isUserSignedIn, userStickerData) in
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
                guard let userStickerViewModel = userStickerData else {
                    DispatchQueue.main.async {
                        self.showNoStickerResultLabel()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.showSearchedSticker(using: [userStickerViewModel])
                }
            }
            return true
        }
        return false
    }
    
}
