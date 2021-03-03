//
//  NotificationTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 3/3/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var notificationContentView: UIView!
    @IBOutlet weak var notificationView: UIView!
    
    
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    var sampleValue: String? {
        didSet {
            notificationLabel.text = sampleValue
        }
    }
    
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    
        
       
    }

   
    
}
