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
        Utilities.setDesignOn(navigationBar: profileNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(imageView: profileImageView, isCircular: true)
        Utilities.setDesignOn(label: profileNameLabel, font: Strings.defaultFontBold, fontSize: 20, numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(label: profileEmailLabel, font: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(label: profileHeadingLabel, font: Strings.defaultFontBold, fontSize: 30, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileSettingsHeadingText)
        Utilities.setDesignOn(label: profileTrademark1Label, font: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileTrademark1Text)
        Utilities.setDesignOn(label: profileTrademark2Label, font: Strings.defaultFontMedium, fontSize: 10, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.profileTrademark2Text)
        Utilities.setDesignOn(tableView: profileTableView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), separatorStyle: .singleLine, showVerticalScrollIndicator: false, separatorColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), rowHeight: 50)
        checkThemeAppearance()
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
    }
    
    func checkThemeAppearance() {
        if appDelegate.isLightModeOn {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        print("Light Mode Activated - ProfileVC")
        UIView.animate(withDuration: 0.3) { [self] in
            // For shadow
            profileContentView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            profileContentView.layer.shadowOpacity = 1
            profileContentView.layer.shadowOffset = .zero
            profileContentView.layer.shadowRadius = 5
            profileContentView.layer.masksToBounds = false
            
            profileContentView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            profileNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            profileEmailLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @objc func setDarkMode() {
        print("Dark Mode Activated - ProfileVC")
        UIView.animate(withDuration: 0.3) { [self] in
            // For shadow
            profileContentView.layer.shadowColor = nil
            profileContentView.layer.shadowOpacity = 0
            profileContentView.layer.shadowOffset = .zero
            profileContentView.layer.shadowRadius = 0
            profileContentView.layer.masksToBounds = true
            
            profileContentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            profileNameLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            profileEmailLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        }
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            profileImageView.isSkeletonable = true
            Utilities.setDesignOn(imageView: profileImageView, isSkeletonCircular: true)
            profileImageView.showAnimatedSkeleton()
            profileNameLabel.isSkeletonable = true
            profileNameLabel.showAnimatedSkeleton()
            profileEmailLabel.isSkeletonable = true
            profileEmailLabel.showAnimatedSkeleton()
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
    
    func hideLoadingSkeletonView() {
        profileImageView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        profileNameLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        profileEmailLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func transitionToLandingVC() {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
        view.window?.rootViewController = landingVC
        view.window?.makeKeyAndVisible()
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
