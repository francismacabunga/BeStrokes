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
    @IBOutlet weak var profileNameLabelText: UILabel!
    @IBOutlet weak var profileEmailLabelText: UILabel!
    @IBOutlet weak var profileHeadingLabelText: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileTrademark1LabelText: UILabel!
    @IBOutlet weak var profileTrademark2LabelText: UILabel!
    
    
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
        Utilities.setDesignOn(navigationBar: profileNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(view: profileContentView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), setCustomCircleCurve: 25)
        Utilities.setDesignOn(imageView: profileImageView, isPerfectCircle: true)
        Utilities.setDesignOn(label: profileNameLabelText, font: Strings.defaultFontBold, fontSize: 20, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(label: profileEmailLabelText, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(label: profileHeadingLabelText, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.profileSettingsHeadingText)
        Utilities.setDesignOn(label: profileTrademark1LabelText, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: Strings.profileTrademark1Text)
        Utilities.setDesignOn(label: profileTrademark2LabelText, font: Strings.defaultFontMedium, fontSize: 10, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: Strings.profileTrademark2Text)
        Utilities.setDesignOn(tableView: profileTableView, backgroundColor: .clear, separatorStyle: .singleLine, showVerticalScrollIndicator: false)
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            profileContentView.isSkeletonable = true
            profileContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        profileContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func setData() {
        let profileSettingsData = fetchProfileData.settings()
        profileSettingsViewModel = profileSettingsData
        
        showLoadingSkeletonView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            user.getSignedInUserData { [self] (result) in
                let profilePic = result.profilePic
                let firstName = result.firstName
                let lastName = result.lastname
                let email = result.email
                profileImageView.kf.setImage(with: profilePic)
                profileNameLabelText.text = "\(firstName) \(lastName)"
                profileEmailLabelText.text = email
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