//
//  HomeController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailWarning: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var stickerDictionary: [String: Any] = [:]
    var sampleShit = ["Array"]
    var stickerArray = [Data?]()
    var convertedImageData: String?
    var sample = [Data?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNameOfSignedInUser()
        checkIfEmailIsVerified()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StickerCell", bundle: nil), forCellReuseIdentifier: "StickerCell")
        
        getSampleSticker { [self] (result) in
            stickerArray = result
            tableView.reloadData()
            //print("Inside: \(stickerArray)")
            
            
            
            
        }
        
        
        
        
        
    }
    
    func getNameOfSignedInUser() {
        
        if user != nil {
            let UID = user?.uid
            let collectionReference = db.collection(Strings.collectionName).whereField(Strings.UID, isEqualTo: UID)
            collectionReference.getDocuments { [self] (snapshot, error) in
                if error != nil {
                    print("Cannot retrieve data to database now.")
                } else {
                    guard let snapshotResult = snapshot?.documents.first else {
                        return
                    }
                    let firstName = snapshotResult[Strings.firstName] as! String
                    welcomeLabel.text = "Welcome \(firstName)"
                }
            }
        }
    }
    
    func checkIfEmailIsVerified() {
        
        if user != nil {
            if user!.isEmailVerified {
                emailWarning.text = "Your email is verified."
            } else {
                emailWarning.text = "Your email is not yet verified. Check your email."
            }
        }
    }
    
    
    
    func getSampleSticker(completion: @escaping([Data]) -> Void) {
        
        var myArray = [Data]()
        let collectionReference = db.collection("stickers").document("sample-stickers")
        let sample = collectionReference.getDocument { [self] (result, error) in
            
            if error != nil {
                // Show error
            } else {
                
                if let result = result?.data() {
                    stickerDictionary = result
                    
                    for everySticker in stickerDictionary {
                        let stickerValue = everySticker.value as! String
                        
                        
                        let imageURL = URL(string: stickerValue)
                        
                        do {
                            let imageData = try Data(contentsOf: imageURL!)
                            
                            myArray.append(imageData)
                        } catch {
                            
                        }
                        
                    }
                    
                }
                print(myArray)
                completion(myArray)
            }
            
        }
    }
}


extension HomeViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stickerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StickerCell", for: indexPath) as! StickerCell
        cell.stickerImageView.image = UIImage(data: stickerArray[indexPath.row]!)
        return cell
        
    }
    
    
    
    
}








