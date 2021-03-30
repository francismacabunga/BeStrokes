//
//  NotificationViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 3/3/21.
//

import UIKit

class NotificationViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var notificationHeadingLabel: UILabel!
    @IBOutlet weak var notificationWarningLabel: UILabel!
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var notificationLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private let userData = UserData()
    private let stickerData = StickerData()
    private var userStickerViewModel: [UserStickerViewModel]?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setDataSourceAndDelegate()
        registerNIB()
        setNotificationData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfUserIsSignedIn()
    
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(label: notificationHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, textAlignment: .left, text: Strings.notificationHeadingText)
        Utilities.setDesignOn(label: notificationWarningLabel, fontName: Strings.defaultFontBold, fontSize: 20, numberofLines: 0, textAlignment: .center, isHidden: true)
        Utilities.setDesignOn(activityIndicatorView: notificationLoadingIndicatorView, size: .medium, isHidden: true)
        Utilities.setDesignOn(tableView: notificationTableView, backgroundColor: .clear, separatorStyle: UITableViewCell.SeparatorStyle.none, showVerticalScrollIndicator: false, rowHeight: 170, isHidden: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            return .darkContent
        } else {
            return .lightContent
        }
    }
    
    func checkThemeAppearance() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        Utilities.setDesignOn(view: view, backgroundColor: .white)
        Utilities.setDesignOn(label: notificationHeadingLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: notificationWarningLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(activityIndicatorView: notificationLoadingIndicatorView, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    @objc func setDarkMode() {
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: notificationHeadingLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(label: notificationWarningLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(activityIndicatorView: notificationLoadingIndicatorView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
    }
    
    func setNotificationData() {
        stickerData.fetchNewSticker { [self] (error, isUserSignedIn, _, userStickerData) in
            if !isUserSignedIn {
                guard let error = error else {return}
                showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                return
            }
            if error != nil {
                showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                return
            }
            guard let userStickerData = userStickerData else {return}
            userStickerViewModel = userStickerData
            checkIfUserStickerViewModelIsEmpty()
        }
    }
    
    func checkIfUserStickerViewModelIsEmpty() {
        Utilities.setDesignOn(activityIndicatorView: notificationLoadingIndicatorView, isStartAnimating: true, isHidden: false)
        Utilities.setDesignOn(label: notificationWarningLabel, text: Strings.notificationWarningLabel, isHidden: true)
        notificationTableView.isHidden = true
        if userStickerViewModel?.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                Utilities.setDesignOn(activityIndicatorView: notificationLoadingIndicatorView, isStartAnimating: false, isHidden: true)
                Utilities.setDesignOn(label: notificationWarningLabel, text: Strings.notificationWarningLabel, isHidden: false)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                notificationTableView.reloadData()
                Utilities.setDesignOn(activityIndicatorView: notificationLoadingIndicatorView, isStartAnimating: false, isHidden: true)
                Utilities.setDesignOn(label: notificationWarningLabel, isHidden: true)
                notificationTableView.isHidden = false
            }
        }
    }
    
    func checkIfUserIsSignedIn() {
        userData.checkIfUserIsSignedIn { [self] (error, isUserSignedIn, _) in
            if !isUserSignedIn {
                guard let error = error else {return}
                showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                return
            }
        }
    }
    
    func showAlertController(alertMessage: String, withHandler: Bool) {
        if UserDefaults.standard.bool(forKey: Strings.isNotificationVCLoadedKey) {
            if self.presentedViewController as? UIAlertController == nil {
                if withHandler {
                    let alertWithHandler = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: true) {
                        _ = Utilities.transition(from: self.view, to: Strings.landingVC, onStoryboard: Strings.guestStoryboard, canAccessDestinationProperties: false)
                    }
                    present(alertWithHandler!, animated: true)
                    return
                }
                let alert = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: false) {}
                present(alert!, animated: true)
            }
        }
    }
    
    
    //MARK: - Table View Process
    
    func setDataSourceAndDelegate() {
        notificationTableView.dataSource = self
        notificationTableView.delegate = self
    }
    
    func registerNIB() {
        notificationTableView.register(UINib(nibName: Strings.stickerTableViewCell, bundle: nil), forCellReuseIdentifier: Strings.stickerTableViewCell)
    }
    
}


//MARK: - Table View Data Source

extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userStickerViewModel?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.stickerTableViewCell) as! StickerTableViewCell
        guard let userStickerViewModel = userStickerViewModel else {return cell}
        cell.prepareStickerTableViewCell()
        cell.userStickerViewModel = userStickerViewModel[indexPath.item]
        cell.stickerCellDelegate = self
        return cell
    }
    
}


//MARK: - Table View Delegate

extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userStickerViewModel = userStickerViewModel else {return}
        let stickerOptionVC = Utilities.transition(to: Strings.stickerOptionVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! StickerOptionViewController
        DispatchQueue.main.async { [self] in
            stickerOptionVC.userStickerViewModel = userStickerViewModel[indexPath.item]
            stickerOptionVC.modalPresentationStyle = .fullScreen
            present(stickerOptionVC, animated: true)
        }
    }
}


//MARK: - Sticker Cell Delegate

extension NotificationViewController: StickerTableViewCellDelegate {
    
    func getVC(using viewController: UIViewController) {
        DispatchQueue.main.async { [self] in
            present(viewController, animated: true)
        }
    }
    
}

