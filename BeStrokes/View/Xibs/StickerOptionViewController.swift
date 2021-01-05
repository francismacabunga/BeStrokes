//
//  StickerOptionViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/5/21.
//

import UIKit

class StickerOptionViewController: UIViewController {
    
    @IBOutlet weak var stickerNavigationBar: UINavigationBar!
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stackContentView: UIStackView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var tryMeButton: UIButton!
    
    @IBOutlet weak var stickerName: UILabel!
    @IBOutlet weak var stickerCategory: UILabel!
    @IBOutlet weak var stickerTag: UILabel!
    @IBOutlet weak var stickerDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        
    }
    
    func setDesignElements() {
        
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stackContentView.backgroundColor = .clear
        upperView.backgroundColor = .clear
        middleView.backgroundColor = .clear
        bottomView.backgroundColor = .clear
        
        Utilities.setDarkAppearance(on: stickerNavigationBar)
        
        stickerImageView.image = UIImage(named: "Lion")
        stickerImageView.contentMode = .scaleAspectFit
        
        stickerName.text = "Butterfly"
        stickerName.font = UIFont(name: "Futura-Bold", size: 40)
        stickerName.textColor = .black
        
        stickerCategory.text = "Animal"
        stickerCategory.font = UIFont(name: "Futura-Bold", size: 15)
        stickerCategory.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerCategory.textAlignment = .center
        stickerCategory.backgroundColor = .black
        stickerCategory.layer.cornerRadius = stickerCategory.bounds.height / 2
        stickerCategory.clipsToBounds = true
        
        stickerTag.text = "Featured"
        stickerTag.font = UIFont(name: "Futura-Bold", size: 15)
        stickerTag.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerTag.textAlignment = .center
        stickerTag.backgroundColor = .black
        stickerTag.layer.cornerRadius = stickerCategory.bounds.height / 2
        stickerTag.clipsToBounds = true
        
        stickerDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
        stickerDescription.numberOfLines = 0
        stickerDescription.font = UIFont(name: "Futura", size: 17)
        stickerDescription.adjustsFontSizeToFitWidth = true
        stickerDescription.minimumScaleFactor = 1
        stickerDescription.textColor = .black
        
        stickerHeartButtonImageView.image = UIImage(systemName: "heart")
        stickerHeartButtonImageView.tintColor = .black
        
        tryMeButton.setTitle("Try me", for: .normal)
        tryMeButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        tryMeButton.titleLabel?.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        tryMeButton.backgroundColor = .black
        tryMeButton.layer.cornerRadius = tryMeButton.bounds.height / 2
        tryMeButton.clipsToBounds = true
        
    }
    
}
