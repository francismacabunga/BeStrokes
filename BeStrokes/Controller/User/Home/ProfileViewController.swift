//
//  ProfileViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/8/21.
//

import UIKit
import Kingfisher
import SkeletonView

class ProfileViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var profileNavigationBar: UINavigationBar!
    @IBOutlet weak var profileContentView: UIView!
    @IBOutlet weak var profileImageContentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var profileHeadingLabel: UILabel!
    @IBOutlet weak var profileWarningLabel: UILabel!
    @IBOutlet weak var profileTrademark1Label: UILabel!
    @IBOutlet weak var profileTrademark2Label: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileSettingsButton: UIButton!
    
    
    //MARK: - Constants / Variables
    
    private let firebase = Firebase()
    private let profileSettingsViewModel = ProfileSettingsViewModel()
    private var skeletonColor: UIColor?
    private var hasProfilePicLoaded = false
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setDataSourceAndDelegate()
        registerNIB()
        setData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileSettingsViewModel.setUserDefaultsValueOnDidAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        profileSettingsViewModel.setUserDefaultsValueWillDisappear()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(view: profileContentView, setCustomCircleCurve: 25)
        Utilities.setDesignOn(view: profileImageContentView, backgroundColor: .clear, isCircular: true)
        Utilities.setDesignOn(navigationBar: profileNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(imageView: profileImageView, isCircular: true)
        Utilities.setDesignOn(label: profileNameLabel, fontName: Strings.defaultFontBold, fontSize: 20, numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(label: profileEmailLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(label: profileHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 30, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileSettingsHeadingText)
        Utilities.setDesignOn(label: profileWarningLabel, fontName: Strings.defaultFontMedium, fontSize: 13, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileWarningLabel, isHidden: true)
        Utilities.setDesignOn(label: profileTrademark1Label, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileTrademark1Text)
        Utilities.setDesignOn(label: profileTrademark2Label, fontName: Strings.defaultFontMedium, fontSize: 10, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileTrademark2Text)
        Utilities.setDesignOn(button: profileSettingsButton, title: Strings.clickHereButtonText, fontName: Strings.defaultFontMedium, fontSize: 13, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(tableView: profileTableView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), separatorStyle: .singleLine, showVerticalScrollIndicator: false, separatorColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), rowHeight: 50, isHidden: true)
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
            if hasProfilePicLoaded {
                Utilities.setShadowOn(view: profileImageContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 5)
            }
            Utilities.setShadowOn(view: profileContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setDesignOn(view: profileContentView, backgroundColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
            Utilities.setDesignOn(label: profileNameLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(label: profileEmailLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setShadowOn(view: profileContentView, isHidden: true)
            Utilities.setShadowOn(view: profileImageContentView, isHidden: true)
            Utilities.setDesignOn(view: profileContentView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(label: profileNameLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(label: profileEmailLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        }
    }
    
    func setSkeletonColor() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            skeletonColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        } else {
            skeletonColor = #colorLiteral(red: 0.2006691098, green: 0.200709641, blue: 0.2006634176, alpha: 1)
        }
    }
    
    func setData() {
        profileTableView.reloadData()
        showLoadingSkeletonView()
        getSignedInUserData()
    }
    
    func hideLoadingSkeletonView() {
        profileImageContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        profileNameLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        profileEmailLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            Utilities.setShadowOn(view: profileImageContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 5)
        }
    }
    
    func showLoadingSkeletonView() {
        setSkeletonColor()
        profileImageContentView.isSkeletonable = true
        Utilities.setDesignOn(view: profileImageContentView, isSkeletonCircular: true)
        profileNameLabel.isSkeletonable = true
        profileEmailLabel.isSkeletonable = true
        profileImageContentView.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
        profileNameLabel.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
        profileEmailLabel.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
        profileImageContentView.showAnimatedSkeleton()
        profileNameLabel.showAnimatedSkeleton()
        profileEmailLabel.showAnimatedSkeleton()
    }
    
    func showAlertController(alertMessage: String, withHandler: Bool) {
        if UserDefaults.standard.bool(forKey: Strings.isProfileVCLoadedKey) {
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
    
    @IBAction func profileSettingsButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            dismiss(animated: true)
        }
    }
    
    
    //MARK: - Fetching of User Data
    
    func getSignedInUserData() {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.profileImageView.kf.setImage(with: URL(string: userData.profilePic)!)
                self.profileNameLabel.text = "\(userData.firstName) \(userData.lastname)"
                self.profileEmailLabel.text = userData.email
                self.hasProfilePicLoaded = true
                self.profileWarningLabel.isHidden = false
                self.profileSettingsButton.isHidden = false
                self.profileTableView.isHidden = false
                self.hideLoadingSkeletonView()
            }
        }
    }
    
    
    //MARK: - Sign Out User
    
    func signOutUser() {
        let logoutAlert = Utilities.showAlert(alertTitle: Strings.logoutAlertTitle, alertMessage: "", alertActionTitle1: Strings.logoutYesAction, alertActionTitle2: Strings.logoutNoAction) { [weak self] in
            guard let self = self else {return}
            let isUserSignedOut = self.profileSettingsViewModel.signOutUser()
            if isUserSignedOut {
                DispatchQueue.main.async {
                    _ = Utilities.transition(from: self.view, to: Strings.landingVC, onStoryboard: Strings.guestStoryboard, canAccessDestinationProperties: false)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: Strings.profileCannotSignOutUserLabel, withHandler: false)
                }
            }
        }
        present(logoutAlert!, animated: true)
    }
    
    
    //MARK: - Table View Process
    
    func setDataSourceAndDelegate() {
        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
    
    func registerNIB() {
        profileTableView.register(UINib(nibName: Strings.profileCell, bundle: nil), forCellReuseIdentifier: Strings.profileCell)
    }
    
}


//MARK: - Table View Data Source

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettingsViewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = profileSettingsViewModel.profileCell(profileTableView, indexPath, profileSettingsViewModel.data)
        return profileCell
    }
    
}


//MARK: - Table View Delegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedCell = profileSettingsViewModel.data[indexPath.row].model!.first!.settingLabel
        if clickedCell == Strings.profileSettingsLogout {
            signOutUser()
        }
    }
    
}
