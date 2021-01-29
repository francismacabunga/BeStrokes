//
//  ProfileController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import Firebase
import Kingfisher
import SkeletonView

class AccountViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var accountTopView: UIView!
    @IBOutlet weak var accountBottomStackView: UIStackView!
    @IBOutlet weak var accountBottomSearchContentView: UIView!
    @IBOutlet weak var accountTextFieldContentView: UIView!
    @IBOutlet weak var accountHeading1Label: UILabel!
    @IBOutlet weak var accountHeading2Label: UILabel!
    @IBOutlet weak var accountNameHeadingLabel: UILabel!
    @IBOutlet weak var accountEmailHeadingLabel: UILabel!
    @IBOutlet weak var accountNotificationButton: UIButton!
    @IBOutlet weak var accountEditButton: UIButton!
    @IBOutlet weak var accountSearchButton: UIButton!
    @IBOutlet weak var accountSearchTextField: UITextField!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLikedStickersTableView: UITableView!
    
    
    //MARK: - Constants / Variables
    
    private let user = User()
    private let fetchStickerData = FetchStickerData()
    private var likedStickerViewModel: [LikedStickerViewModel]?
    private var userViewModel: UserViewModel?
    private let heartButtonLogic = HeartButtonLogic()
    private var isButtonPressed = false
    
    
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
        accountTextFieldContentView.isHidden = true
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: accountTopView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), setCustomCircleCurve: 30)
        Utilities.setDesignOn(stackView: accountBottomStackView, backgroundColor: .clear)
        Utilities.setDesignOn(view: accountBottomSearchContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: accountTextFieldContentView, backgroundColor: .clear)
        Utilities.setDesignOn(button: accountNotificationButton, backgroundImage: UIImage(systemName: Strings.accountNotificationIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(button: accountEditButton, backgroundImage: UIImage(systemName: Strings.accountEditAccountIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(button: accountSearchButton, backgroundImage: UIImage(systemName: Strings.accountSearchStickerIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(textField: accountSearchTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.searchTextField, placeholderTextColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(imageView: accountImageView, isCircular: true)
        Utilities.setDesignOn(label: accountHeading1Label, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: Strings.accountHeading1Text)
        Utilities.setDesignOn(label: accountNameHeadingLabel, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: " ", canResize: true, minimumScaleFactor: 0.6)
        Utilities.setDesignOn(label: accountEmailHeadingLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: " ", canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(label: accountHeading2Label, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.accountHeading2Text)
        Utilities.setDesignOn(tableView: accountLikedStickersTableView, backgroundColor: .clear, separatorStyle: .none, showVerticalScrollIndicator: false, rowHeight: 170)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            accountImageView.isSkeletonable = true
            Utilities.setDesignOn(imageView: accountImageView, isSkeletonCircular: true)
            accountNameHeadingLabel.isSkeletonable = true
            accountEmailHeadingLabel.isSkeletonable = true
            accountImageView.showAnimatedSkeleton()
            accountNameHeadingLabel.showAnimatedSkeleton()
            accountEmailHeadingLabel.showAnimatedSkeleton()
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
    
    func hideLoadingSkeletonView() {
        accountImageView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountNameHeadingLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountEmailHeadingLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func transitionToLandingVC() {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
        view.window?.rootViewController = landingVC
        view.window?.makeKeyAndVisible()
    }
    
    func getSignedInUserData() {
        user.getSignedInUserData { [self] (error, isUserSignedIn, userData) in
            if error != nil {
                showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
                return
            }
            guard let isUserSignedIn = isUserSignedIn else {return}
            if !isUserSignedIn {
                showNoSignedInUserAlert()
                return
            }
            guard let userData = userData else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                accountImageView.kf.setImage(with: URL(string: userData.profilePic)!)
                accountNameHeadingLabel.text = "\(userData.firstName) \(userData.lastname)"
                accountEmailHeadingLabel.text = userData.email
                hideLoadingSkeletonView()
            }
        }
    }
    
    func setData() {
        heartButtonLogic.showLovedStickers { [self] (error, isUserSignedIn, likedStickerData) in
            likedStickerViewModel = likedStickerData
            DispatchQueue.main.async {
                accountLikedStickersTableView.reloadData()
            }
        }
        
        
        //        fetchStickerData.stickerCollectionView(category: Strings.categoryAllStickers) { [self] (result) in
        //            stickerViewModel = result
        //            DispatchQueue.main.async {
        //                accountLikedStickersTableView.reloadData()
        //            }
        //        }
        
        showLoadingSkeletonView()
        getSignedInUserData()
    }
    
    
    //MARK: - Buttons
    
    @IBAction func accountNotificationButton(_ sender: UIButton) {
        
    }
    
    @IBAction func accountSearchButton(_ sender: UIButton) {
        isButtonPressed = !isButtonPressed
        if isButtonPressed {
            accountTextFieldContentView.isHidden = false
            Utilities.setDesignOn(button: accountSearchButton, backgroundImage: UIImage(systemName: Strings.accountArrowUpIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        } else {
            accountTextFieldContentView.isHidden = true
            Utilities.setDesignOn(button: accountSearchButton, backgroundImage: UIImage(systemName: Strings.accountSearchStickerIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        }
    }
    
    
    //MARK: - Table View Process
    
    func setDataSourceAndDelegate() {
        accountLikedStickersTableView.dataSource = self
        accountLikedStickersTableView.delegate = self
    }
    
    func registerNib() {
        accountLikedStickersTableView.register(UINib(nibName: Strings.likedStickerCell, bundle: nil), forCellReuseIdentifier: Strings.likedStickerCell)
    }
    
}


//MARK: - Table View Data Source

extension AccountViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedStickerViewModel?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.likedStickerCell) as! LikedStickersTableViewCell
        if likedStickerViewModel != nil {
            DispatchQueue.main.async { [self] in
                cell.likedStickerViewModel = likedStickerViewModel![indexPath.item]
                cell.prepareLikedStickerCollectionViewCell()
            }
            return cell
        }
        return cell
    }
    
}


//MARK: - Table View Delegate

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let stickerOptionVC = storyboard.instantiateViewController(identifier: Strings.stickerOptionVC) as! StickerOptionViewController
        stickerOptionVC.setDesignElements()
        stickerOptionVC.registerGestures()
        stickerOptionVC.setStickerData(using: likedStickerViewModel![indexPath.item])
        present(stickerOptionVC, animated: true)
    }
    
}
