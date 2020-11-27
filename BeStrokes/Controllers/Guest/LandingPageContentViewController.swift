//
//  LandingPageContentViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/10/20.
//

import UIKit

class LandingPageContentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subheadingLabel: UILabel!
    
    var imageFileName = ""
    var headingLabelText: String?
    var subheadingText: String?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designElements()
        imageView.image = UIImage(named: imageFileName)
        headingLabel.text = headingLabelText
        subheadingLabel.text = subheadingText
        
    }
    
    func designElements() {
        
        Utilities.putDesignOn(landingHeadingLabel: headingLabel)
        Utilities.putDesignOn(landingSubheadingLabel: subheadingLabel)
        
    }
    
}
