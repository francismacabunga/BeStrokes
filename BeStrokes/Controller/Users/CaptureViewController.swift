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

class CaptureViewController: UIViewController, ARSCNViewDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet var captureSceneView: ARSCNView!
    @IBOutlet weak var captureStackView: UIStackView!
    @IBOutlet weak var capture1SpacerView: UIView!
    @IBOutlet weak var capture2SpacerView: UIView!
    @IBOutlet weak var captureContentView: UIView!
    @IBOutlet weak var captureExitButtonImageView: UIImageView!
    @IBOutlet weak var captureDeleteButtonImageView: UIImageView!
    @IBOutlet weak var captureChooseImageButtonImageView: UIImageView!
    @IBOutlet weak var captureStickerImageView: UIImageView!
    @IBOutlet weak var capture1Label: UILabel!
    @IBOutlet weak var capture2Label: UILabel!
    
    
    //MARK: - Constants / Variables
    
    let imagePicker = UIImagePickerController()
    let material = SCNMaterial()
    var numberOfNodes: [SCNNode] = []
    var lastRotation: CGFloat?
    var originalRotation = CGFloat()
    var gridArray = [SCNNode]()
    var raycastResult: ARRaycastResult? = nil
    var selectedNode: SCNNode? = nil
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
        
       
        
        //captureSceneView.showsStatistics = true
        //sceneView.autoenablesDefaultLighting = true
        //sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        
        // Run the view's session
        captureSceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        captureSceneView.session.pause()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        captureExitButtonImageView.isHidden = true
        captureContentView.isHidden = true
        Utilities.setDesignOn(stackView: captureStackView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(view: captureContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(imageView: captureExitButtonImageView, image: UIImage(systemName: Strings.captureExitIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(imageView: captureDeleteButtonImageView, image: UIImage(systemName: Strings.captureDeleteIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(imageView: captureChooseImageButtonImageView, image: UIImage(systemName: Strings.captureChooseImageIcon), tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(label: capture1Label, font: Strings.defaultFont, fontSize: 12, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.capture1Label)
        Utilities.setDesignOn(label: capture2Label, font: Strings.defaultFontBold, fontSize: 20, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left)
        showStickerInformation()
        showExitButton()
    }
    
    func showStickerInformation() {
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
    
    func showExitButton() {
        if self.tabBarController?.isBeingPresented == nil {
            captureExitButtonImageView.isHidden = false
            captureChooseImageButtonImageView.isHidden = true
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
    
    func setStickerInformation(stickerImage: String, stickerName: String) {
        captureContentView.isHidden = false
        captureStickerImageView.kf.setImage(with: URL(string: stickerImage))
        capture2Label.text = stickerName
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapExitButton = UITapGestureRecognizer(target: self, action: #selector(tapExitButtonHandler))
        let tapDeleteButton = UITapGestureRecognizer(target: self, action: #selector(tapDeleteButtonHandler))
        let tapChooseImageButton = UITapGestureRecognizer(target: self, action: #selector(tapChooseImageButtonHandler))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureHandler(longPress:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(Self.pinchGestureHandler(pinch:)))
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateGestureHandler(rotate:)))
        captureExitButtonImageView.addGestureRecognizer(tapExitButton)
        captureDeleteButtonImageView.addGestureRecognizer(tapDeleteButton)
        captureChooseImageButtonImageView.addGestureRecognizer(tapChooseImageButton)
        captureExitButtonImageView.isUserInteractionEnabled = true
        captureDeleteButtonImageView.isUserInteractionEnabled = true
        captureChooseImageButtonImageView.isUserInteractionEnabled = true
        captureSceneView.addGestureRecognizer(tap)
        captureSceneView.addGestureRecognizer(longPress)
        captureSceneView.addGestureRecognizer(pinch)
        captureSceneView.addGestureRecognizer(rotate)
    }
    
    @objc func tapExitButtonHandler() {
        print("Exit button is tapped!")
        dismiss(animated: true)
    }
    
    @objc func tapDeleteButtonHandler() {
        print("Delete button is tapped!")
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
        print("Choose image button is tapped!")
        present(imagePicker, animated: true)
    }
    
    @objc func tapGestureHandler(tap: UITapGestureRecognizer) {
        guard let view = tap.view as? ARSCNView else {return}
        let tapLocation = tap.location(in: view)
        guard let raycastQuery = view.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .any) else {return}
        raycastResult = view.session.raycast(raycastQuery).first
        if raycastResult != nil {
            createImageNode(using: raycastResult!)
        }
        
        // This is already commmented before
        //        if raycastResult != nil {
        //            if raycastResult!.targetAlignment == .horizontal {
        //                createHorizontalNode(using: raycastResult!)
        //            } else if raycastResult?.targetAlignment == .vertical {
        //                createVerticalNode(using: raycastResult!)
        //            }
        //        } else {
        //            print("No raycast found")
        //        }
        
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
    
   
    //MARK: - Buttons
    
    
    
    
    
    func setDataSourceAndDelegate() {
        imagePicker.sourceType = .photoLibrary
        captureSceneView.delegate = self
        imagePicker.delegate = self
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
        imagePicker.dismiss(animated: true)
    }
    
}
