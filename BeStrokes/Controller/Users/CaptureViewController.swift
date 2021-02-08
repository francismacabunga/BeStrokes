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
    private let trackingConfiguration = ARWorldTrackingConfiguration()
    private let imagePicker = UIImagePickerController()
    private let material = SCNMaterial()
    
    
    private var numberOfNodes: [SCNNode] = []
    private var lastRotation: CGFloat?
    private var originalRotation = CGFloat()
    private var gridArray = [SCNNode]()
    private var raycastResult: ARRaycastResult? = nil
    private var selectedNode: SCNNode? = nil
    
    var isStickerPicked = false
    var isPresentedFromLandingVC = false
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
        Utilities.setDesignOn(stackView: captureStackView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true, isHidden: true)
        Utilities.setDesignOn(view: captureTutorialContentView, backgroundColor: .clear, isHidden: true)
        Utilities.setDesignOn(view: captureStickerContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, isHidden: true)
        Utilities.setDesignOn(imageView: captureTutorialImageView, image: UIImage(named: Strings.tutorialDialogueImage))
        Utilities.setDesignOn(imageView: captureStickerImageView, image: UIImage(named: "Elephant"))
        Utilities.setDesignOn(imageView: captureExitButtonImageView, image: UIImage(systemName: Strings.captureExitIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(imageView: captureDeleteButtonImageView, image: UIImage(systemName: Strings.captureDeleteIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(imageView: captureChooseImageButtonImageView, image: UIImage(systemName: Strings.captureChooseImageIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(label: captureTutorial1Label, font: Strings.defaultFontBold, fontSize: 12, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, text: Strings.captureTutorial1Label)
        Utilities.setDesignOn(label: captureTutorial2Label, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 0, textAlignment: .center, text: Strings.captureTutorial2Label)
        Utilities.setDesignOn(label: captureTutorial3Label, font: Strings.defaultFontBold, fontSize: 12, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: Strings.captureTutorial3Label, isHidden: true)
        Utilities.setDesignOn(label: captureStickerLabel, font: Strings.defaultFont, fontSize: 12, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.captureStickerLabel)
        Utilities.setDesignOn(label: captureStickerNameLabel, font: Strings.defaultFontBold, fontSize: 20, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "Elephant")
        Utilities.setDesignOn(button: captureDontShowAgainButton, title: Strings.dontShowAgainButtonText, font: Strings.defaultFontBold, fontSize: 16, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
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
            showStickerInformation()
        }
    }
    
    func showStickerInformation() {
        if featuredStickerViewModel != nil {
            setStickerInformationDesign(stickerImage: featuredStickerViewModel!.image, stickerName: featuredStickerViewModel!.name)
        }
        if stickerViewModel != nil {
            setStickerInformationDesign(stickerImage: stickerViewModel!.image, stickerName: stickerViewModel!.name)
        }
        if lovedStickerViewModel != nil {
            setStickerInformationDesign(stickerImage: lovedStickerViewModel!.image, stickerName: lovedStickerViewModel!.name)
        }
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
    
    func setStickerInformationDesign(stickerImage: String, stickerName: String) {
        captureStickerContentView.isHidden = false
        captureStickerImageView.kf.setImage(with: URL(string: stickerImage))
        captureStickerNameLabel.text = stickerName
    }
    
    func setPlaneDetection() {
        trackingConfiguration.planeDetection = [.horizontal,.vertical]
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
    
    func downloadImage(using stickerImage: String) {
        guard let url = URL(string: stickerImage) else {return}
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { [self] (data, response, error) in
            guard let error = error else {
                guard let imageData = data else {return}
                material.diffuse.contents = UIImage(data: imageData)
                return
            }
            showCustomAlert(withTitle: Strings.captureAlert1Title, usingErrorMessage: true, usingError: error)
        }
        dataTask.resume()
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapExitButton = UITapGestureRecognizer(target: self, action: #selector(tapExitButtonHandler))
        let tapDeleteButton = UITapGestureRecognizer(target: self, action: #selector(tapDeleteButtonHandler))
        let tapChooseImageButton = UITapGestureRecognizer(target: self, action: #selector(tapChooseImageButtonHandler))
        let tapStickerName = UITapGestureRecognizer(target: self, action: #selector(tapStickerNameHandler))
        let tapSticker = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler))
        let longPressSticker = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureHandler(longPress:)))
        let pinchSticker = UIPinchGestureRecognizer(target: self, action: #selector(Self.pinchGestureHandler(pinch:)))
        let rotateSticker = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateGestureHandler(rotate:)))
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
    
    @objc func tapExitButtonHandler() {
        dismiss(animated: true)
    }
    
    @objc func tapDeleteButtonHandler() {
        if !numberOfNodes.isEmpty {
            numberOfNodes.removeLast().removeFromParentNode()
        }
        if !gridArray.isEmpty {
            for everyGrid in gridArray {
                everyGrid.runAction(SCNAction.fadeIn(duration: 0.2))
            }
        }
    }
    
    @objc func tapChooseImageButtonHandler() {
        present(imagePicker, animated: true)
    }
    
    @objc func tapStickerNameHandler() {
        print("Hey i'm tapped")
        material.diffuse.contents = UIImage(named: "Elephant")
        isStickerPicked = true
        captureTutorialContentView.isHidden = true
        captureTutorial3Label.isHidden = true
        
//        captureStickerContentView.backgroundColor = .red
        
        
        UIView.animate(withDuration: 0.2) { [self] in
            captureStickerContentView.alpha = 0.4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2) { [self] in
                captureStickerContentView.alpha = 1
            }
        }
        
        
    }
    
    @objc func tapGestureHandler(tap: UITapGestureRecognizer) {
        if isStickerPicked {
            guard let view = tap.view as? ARSCNView else {return}
            let tapLocation = tap.location(in: view)
            guard let raycastQuery = view.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .any) else {return}
            raycastResult = view.session.raycast(raycastQuery).first
            if raycastResult != nil {
                createImageNode(using: raycastResult!)
            }
            return
        }
        showCustomAlert(withTitle: Strings.captureAlert1Title, withMessage: "Pili ka muna!")
    }
    
    @objc func longPressGestureHandler(longPress: UILongPressGestureRecognizer) {
        guard let view = longPress.view as? ARSCNView else {return}
        let longPressLocation = longPress.location(in: view)
        let pointSelectedInScreen = captureSceneView.hitTest(longPressLocation, options: nil)
        guard let selectedNode = pointSelectedInScreen.first?.node else {return}
        if longPress.state == .changed {
            guard let raycastQuery = captureSceneView.raycastQuery(from: longPressLocation, allowing: .existingPlaneGeometry, alignment: .any) else {return}
            guard let raycastResult = view.session.raycast(raycastQuery).first else {return}
            selectedNode.position = SCNVector3(
                raycastResult.worldTransform.columns.3.x,
                raycastResult.worldTransform.columns.3.y,
                raycastResult.worldTransform.columns.3.z)
        }
    }
    
    @objc func pinchGestureHandler(pinch: UIPinchGestureRecognizer) {
        guard let view = pinch.view as? ARSCNView else {return}
        let pinchLocation = pinch.location(in: view)
        let pointSelectedInScreen = captureSceneView.hitTest(pinchLocation, options: nil)
        guard let selectedNode = pointSelectedInScreen.first?.node else {return}
        if pinch.state == .changed {
            selectedNode.scale = SCNVector3Make(
                Float(pinch.scale) * selectedNode.scale.x,
                Float(pinch.scale) * selectedNode.scale.y,
                Float(pinch.scale) * selectedNode.scale.z)
            pinch.scale = 1
        }
    }
    
    @objc func rotateGestureHandler(rotate: UIRotationGestureRecognizer) {
        guard let view = rotate.view as? ARSCNView else {return}
        let rotateLocation = rotate.location(in: view)
        let pointSelectedInScreen = captureSceneView.hitTest(rotateLocation, options: nil)
        selectedNode = pointSelectedInScreen.first?.node
        let rotationGesture = -rotate.rotation
        if selectedNode != nil {
            switch rotate.state {
            case .changed:
                rotatePosition(using: rotationGesture)
            case .ended:
                endRotatePosition()
            default:
                break
            }
        }
    }
    
    
    //MARK: - buttons
    
    
    func setDataSourceAndDelegate() {
        imagePicker.sourceType = .photoLibrary
        captureSceneView.delegate = self
        imagePicker.delegate = self
    }
    
    
    
    
    
    
    
    
    
    
   
    
    
    @IBAction func captureDontShowAgainButton(_ sender: UIButton) {
        
        captureVisualEffectView.isHidden = true
        setPlaneDetection()
        
        
        
        
        
        if isPresentedWithTabBar() {
            appDelegate.setOpenedFromCaptureButton()
            setQuickOptionsDesignWithTabBar()
            captureDeleteButtonImageView.isHidden = false
        } else {
            appDelegate.setOpenedFromTryMeButtonValue()
            setQuickOptionsDesignWithoutTabBar()
            showStickerInformation()
            
            
            if isPresentedFromLandingVC {
                captureChooseImageButtonImageView.isHidden = false
                captureTutorialContentView.isHidden = false
                
                
                captureTutorialContentViewTopConstraint.constant = 128
                
            }
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    //MARK: - Rendering Methods
    
    
    
    
    func rotatePosition(using rotation: CGFloat) {
        if lastRotation != nil {
            if raycastResult?.targetAlignment == .horizontal {
                selectedNode!.eulerAngles.y = Float(rotation) + Float(lastRotation!)
            } else if raycastResult?.targetAlignment == .vertical  {
                selectedNode!.eulerAngles.z = Float(rotation) + Float(lastRotation!)
            }
        }
    }
    
    func endRotatePosition() {
        if raycastResult?.targetAlignment == .horizontal {
            lastRotation = CGFloat(selectedNode!.eulerAngles.y)
        } else if raycastResult?.targetAlignment == .vertical {
            lastRotation = CGFloat(selectedNode!.eulerAngles.z)
        }
    }
    
    
    
    
    
    //MARK: - CRUD Methods
    
    func createBackgroundPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.firstMaterial?.diffuse.contents = UIColor.init(white: 1, alpha: 0.6)
        planeNode.position = SCNVector3(
            CGFloat(planeAnchor.center.x),
            CGFloat(planeAnchor.center.y),
            CGFloat(planeAnchor.center.z))
        planeNode.eulerAngles.x = -.pi / 2
        gridArray.append(planeNode)
        return planeNode
    }
    
    func createImageNode(using raycastResult: ARRaycastResult) {
        guard let planeAnchor = raycastResult.anchor as? ARPlaneAnchor else {return}
        if numberOfNodes.count == 0 {
            let imageNode = createImageNode(with: raycastResult)
            captureSceneView.scene.rootNode.addChildNode(imageNode)
            numberOfNodes.append(imageNode)
            fadeBackgroundPlane()
        } else {
            showCustomAlert(withTitle: Strings.captureAlert2Title, withMessage: Strings.captureAlertMessage)
        }
    }
    
    //    func createVerticalNode(using raycastResult: ARRaycastResult) {
    //        guard let planeAnchor = raycastResult.anchor as? ARPlaneAnchor else {return}
    //        if numberOfNodes.count == 0 {
    //            let imageNode = createImageNode(with: raycastResult)
    //            sceneView.scene.rootNode.addChildNode(imageNode)
    //            numberOfNodes.append(imageNode)
    //            fadeBackgroundPlane()
    //        } else {
    //            showWarning()
    //        }
    //    }
    
    func createImageNode(with raycastResult: ARRaycastResult) -> SCNNode {
        let image = SCNPlane(width: 0.1, height: 0.1)
        image.materials = [material]
        let imageNode = SCNNode(geometry: image)
        imageNode.transform = SCNMatrix4(raycastResult.anchor!.transform)
        imageNode.eulerAngles = SCNVector3Make(imageNode.eulerAngles.x + (-Float.pi / 2),
                                               imageNode.eulerAngles.y,
                                               imageNode.eulerAngles.z)
        imageNode.position = SCNVector3(
            raycastResult.worldTransform.columns.3.x,
            raycastResult.worldTransform.columns.3.y,
            raycastResult.worldTransform.columns.3.z)
        return imageNode
    }
    
    
    
    func removeNode() {
        for everyGrid in gridArray {
            everyGrid.removeFromParentNode()
        }
    }
    
    func fadeBackgroundPlane() {
        for everyGrid in gridArray {
            everyGrid.runAction(SCNAction.fadeOut(duration: 0.2))
        }
    }
    
    
    
}


//MARK: - Image Picker & Navigation Delegate

extension CaptureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        material.diffuse.contents = imagePicked
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
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let gridNode = createBackgroundPlane(with: planeAnchor)
        node.addChildNode(gridNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        if numberOfNodes.isEmpty {
            removeNode()
            let gridNode = createBackgroundPlane(with: planeAnchor)
            node.addChildNode(gridNode)
        }
    }
    
}


