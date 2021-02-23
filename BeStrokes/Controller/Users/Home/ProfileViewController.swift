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
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileTrademark1Label: UILabel!
    @IBOutlet weak var profileTrademark2Label: UILabel!
    
    
    //MARK: - Constants / Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var profileSettingsViewModel: [ProfileSettingsViewModel]!
    private let fetchProfileData = FetchProfileData()
    private let user = User()
    private var skeletonColor: UIColor?
    private var hasProfilePicLoaded = false
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setDataSourceAndDelegate()
        registerNib()
        setData()
        
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
        Utilities.setDesignOn(label: profileTrademark1Label, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileTrademark1Text)
        Utilities.setDesignOn(label: profileTrademark2Label, fontName: Strings.defaultFontMedium, fontSize: 10, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileTrademark2Text)
        Utilities.setDesignOn(tableView: profileTableView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), separatorStyle: .singleLine, showVerticalScrollIndicator: false, separatorColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), rowHeight: 50)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if appDelegate.isLightModeOn {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            if hasProfilePicLoaded {
                profileImageContentView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
                profileImageContentView.layer.shadowOpacity = 1
                profileImageContentView.layer.shadowOffset = .zero
                profileImageContentView.layer.shadowRadius = 5
                profileImageContentView.layer.masksToBounds = false
            }
            
            profileContentView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            profileContentView.layer.shadowOpacity = 1
            profileContentView.layer.shadowOffset = .zero
            profileContentView.layer.shadowRadius = 2
            profileContentView.layer.masksToBounds = false
            
            profileContentView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            profileNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            profileEmailLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            profileContentView.layer.shadowColor = nil
            profileContentView.layer.shadowOpacity = 0
            profileContentView.layer.shadowOffset = .zero
            profileContentView.layer.shadowRadius = 0
            profileContentView.layer.masksToBounds = true
            
            profileImageContentView.layer.shadowColor = nil
            profileImageContentView.layer.shadowOpacity = 0
            profileImageContentView.layer.shadowOffset = .zero
            profileImageContentView.layer.shadowRadius = 0
            profileImageContentView.layer.masksToBounds = true
            
            profileContentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            profileNameLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            profileEmailLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        }
    }
    
    func setSkeletonColor() {
        if appDelegate.isLightModeOn {
            skeletonColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        } else {
            skeletonColor = #colorLiteral(red: 0.2006691098, green: 0.200709641, blue: 0.2006634176, alpha: 1)
        }
    }
    
    func showLoadingSkeletonView() {
        setSkeletonColor()
        DispatchQueue.main.async { [self] in
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
    }
    
    func hideLoadingSkeletonView() {
        profileImageContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        profileNameLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        profileEmailLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        if appDelegate.isLightModeOn {
            profileImageContentView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            profileImageContentView.layer.shadowOpacity = 1
            profileImageContentView.layer.shadowOffset = .zero
            profileImageContentView.layer.shadowRadius = 5
            profileImageContentView.layer.masksToBounds = false
        }
    }
    
    func getSignedInUserData() {
        user.getSignedInUserData { [self] (error, isUserSignedIn, userData) in
            guard let error = error else {
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                    return
                }
                guard let userData = userData else {return}
                profileImageView.kf.setImage(with: URL(string: userData.profilePic)!)
                profileNameLabel.text = "\(userData.firstName) \(userData.lastname)"
                profileEmailLabel.text = userData.email
                hasProfilePicLoaded = true
                hideLoadingSkeletonView()
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
    }
    
    func setData() {
        profileSettingsViewModel = fetchProfileData.settings()
        showLoadingSkeletonView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            getSignedInUserData()
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
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: Strings.logoutAlertTitle, message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: Strings.logoutNoAction, style: .cancel)
        let yesAction = UIAlertAction(title: Strings.logoutYesAction, style: .default) { [self] (action) in
            let signOutUser = user.signOutUser { (isUserSignedIn) in
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                    return
                }
            }
            if !signOutUser {
                showErrorFetchingAlert(usingError: false, withCustomizedString: Strings.profileCannotSignOutUserLabel)
                return
            }
            transitionToLandingVC()
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    func transitionToLandingVC() {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
        view.window?.rootViewController = landingVC
        view.window?.makeKeyAndVisible()
    }
    
    
    //MARK: - Table View Process
    
    func setDataSourceAndDelegate() {
        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
    
    func registerNib() {
        profileTableView.register(UINib(nibName: Strings.profileCell, bundle: nil), forCellReuseIdentifier: Strings.profileCell)
    }
    
}


//MARK: - Table View Data Source

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettingsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.profileCell) as! ProfileTableViewCell
        DispatchQueue.main.async { [self] in
            cell.profileSettingsViewModel = profileSettingsViewModel[indexPath.item]
        }
        return cell
    }
    
}


//MARK: - Table View Delegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedCell = profileSettingsViewModel[indexPath.item].profileSettings.first!.settingLabel
        if clickedCell == Strings.profileSettingsLogout {
            showLogoutAlert()
        }
    }
    
}
