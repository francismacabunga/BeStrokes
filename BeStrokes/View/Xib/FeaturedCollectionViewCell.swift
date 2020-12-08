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
    @IBOutlet weak var featuredOptionButtonLabel: UIButton!
    @IBOutlet weak var featuredTryMeButtonLabel: UIButton!
    
    @IBOutlet weak var featuredImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        featuredContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        featuredContentView.layer.cornerRadius = 40
        featuredContentView.clipsToBounds = true
        
        
        featuredLabel.text = "Elephant"
        featuredLabel.numberOfLines = 0
        featuredLabel.lineBreakMode = .byWordWrapping
        featuredLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        featuredLabel.font = UIFont(name: "Futura-Bold", size: 25)
        
        
        featuredOptionButtonLabel.setTitle("...", for: .normal)
        featuredOptionButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 35)
        featuredOptionButtonLabel.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        

        featuredTryMeButtonLabel.setTitle("Try me", for: .normal)
        featuredTryMeButtonLabel.layer.cornerRadius = featuredTryMeButtonLabel.bounds.height / 2
        featuredTryMeButtonLabel.clipsToBounds = true
        featuredTryMeButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 15)
        featuredTryMeButtonLabel.setTitleColor(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), for: .normal)
        featuredTryMeButtonLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        featuredImageView.image = UIImage(named: "Elephant")
        featuredImageView.contentMode = .scaleAspectFit
                
    }
    
    @IBAction func featuredOptionButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tryMeButton(_ sender: UIButton) {
        
    }
    
    
}
