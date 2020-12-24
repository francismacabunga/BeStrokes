//
//  StickerOptionViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/20/20.
//

import UIKit

struct StickerOptionContent {
    let symbolName: String
    let label: String
}

class StickerOptionViewController: UIViewController {
    
    @IBOutlet weak var backgroundStackContentView: UIStackView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var upperBackgroundContentView: UIView!
    @IBOutlet weak var lowerBackgroundContentView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    
  
    
    var stickerOptionContent = [
        StickerOptionContent(symbolName: "heart", label: "Heart it"),
        StickerOptionContent(symbolName: "camera", label: "Try me")]
    
    var sample = ["Francis", "Norman"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designElements()
        addGestureRecognizers()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StickerOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "StickerOptionTableViewCell")
        tableView.rowHeight = 50
        tableView.separatorStyle = .singleLine
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
            transparentView.backgroundColor = .black
            transparentView.alpha = 0.4
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        transparentView.backgroundColor = .clear
    }
    
    func designElements() {
        view.backgroundColor = .clear
        backgroundStackContentView.backgroundColor = .clear
        
        upperBackgroundContentView.backgroundColor = .black
        upperBackgroundContentView.alpha = 0.4
        lowerBackgroundContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        
        contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        
        
        transparentView.backgroundColor = .clear
        
        
        
        
        
        
        
        let image = UIImage(named: "White_Bar")
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationBar.topItem?.titleView = imageView
        navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationBar.isTranslucent = true
        
        tableView.backgroundColor = .clear
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func addGestureRecognizers() {
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        transparentView.addGestureRecognizer(tapToDismiss)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler))
        swipeDown.direction = .down
        navigationBar.addGestureRecognizer(swipeDown)
    }
    
    @objc func tapGestureHandler() {
        self.dismiss(animated: true)
    }
    
    @objc func swipeGestureHandler(gesture: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }
    
}














extension StickerOptionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stickerOptionContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StickerOptionTableViewCell", for: indexPath) as! StickerOptionTableViewCell
        cell.stickerOptionImageView.image = UIImage(systemName: stickerOptionContent[indexPath.row].symbolName)
        cell.stickerOptionLabel.text = stickerOptionContent[indexPath.row].label
        
        return cell
    }
    
    
}
