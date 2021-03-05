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
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(label: notificationHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, textAlignment: .left, text: Strings.notificationHeadingLabel)
        Utilities.setDesignOn(label: notificationWarningLabel, fontName: Strings.defaultFontBold, fontSize: 20, numberofLines: 0, textAlignment: .center, isHidden: true)
        Utilities.setDesignOn(activityIndicatorView: notificationLoadingIndicatorView, size: .medium)
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
        stickerData.fetchStickerData(withNotificationData: true) { [self] (error, stickerData, userStickerData) in
            guard let error = error else {
                guard let userStickerData = userStickerData else {return}
                userStickerViewModel = userStickerData
                checkIfUserStickerViewModelIsEmpty()
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
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
        cell.userStickerViewModel = userStickerViewModel[indexPath.item]
        cell.prepareStickerTableViewCell()
        return cell
    }
    
}


//MARK: - Table View Delegate

extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let stickerOptionVC = storyboard.instantiateViewController(identifier: Strings.stickerOptionVC) as! StickerOptionViewController
        DispatchQueue.main.async { [self] in
            stickerOptionVC.prepareStickerOptionVC()
            present(stickerOptionVC, animated: true)
        }
    }
    
}





