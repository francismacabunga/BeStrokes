//
//  ProfileViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/8/21.
//

import UIKit
import Kingfisher

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
    
    private var profileSettingsViewModel: ProfileSettingsViewModel!
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
        Utilities.setDesignOn(view: view, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(navigationBar: profileNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(view: profileContentView, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), amountOfCurve: 25)
        Utilities.setDesignOn(imageView: profileImageView, isCircular: true)
        Utilities.setDesignOn(profileNameLabel, font: Strings.defaultFontBold, fontSize: 20, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .left, numberofLines: 1, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(profileEmailLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .left, numberofLines: 1, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(profileHeadingLabel, label: Strings.settingsHeadingText, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1)
        Utilities.setDesignOn(tableView: profileTableView, isTransparent: true, separatorStyle: .singleLine)
        Utilities.setDesignOn(profileTrademark1Label, label: Strings.profileTrademark1Text, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .center, numberofLines: 1)
        Utilities.setDesignOn(profileTrademark2Label, label: Strings.profileTrademark2Text, font: Strings.defaultFontMedium, fontSize: 10, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .center, numberofLines: 1)
    }
    
    func setData() {
        let profileSettingsData = fetchProfileData.settings()
        profileSettingsViewModel = profileSettingsData
        
        user.getSignedInUserData { [self] (result) in
            let profilePic = result.profilePic
            let firstName = result.firstName
            let lastName = result.lastname
            let email = result.email
            profileImageView.kf.setImage(with: profilePic)
            profileNameLabel.text = "\(firstName) \(lastName)"
            profileEmailLabel.text = email
        }
        
    }
    
    
    //MARK: - Table View Process
    
    func setDataSourceAndDelegate() {
        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
    
    func registerNib() {
        profileTableView.register(UINib(nibName: Strings.profileTableViewCell, bundle: nil), forCellReuseIdentifier: Strings.profileTableViewCell)
    }
    
}


//MARK: - Table View Data Source

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettingsViewModel!.profileSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Strings.profileTableViewCell) as? ProfileTableViewCell {
            cell.profileViewModel = profileSettingsViewModel!.profileSettings[indexPath.item]
            return cell
        }
        
        return UITableViewCell()
        
    }
    
}


//MARK: - Table View Delegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let clickedCell = profileSettingsViewModel.profileSettings[indexPath.item]
        if clickedCell == Strings.profileSettingsLogout {
            let alert = UIAlertController(title: Strings.logoutAlertTitle, message: nil, preferredStyle: .alert)
            let noAction = UIAlertAction(title: Strings.logoutNoAction, style: .cancel)
            let yesAction = UIAlertAction(title: Strings.logoutYesAction, style: .default) { [self] (action) in
                
                let signoutUser = user.signOutUser()
                if signoutUser! {
                    let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
                    let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
                    view.window?.rootViewController = landingVC
                    view.window?.makeKeyAndVisible()
                } else {
                    // Show error
                }
                
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated: true)
        }
        
    }
    
}
