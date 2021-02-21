//
//  LandingPageContentViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/10/20.
//

import UIKit

class LandingPageContentViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var landingPageContentStackView: UIStackView!
    @IBOutlet weak var landingPageContentLabelStackView: UIStackView!
    @IBOutlet weak var landingPageContentImageView: UIImageView!
    @IBOutlet weak var landingPageContentHeadingLabel: UILabel!
    @IBOutlet weak var landingPageContentSubheadingLabel: UILabel!
    
    
    //MARK: - Constants / Variables
    
    var imageFileName = ""
    var headingLabelText: String?
    var subheadingText: String?
    var index = 0
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setData()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(stackView: landingPageContentStackView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: landingPageContentLabelStackView, backgroundColor: .clear)
        Utilities.setDesignOn(label: landingPageContentHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: landingPageContentSubheadingLabel, fontName: Strings.defaultFontMedium, fontSize: 17, numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
     
    func setData() {
        landingPageContentImageView.image = UIImage(named: imageFileName)
        landingPageContentHeadingLabel.text = headingLabelText
        landingPageContentSubheadingLabel.text = subheadingText
    }
    
}
