//
//  SampleTableViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/28/20.
//

import UIKit
import Firebase

class SampleTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStickers()
    

        
    }
    
    var stickerDictionary: [String: Any] = [:]

    
    
    func getStickers() {
    
        let db = Firestore.firestore()
        
        let stickerCollectionReference = db.collection("stickers").document("sample-stickers")
        stickerCollectionReference.getDocument { [self] (result, error) in
            if error != nil {
                // Show error
            } else {
                if let result = result?.data() {
                    stickerDictionary = result
//                    print(stickerDictionary.count)
                }
            }
        }
        
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(stickerDictionary.count)
        return stickerDictionary.count
    }
    

}
