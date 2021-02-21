//
//  CaptureViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 9/21/20.
//

import UIKit
import SceneKit
import ARKit
import Kingfisher

class CaptureViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var captureSceneView: ARSCNView!
    @IBOutlet weak var captureVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var captureStackView: UIStackView!
    @IBOutlet weak var captureTutorialContentView: UIView!
    @IBOutlet weak var captureStickerContentView: UIView!
    @IBOutlet weak var capture1SpacerView: UIView!
    @IBOutlet weak var capture2SpacerView: UIView!
    @IBOutlet weak var captureExitButtonImageView: UIImageView!
    @IBOutlet weak var captureDeleteButtonImageView: UIImageView!
    @IBOutlet weak var captureChooseImageButtonImageView: UIImageView!
    @IBOutlet weak var captureTutorialImageView: UIImageView!
    @IBOutlet weak var captureStickerImageView: UIImageView!
    @IBOutlet weak var captureTutorial1Label: UILabel!
    @IBOutlet weak var captureTutorial2Label: UILabel!
    @IBOutlet weak var captureTutorial3Label: UILabel!
    @IBOutlet weak var captureStickerLabel: UILabel!
    @IBOutlet weak var captureStickerNameLabel: UILabel!
    @IBOutlet weak var captureDontShowAgainButton: UIButton!
    @IBOutlet weak var captureTutorialContentViewTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - Constants / Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var capture = Capture()
    private let imagePicker = UIImagePickerController()
    var isStickerPicked = false
    var isPresentedFromLandingVC = false
    private let trackingConfiguration = ARWorldTrackingConfiguration()
    private let stickerMaterial = SCNMaterial()
    private var planeNodes = [SCNNode]()
    private var stickerNodes = [SCNNode]()
    private var raycastTargetAlignment: ARRaycastQuery.TargetAlignment?
    var featuredStickerViewModel: FeaturedStickerViewModel? {
        didSet {
            guard let stickerData = featuredStickerViewModel else {return}
            downloadImage(using: stickerData.image)
        }
    }
    var stickerViewModel: StickerViewModel? {
        didSet {
            guard let stickerData = stickerViewModel else {return}
            downloadImage(using: stickerData.image)
        }
    }
    var lovedStickerViewModel: LovedStickerViewModel? {
        didSet {
            guard let stickerData = lovedStickerViewModel else {return}
            downloadImage(using: stickerData.image)
        }
    }
    
    
    //MARK: - View Controller Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        registerGestures()
        setDataSourceAndDelegate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNoPlaneDetection()
        if isPresentedFromLandingVC {
            showCaptureVCTutorial()
            captureTutorial3Label.isHidden = false
            return
        }
        if isPresentedWithTabBar() {
            if !appDelegate.openedFromCaptureButton {
                showCaptureVCTutorial()
            } else {
                showCaptureVCDefaultDesign()
            }
        } else {
            if !appDelegate.openedFromTryMeButton {
                showCaptureVCTutorial()
            } else {
                showCaptureVCDefaultDesign()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSceneView.session.pause()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(visualEffectView: captureVisualEffectView, blurEffect: UIBlurEffect(style: .regular), isHidden: true)
        Utilities.setDesignOn(stackView: captureStackView, isCircular: true, isHidden: true)
        Utilities.setDesignOn(view: captureTutorialContentView, backgroundColor: .clear, isHidden: true)
        Utilities.setDesignOn(view: captureStickerContentView, isCircular: true, isHidden: true)
        Utilities.setDesignOn(imageView: captureTutorialImageView, image: UIImage(named: Strings.tutorialDialogueImage))
        Utilities.setDesignOn(imageView: captureStickerImageView, image: UIImage(named: Strings.defaultStickerImage))
        Utilities.setDesignOn(imageView: captureExitButtonImageView, image: UIImage(systemName: Strings.captureExitIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(imageView: captureDeleteButtonImageView, image: UIImage(systemName: Strings.captureDeleteIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(imageView: captureChooseImageButtonImageView, image: UIImage(systemName: Strings.captureChooseImageIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: captureTutorial1Label, fontName: Strings.defaultFontBold, fontSize: 12, numberofLines: 1, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), text: Strings.captureTutorial1Label)
        Utilities.setDesignOn(label: captureTutorial2Label, fontName: Strings.defaultFontBold, fontSize: 25, numberofLines: 0, textAlignment: .center, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), text: Strings.captureTutorial2Label)
        Utilities.setDesignOn(label: captureTutorial3Label, fontName: Strings.defaultFontBold, fontSize: 12, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.captureTutorial3Label, isHidden: true)
        Utilities.setDesignOn(label: captureStickerLabel, fontName: Strings.defaultFont, fontSize: 12, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.captureStickerLabel)
        Utilities.setDesignOn(label: captureStickerNameLabel, fontName: Strings.defaultFontBold, fontSize: 20, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.captureDefaultStickerName)
        Utilities.setDesignOn(button: captureDontShowAgainButton, title: Strings.dontShowAgainButtonText, font: Strings.defaultFontBold, fontSize: 16, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if appDelegate.isLightModeOn {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            captureStackView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            captureExitButtonImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            captureDeleteButtonImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            captureChooseImageButtonImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            captureStickerContentView.backgroundColor = .white
            
            captureStackView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            captureStackView.layer.shadowOpacity = 1
            captureStackView.layer.shadowOffset = .zero
            captureStackView.layer.shadowRadius = 2
            captureStackView.layer.masksToBounds = false
            
            captureStickerContentView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            captureStickerContentView.layer.shadowOpacity = 1
            captureStickerContentView.layer.shadowOffset = .zero
            captureStickerContentView.layer.shadowRadius = 2
            captureStickerContentView.layer.masksToBounds = false
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            captureStackView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            captureExitButtonImageView.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            captureDeleteButtonImageView.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            captureChooseImageButtonImageView.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            captureStickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            
            captureStackView.layer.shadowColor = nil
            captureStackView.layer.shadowOpacity = 0
            captureStackView.layer.shadowOffset = .zero
            captureStackView.layer.shadowRadius = 0
            captureStackView.layer.masksToBounds = true
            
            captureStickerContentView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            captureStickerContentView.layer.shadowOpacity = 1
            captureStickerContentView.layer.shadowOffset = .zero
            captureStickerContentView.layer.shadowRadius = 2
            captureStickerContentView.layer.masksToBounds = false
        }
    }
    
    func showCustomAlert(withTitle title: String, withMessage message: String? = nil, usingErrorMessage: Bool? = nil, usingError error: Error? = nil) {
        var alert = UIAlertController()
        if usingErrorMessage != nil {
            if usingErrorMessage! {
                alert = UIAlertController(title: title, message: error!.localizedDescription, preferredStyle: .alert)
            }
        } else {
            alert = UIAlertController(title: title, message: message!, preferredStyle: .alert)
        }
        let action = UIAlertAction(title: Strings.captureAlertAction, style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showCaptureVCTutorial() {
        if isPresentedWithTabBar() {
            setQuickOptionsDesignWithTabBar()
            captureDeleteButtonImageView.isHidden = true
            captureTutorialContentView.isHidden = false
        } else {
            captureVisualEffectView.isHidden = false
        }
    }
    
    func showCaptureVCDefaultDesign() {
        if isPresentedWithTabBar() {
            setQuickOptionsDesignWithTabBar()
            captureDeleteButtonImageView.isHidden = false
            captureTutorialContentView.isHidden = true
        } else {
            setPlaneDetection()
            setQuickOptionsDesignWithoutTabBar()
            getStickerInformation()
        }
    }
    
    func hideCaptureVCTutorial() {
        captureTutorialContentView.isHidden = true
        captureTutorial3Label.isHidden = true
    }
    
    func getStickerInformation() {
        if featuredStickerViewModel != nil {
            setStickerInformation(stickerImage: featuredStickerViewModel!.image, stickerName: featuredStickerViewModel!.name)
        }
        if stickerViewModel != nil {
            setStickerInformation(stickerImage: stickerViewModel!.image, stickerName: stickerViewModel!.name)
        }
        if lovedStickerViewModel != nil {
            setStickerInformation(stickerImage: lovedStickerViewModel!.image, stickerName: lovedStickerViewModel!.name)
        }
    }
    
    func downloadImage(using stickerImage: String) {
        guard let url = URL(string: stickerImage) else {return}
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { [self] (data, response, error) in
            guard let error = error else {
                guard let imageData = data else {return}
                stickerMaterial.diffuse.contents = UIImage(data: imageData)
                return
            }
            showCustomAlert(withTitle: Strings.captureAlertErrorTitle, usingErrorMessage: true, usingError: error)
        }
        dataTask.resume()
    }
    
    func setStickerInformation(stickerImage: String, stickerName: String) {
        captureStickerContentView.isHidden = false
        captureStickerImageView.kf.setImage(with: URL(string: stickerImage))
        captureStickerNameLabel.text = stickerName
    }
    
    func setQuickOptionsDesignWithTabBar() {
        captureStackView.isHidden = false
        captureExitButtonImageView.isHidden = true
    }
    
    func setQuickOptionsDesignWithoutTabBar() {
        captureStackView.isHidden = false
        captureStickerContentView.isHidden = false
        captureExitButtonImageView.isHidden = false
        captureChooseImageButtonImageView.isHidden = true
    }
    
    func setPlaneDetection() {
        trackingConfiguration.planeDetection = [.horizontal, .vertical]
        captureSceneView.session.run(trackingConfiguration)
    }
    
    func setNoPlaneDetection() {
        trackingConfiguration.planeDetection = []
        captureSceneView.session.run(trackingConfiguration)
    }
    
    func isPresentedWithTabBar() -> Bool {
        if self.tabBarController?.isBeingPresented == nil {
            return false
        } else {
            return true
        }
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapExitButton = UITapGestureRecognizer(target: self, action: #selector(tapExitButtonGestureHandler))
        let tapDeleteButton = UITapGestureRecognizer(target: self, action: #selector(tapDeleteButtonGestureHandler))
        let tapChooseImageButton = UITapGestureRecognizer(target: self, action: #selector(tapChooseImageButtonGestureHandler))
        let tapStickerName = UITapGestureRecognizer(target: self, action: #selector(tapStickerNameGestureHandler))
        let tapSticker = UITapGestureRecognizer(target: self, action: #selector(tapStickerGestureHandler(tapGesture:)))
        let longPressSticker = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressStickerGestureHandler(longPressGesture:)))
        let pinchSticker = UIPinchGestureRecognizer(target: self, action: #selector(Self.pinchStickerGestureHandler(pinchGesture:)))
        let rotateSticker = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateStickerGestureHandler(rotateGesture:)))
        captureExitButtonImageView.addGestureRecognizer(tapExitButton)
        captureDeleteButtonImageView.addGestureRecognizer(tapDeleteButton)
        captureChooseImageButtonImageView.addGestureRecognizer(tapChooseImageButton)
        captureStickerContentView.addGestureRecognizer(tapStickerName)
        captureSceneView.addGestureRecognizer(tapSticker)
        captureSceneView.addGestureRecognizer(longPressSticker)
        captureSceneView.addGestureRecognizer(pinchSticker)
        captureSceneView.addGestureRecognizer(rotateSticker)
        captureExitButtonImageView.isUserInteractionEnabled = true
        captureDeleteButtonImageView.isUserInteractionEnabled = true
        captureChooseImageButtonImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapExitButtonGestureHandler() {
        dismiss(animated: true)
    }
    
    @objc func tapDeleteButtonGestureHandler() {
        if !stickerNodes.isEmpty {
            stickerNodes.removeLast().removeFromParentNode()
        }
        if !planeNodes.isEmpty {
            for everyGrid in planeNodes {
                everyGrid.runAction(SCNAction.fadeIn(duration: 0.2))
            }
        }
    }
    
    @objc func tapChooseImageButtonGestureHandler() {
        present(imagePicker, animated: true)
    }
    
    @objc func tapStickerNameGestureHandler() {
        Utilities.animate(view: captureStickerContentView)
        stickerMaterial.diffuse.contents = UIImage(named: Strings.defaultStickerImage)
        isStickerPicked = true
        hideCaptureVCTutorial()
    }
    
    @objc func tapStickerGestureHandler(tapGesture: UITapGestureRecognizer) {
        if isStickerPicked {
            guard let ARSCNView = tapGesture.view as? ARSCNView else {return}
            let tapLocation = tapGesture.location(in: ARSCNView)
            guard let raycastResult = capture.performRaycast(on: ARSCNView, tapLocation) else {
                showCustomAlert(withTitle: Strings.captureAlertErrorTitle, withMessage: Strings.captureAlertRaycastErrorMessage)
                return
            }
            raycastTargetAlignment = raycastResult.targetAlignment
            createStickerNode(using: raycastResult)
            return
        }
        showCustomAlert(withTitle: Strings.captureAlertErrorTitle, withMessage: Strings.captureAlertNoStickerErrorMessage)
    }
    
    @objc func longPressStickerGestureHandler(longPressGesture: UILongPressGestureRecognizer) {
        guard let ARSCNView = longPressGesture.view as? ARSCNView else {return}
        let longPressLocation = longPressGesture.location(in: ARSCNView)
        let pointSelectedInScreen = capture.performHitTest(using: longPressLocation, from: ARSCNView)
        guard let selectedNode = capture.getSelectedNode(using: pointSelectedInScreen) else {return}
        capture.performLongPressGesture(using: longPressGesture, from: ARSCNView, on: selectedNode)
    }
    
    @objc func pinchStickerGestureHandler(pinchGesture: UIPinchGestureRecognizer) {
        guard let ARSCNView = pinchGesture.view as? ARSCNView else {return}
        let pinchLocation = pinchGesture.location(in: ARSCNView)
        let pointSelectedInScreen = capture.performHitTest(using: pinchLocation, from: ARSCNView)
        guard let selectedNode = capture.getSelectedNode(using: pointSelectedInScreen) else {return}
        capture.performPinchGesture(using: pinchGesture, on: selectedNode)
    }
    
    @objc func rotateStickerGestureHandler(rotateGesture: UIRotationGestureRecognizer) {
        guard let ARSCNView = rotateGesture.view as? ARSCNView else {return}
        let rotateLocation = rotateGesture.location(in: ARSCNView)
        let pointSelectedInScreen = capture.performHitTest(using: rotateLocation, from: ARSCNView)
        guard let selectedNode = capture.getSelectedNode(using: pointSelectedInScreen) else {return}
        capture.performRotationGesture(using: rotateGesture, on: selectedNode, raycastTargetAlignment: raycastTargetAlignment!)
    }
    
    
    //MARK: - Buttons
    
    @IBAction func captureDontShowAgainButton(_ sender: UIButton) {
        captureVisualEffectView.isHidden = true
        setPlaneDetection()
        if isPresentedFromLandingVC {
            setQuickOptionsDesignWithoutTabBar()
            captureChooseImageButtonImageView.isHidden = false
            captureTutorialContentView.isHidden = false
            captureTutorialContentViewTopConstraint.constant = 128
            return
        }
        if isPresentedWithTabBar() {
            appDelegate.setValue(forKey: Strings.firstTimeLaunchFromCBKey, value: true, forCaptureButton: true)
            setQuickOptionsDesignWithTabBar()
            captureDeleteButtonImageView.isHidden = false
        } else {
            appDelegate.setValue(forKey: Strings.firstTimeLaunchFromTMBKey, value: true, forTryMeButton: true)
            setQuickOptionsDesignWithoutTabBar()
            getStickerInformation()
        }
    }
    
    
    //MARK: - Data Source And Delegate
    
    func setDataSourceAndDelegate() {
        captureSceneView.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    
    //MARK: - SCNode Process
    
    func createPlaneNode(using anchor: ARAnchor) -> SCNNode? {
        guard let planeAnchor = capture.createPlaneAnchor(using: anchor) else {
            showCustomAlert(withTitle: Strings.captureAlertErrorTitle, withMessage: Strings.captureAlertAnchorErrorMessage)
            return nil
        }
        let planeMaterials = SCNMaterial()
        planeMaterials.diffuse.contents = UIColor(white: 1, alpha: 0.5)
        let planeNode = capture.createNode(using: planeAnchor,
                                           material: planeMaterials,
                                           position: SCNVector3(CGFloat(planeAnchor.center.x),
                                                                CGFloat(planeAnchor.center.y),
                                                                CGFloat(planeAnchor.center.z)))
        planeNodes.append(planeNode)
        return planeNode
    }
    
    func createStickerNode(using raycastResult: ARRaycastResult) {
        if stickerNodes.count == 0 {
            guard let raycastResultTransform = raycastResult.anchor?.transform else {return}
            let stickerNode = capture.createNode(width: 0.1,
                                                 height: 0.1,
                                                 material: stickerMaterial,
                                                 transform: SCNMatrix4(raycastResultTransform),
                                                 position: SCNVector3(raycastResult.worldTransform.columns.3.x,
                                                                      raycastResult.worldTransform.columns.3.y,
                                                                      raycastResult.worldTransform.columns.3.z))
            captureSceneView.scene.rootNode.addChildNode(stickerNode)
            stickerNodes.append(stickerNode)
            fadePlaneNode()
        } else {
            showCustomAlert(withTitle: Strings.captureAlertWarningTitle, withMessage: Strings.captureAlertExcessStickerErrorMessage)
        }
    }
    
    func fadePlaneNode() {
        for planeNode in planeNodes {
            planeNode.runAction(SCNAction.fadeOut(duration: 0.2))
        }
    }
    
    func removePlaneNode() {
        for planeNode in planeNodes {
            planeNode.removeFromParentNode()
        }
    }
    
}


//MARK: - Image Picker & Navigation Delegate

extension CaptureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        stickerMaterial.diffuse.contents = imagePicked
        isStickerPicked = true
        imagePicker.dismiss(animated: true)
        captureTutorialContentView.isHidden = true
        if !isPresentedFromLandingVC {
            captureVisualEffectView.isHidden = false
        }
    }
    
}


//MARK: - ARSCN View Delegate

extension CaptureViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeNode = createPlaneNode(using: anchor) else {return}
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if stickerNodes.isEmpty {
            removePlaneNode()
            guard let planeNode = createPlaneNode(using: anchor) else {return}
            node.addChildNode(planeNode)
        }
    }
    
}


