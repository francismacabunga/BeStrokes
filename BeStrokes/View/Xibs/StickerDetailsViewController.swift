//
//  StickerDetailsViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/27/20.
//

import UIKit

class StickerDetailsViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var stickerContentView: UIView!
    
    @IBOutlet weak var stickerNavigationBar: UINavigationBar!
    
   
    
    
    var stickerDetailsContent = ["Heart it", ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        
        
        Utilities.putDesignOn(navigationBar: stickerNavigationBar)
        
        
        
        
        

        
    }
    
    
    
    


 

}



    
    
    

