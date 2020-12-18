//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView

class StickersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerOptionButtonLabel: UIButton!
    @IBOutlet weak var stickerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
    }
    
    func designElements() {
        stickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerContentView.layer.cornerRadius = 30
        stickerContentView.clipsToBounds = true
        stickerLabel.textAlignment = .left
        stickerLabel.numberOfLines = 1
        stickerLabel.adjustsFontSizeToFitWidth = true
        stickerLabel.minimumScaleFactor = 0.8
        stickerLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        stickerOptionButtonLabel.setTitle("...", for: .normal)
        stickerOptionButtonLabel.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        stickerOptionButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        stickerImageView.contentMode = .scaleAspectFit
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            stickerContentView.isSkeletonable = true
            stickerContentView.skeletonCornerRadius = 40
            stickerContentView.showAnimatedSkeleton()
        }
    }
    
    func setData(with data: StickerData) {
        
        let stickerLabel = data.name
        let stickerImage = data.image
        
        hideLoadingSkeletonView()
        designElements()
        setStikcerLabelAndImage(with: stickerLabel, stickerImage)
        
    }
    
    let cache = NSCache<NSURL, UIImage>()
    var sessionTask: URLSessionDataTask!
    
    func setStikcerLabelAndImage(with name: String, _ imageURL: URL) {
        
        stickerLabel.text = name

        
        if let cachedImageData = cache.object(forKey: imageURL as NSURL) {
            print("hi")
            stickerImageView.image = cachedImageData
            return
        }
        
        fetchImageData(using: imageURL)
        
    }
    
    
    func fetchImageData(using imageURL: URL) {
        stickerImageView.image = nil
        
        if let sessionTask = sessionTask {
            sessionTask.cancel()
        }
        
        sessionTask = URLSession.shared.dataTask(with: imageURL) { [self] (data, response, error) in
            if error != nil {
                // Show error
            } else {
                print("Networking starting!")
                
                if let result = data {
                    let image = UIImage(data: result)!
                    cache.setObject(image, forKey: imageURL as NSURL)
                    DispatchQueue.main.async { [self] in
                        stickerImageView.image = image
                    }
                }
            }
        }
        sessionTask.resume()
    }
    
    
    
    
    func hideLoadingSkeletonView() {
        stickerContentView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.1))
    }
    
    
    
    @IBAction func stickersOptionButton(_ sender: UIButton) {
        
    }
    
    
    
    func downloadAndConvertToData(using dataString: String, completed: @escaping (Data) -> Void) {
        
        if let url = URL(string: dataString) {
            let session = URLSession(configuration: .default)
            let sample = session.dataTask(with: url)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // Show error
                } else {
                    if let result = data {
                        completed(result)
                    }
                }
            }
            task.resume()
        }
    }
    
}
