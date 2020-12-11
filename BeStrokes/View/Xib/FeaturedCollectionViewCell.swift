//
//  FeaturedCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredContentView: UIView!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var featuredHeartButtonLabel: UIButton!
    @IBOutlet weak var featuredTryMeButtonLabel: UIButton!
    @IBOutlet weak var featuredImageView: UIImageView!
    
  
    var heartButtonValue: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        designElements()
        
        featuredContentView.showSkeleton()
        
        
    }
    
    func setData(with data: FeaturedData) {
        
        featuredLabel.text = data.name
        featuredImageView.image = UIImage(data: data.image)
        
    }
    
    @IBAction func featuredHeartButton(_ sender: UIButton) {
        
        if heartButtonValue == "heart" {
            heartButtonValue = "heart.fill"
            
            featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: heartButtonValue!), for: .normal)
        } else {
            heartButtonValue = "heart"
            
            featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: heartButtonValue!), for: .normal)
            
        }
        
        
        
    }
    
    
  
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        
        print("Try me is selected")
    }
    
    
    
    func designElements() {
        featuredContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        featuredContentView.layer.cornerRadius = 40
        featuredContentView.clipsToBounds = true
        
        
        
        
        
        featuredLabel.numberOfLines = 0
        featuredLabel.lineBreakMode = .byWordWrapping
        featuredLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        featuredLabel.font = UIFont(name: "Futura-Bold", size: 25)
        
        
        featuredHeartButtonLabel.setTitle("", for: .normal)
//        featuredHeartButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 35)
        
        heartButtonValue = "heart"
        
        featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: heartButtonValue!), for: .normal)
        featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        featuredHeartButtonLabel.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        
        
        featuredTryMeButtonLabel.setTitle("Try me", for: .normal)
        featuredTryMeButtonLabel.layer.cornerRadius = featuredTryMeButtonLabel.bounds.height / 2
        featuredTryMeButtonLabel.clipsToBounds = true
        featuredTryMeButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 15)
        featuredTryMeButtonLabel.setTitleColor(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), for: .normal)
        featuredTryMeButtonLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
           
        
        featuredImageView.contentMode = .scaleAspectFit
        
        
//        featuredHeartButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
//        featuredHeartButton.setTitle("", for: .normal)
//        featuredHeartButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
        
        
    }
    
    
}
