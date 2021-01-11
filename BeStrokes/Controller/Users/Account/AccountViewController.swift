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
    @IBOutlet weak var accountBottomView: UIView!
    @IBOutlet weak var accountNotificationButtonLabel: UIButton!
    @IBOutlet weak var accountEditButtonLabel: UIButton!
    @IBOutlet weak var accountHeadingLabelText: UILabel!
    @IBOutlet weak var accountNameHeadingLabelText: UILabel!
    @IBOutlet weak var accountEmailHeadingLabelText: UILabel!
    @IBOutlet weak var accountLikedStickersHeadingLabelText: UILabel!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLikedStickersTableView: UITableView!
    
    
    //MARK: - Constants / Variables
    
    private let user = User()
    private let fetchStickerData = FetchStickerData()
    private var stickerViewModel: [StickerViewModel]?
    
    
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
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: accountTopView, backgroundColor: .clear)
        Utilities.setDesignOn(view: accountBottomView, backgroundColor: .clear)
        Utilities.setDesignOn(button: accountNotificationButtonLabel, backgroundImage: UIImage(systemName: Strings.accountNotificationIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(button: accountEditButtonLabel, backgroundImage: UIImage(systemName: Strings.accountEditAccountIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(imageView: accountImageView, isPerfectCircle: true)
        Utilities.setDesignOn(label: accountHeadingLabelText, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .center, text: Strings.accountHeadingText)
        Utilities.setDesignOn(label: accountNameHeadingLabelText, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .center, text: " ", canResize: true, minimumScaleFactor: 0.6)
        Utilities.setDesignOn(label: accountEmailHeadingLabelText, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .center, text: " ", canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(label: accountLikedStickersHeadingLabelText, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.accountLikedStickersHeadingText)
        Utilities.setDesignOn(tableView: accountLikedStickersTableView, backgroundColor: .clear, separatorStyle: .none, showVerticalScrollIndicator: false, rowHeight: 170)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            accountImageView.isSkeletonable = true
            Utilities.setDesignOn(imageView: accountImageView, isSkeletonPerfectCircle: true)
            accountNameHeadingLabelText.isSkeletonable = true
            accountEmailHeadingLabelText.isSkeletonable = true
            accountImageView.showAnimatedSkeleton()
            accountNameHeadingLabelText.showAnimatedSkeleton()
            accountEmailHeadingLabelText.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        accountImageView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountNameHeadingLabelText.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountEmailHeadingLabelText.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func setData() {
        fetchStickerData.stickerCollectionView(category: "All") { [self] (result) in
            stickerViewModel = result
            DispatchQueue.main.async {
                accountLikedStickersTableView.reloadData()
            }
        }
        showLoadingSkeletonView()
        user.getSignedInUserData { [self] (result) in
            let profilePic = result.profilePic
            let firstName = result.firstName
            let lastName = result.lastname
            let email = result.email
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                accountImageView.kf.setImage(with: profilePic)
                accountNameHeadingLabelText.text = "\(firstName) \(lastName)"
                accountEmailHeadingLabelText.text = email
                hideLoadingSkeletonView()
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func accountNotificationButton(_ sender: UIButton) {
        
    }
    
    @IBAction func accountEditButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let editAccountContainerVC = storyboard.instantiateViewController(identifier: Strings.editAccountContainerVC) as! EditAccountContainerViewController
        present(editAccountContainerVC, animated: true)
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
        return stickerViewModel?.count ?? 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.likedStickerCell) as! LikedStickersTableViewCell
        if stickerViewModel != nil {
            DispatchQueue.main.async { [self] in
                cell.stickerViewModel = stickerViewModel![indexPath.item]
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
        stickerOptionVC.stickerViewModel = stickerViewModel![indexPath.item]
        present(stickerOptionVC, animated: true)
        
    }
    
}

