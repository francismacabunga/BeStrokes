//
//  NotificationViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 2/28/21.
//

import UIKit

class NotificationViewController: UIViewController {
    
    //MARK: - Constants / Variables
    
    private let fetchStickerData = FetchStickerData()
    private var initialNumberOfStickers: Int?
    private var currentNumberOfStickers: Int?
    

    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        fetchStickerData.stickerCollectionView(category: Strings.allStickers) { [self] (error, stickerData) in
            
            initialNumberOfStickers = stickerData?.count
            currentNumberOfStickers = stickerData?.count
        }
        
        
        print("Initial: \(initialNumberOfStickers)")
        print("Current: \(currentNumberOfStickers)")
    }
    

    

}
