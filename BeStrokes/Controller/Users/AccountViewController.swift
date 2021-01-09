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
    @IBOutlet weak var accountNotificationButton: UIButton!
    @IBOutlet weak var accountEditButton: UIButton!
    @IBOutlet weak var accountHeadingLabel: UILabel!
    @IBOutlet weak var accountNameHeadingLabel: UILabel!
    @IBOutlet weak var accountEmailHeadingLabel: UILabel!
    @IBOutlet weak var accountLikedStickersHeadingLabel: UILabel!
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
        Utilities.setDesignOn(view: view, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: accountTopView, color: .clear)
        Utilities.setDesignOn(view: accountBottomView, color: .clear)
        Utilities.setDesignOn(button: accountNotificationButton, tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundImage: UIImage(systemName: Strings.accountNotificationIcon))
        Utilities.setDesignOn(button: accountEditButton, tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundImage: UIImage(systemName: Strings.accountEditAccountIcon))
        Utilities.setDesignOn(imageView: accountImageView, isCircular: true)
        Utilities.setDesignOn(accountHeadingLabel, label: Strings.accountProfileHeadingText, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .center, numberofLines: 1)
        Utilities.setDesignOn(accountNameHeadingLabel, label: " ", font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .center, numberofLines: 1, canResize: true, minimumScaleFactor: 0.6)
        Utilities.setDesignOn(accountEmailHeadingLabel, label: " ", font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .center, numberofLines: 1, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(accountLikedStickersHeadingLabel, label: Strings.accountLikedStickersHeadingText, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .left, numberofLines: 1)
        Utilities.setDesignOn(tableView: accountLikedStickersTableView, isTransparent: true, separatorStyle: .none, rowHeight: 170, showVerticalScrollIndicator: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            accountImageView.isSkeletonable = true
            Utilities.setDesignOn(imageView: accountImageView, isCircularSkeleton: true)
            accountNameHeadingLabel.isSkeletonable = true
            accountEmailHeadingLabel.isSkeletonable = true
            accountImageView.showAnimatedSkeleton()
            accountNameHeadingLabel.showAnimatedSkeleton()
            accountEmailHeadingLabel.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        accountImageView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountNameHeadingLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
        accountEmailHeadingLabel.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func setData() {
        fetchStickerData.forStickerCollectionView(category: "All") { [self] (result) in
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
                accountNameHeadingLabel.text = "\(firstName) \(lastName)"
                accountEmailHeadingLabel.text = email
                hideLoadingSkeletonView()
            }
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
    
}

