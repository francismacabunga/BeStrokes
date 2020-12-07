//
//  StickersViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/7/20.
//

import UIKit

class StickersViewController: UIViewController {
    
    @IBOutlet weak var stickersSettingsImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickersSettingsImageView.image = UIImage(systemName: "slider.horizontal.3")
        stickersSettingsImageView.backgroundColor = UIColor.white
        stickersSettingsImageView.layer.cornerRadius = stickersSettingsImageView.bounds.width / 2
        stickersSettingsImageView.tintColor = .black
        
        
        
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    
  
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
       
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
}
