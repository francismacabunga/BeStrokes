//
//  ProfileViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/8/21.
//

import UIKit

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
    private let fetchUserData = FetchUserData()
    
    private var userProfilePic: String?
    private var userFirstName: String?
    private var userEmail: String?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setDataSourceAndDelegate()
        registerNib()
        getProfileSettingsData()
        
        
        
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        
        Utilities.setDesignOn(view: view, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(navigationBar: profileNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(view: profileContentView, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), amountOfCurve: 25)
        Utilities.setDesignOn(imageView: profileImageView, image: UIImage(named: "Avatar"), isCircular: true)
        Utilities.setDesignOn(profileNameLabel, label: "Derek Norman", font: Strings.defaultFontBold, fontSize: 17, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .left, numberofLines: 1, canResize: true, minimumScaleFactor: 0.7)
        Utilities.setDesignOn(profileEmailLabel, label: "creednormanm@test.com", font: Strings.defaultFontBold, fontSize: 12, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .left, numberofLines: 1, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(profileHeadingLabel, label: "Settings", font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1)
        Utilities.setDesignOn(tableView: profileTableView, isTransparent: true, separatorStyle: .singleLine)
        Utilities.setDesignOn(profileTrademark1Label, label: "BeStrokes", font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .center, numberofLines: 1)
        Utilities.setDesignOn(profileTrademark2Label, label: "made By Francis", font: Strings.defaultFontMedium, fontSize: 10, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .center, numberofLines: 1)
        
    }
    
    
    //MARK: - Table View Process
    
    func setDataSourceAndDelegate() {
        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
    
    func registerNib() {
        profileTableView.register(UINib(nibName: Strings.profileTableViewCell, bundle: nil), forCellReuseIdentifier: Strings.profileTableViewCell)
    }
    
    func getProfileSettingsData() {
        let profileSettingsData = fetchProfileData.settings()
        profileSettingsViewModel = profileSettingsData
        
//        fetchUserData.signedInUser(completed: <#T##(UserViewModel) -> Void#>)
        
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
        
        
//        if clickedCell == ""
        
        
        
    }
    
}
