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
        Utilities.setDesignOn(view: profileContentView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), setCustomCircleCurve: 25)
        Utilities.setDesignOn(navigationBar: profileNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(imageView: profileImageView, isCircular: true)
        Utilities.setDesignOn(label: profileNameLabel, font: Strings.defaultFontBold, fontSize: 20, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(label: profileEmailLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(label: profileHeadingLabel, font: Strings.defaultFontBold, fontSize: 30, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.profileSettingsHeadingText)
        Utilities.setDesignOn(label: profileTrademark1Label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: Strings.profileTrademark1Text)
        Utilities.setDesignOn(label: profileTrademark2Label, font: Strings.defaultFontMedium, fontSize: 10, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: Strings.profileTrademark2Text)
        Utilities.setDesignOn(tableView: profileTableView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), separatorStyle: .singleLine, showVerticalScrollIndicator: false, separatorColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), rowHeight: 50)
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
    
    func hideLoadingSkeletonView() {
        profileImageView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        profileNameLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        profileEmailLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func setData() {
        let profileSettingsData = fetchProfileData.settings()
        profileSettingsViewModel = profileSettingsData
        showLoadingSkeletonView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            user.getSignedInUserData { [self] (result) in
                let profilePic = URL(string: result.profilePic)!
                let firstName = result.firstName
                let lastName = result.lastname
                let email = result.email
                profileImageView.kf.setImage(with: profilePic)
                profileNameLabel.text = "\(firstName) \(lastName)"
                profileEmailLabel.text = email
                hideLoadingSkeletonView()
            }
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
        return profileSettingsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Strings.profileTableViewCell) as? ProfileTableViewCell {
            DispatchQueue.main.async { [self] in
                cell.profileViewModel = profileSettingsViewModel[indexPath.item]
            }
            return cell
        }
        return UITableViewCell()
    }
    
}


//MARK: - Table View Delegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedCell = profileSettingsViewModel[indexPath.item].profileSettings.first!.settingLabel
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
