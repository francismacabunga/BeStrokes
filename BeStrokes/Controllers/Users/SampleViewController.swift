//
//  SampleViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/28/20.
//

import UIKit

class SampleViewController: UIViewController, HomeViewControllerDelegate {
    
    var sampleString: String?
    var connection = HomeViewController()
    
    func sendString(_ words: String) {
        sampleString = words
        print(sampleString)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        connection.delegate = self
        view.backgroundColor = UIColor.red
        print(sampleString)
    }
    

   

}
