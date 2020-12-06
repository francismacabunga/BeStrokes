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
        
        featuredContentView.layer.cornerRadius = 40
        featuredContentView.clipsToBounds = true
        featuredContentView.backgroundColor = .white
        
        featuredLabel.textColor = .black
        featuredLabel.font = UIFont(name: "Futura-Bold", size: 25)
        
        featuredOptionButtonLabel.setTitleColor(.black, for: .normal)
        
        featuredTryMeButtonLabel.layer.cornerRadius = featuredTryMeButtonLabel.bounds.height / 2
        featuredTryMeButtonLabel.clipsToBounds = true
        featuredTryMeButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 15)
        featuredTryMeButtonLabel.setTitleColor(.white, for: .normal)
        featuredTryMeButtonLabel.backgroundColor = .black
                
    }
    
    @IBAction func featuredOptionButton(_ sender: UIButton) {
    }
    
    @IBAction func tryMeButton(_ sender: UIButton) {
    }
    
    
}
