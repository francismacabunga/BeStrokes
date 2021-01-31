//
//  CaptureViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 9/21/20.
//

import UIKit
import SceneKit
import ARKit

class CaptureViewController: UIViewController, ARSCNViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    let imagePicker = UIImagePickerController()
    let material = SCNMaterial()
    var numberOfNodes: [SCNNode] = []
    var lastRotation: CGFloat?
    var originalRotation = CGFloat()
    var gridArray = [SCNNode]()
    var raycastResult: ARRaycastResult? = nil
    var selectedNode: SCNNode? = nil
    
    //MARK: - View Controller Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        sceneView.showsStatistics = true
        registerGestureRecognizers()
        //sceneView.autoenablesDefaultLighting = true
        //sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - Capture UI
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            material.diffuse.contents = imagePicked}
        imagePicker.dismiss(animated: true)
    }
    
    @IBAction func buttonPress(_ sender: Any) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        if !numberOfNodes.isEmpty {
            numberOfNodes.removeLast().removeFromParentNode()
        }
        
        if !gridArray.isEmpty {
            for everyGrid in gridArray {
                everyGrid.runAction(SCNAction.fadeIn(duration: 0.2))
            }
        }
    }
    
    //MARK: - Gesture Handlers
    
    func registerGestureRecognizers(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler))
        sceneView.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureHandler(longPress:)))
        sceneView.addGestureRecognizer(longPress)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(Self.pinchGestureHandler(pinch:)))
        sceneView.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateGestureHandler(rotate:)))
        sceneView.addGestureRecognizer(rotate)
    }
    
    @objc func tapGestureHandler(tap: UITapGestureRecognizer) {
        guard let view = tap.view as? ARSCNView else {return}
        let tapLocation = tap.location(in: view)
        
        guard let raycastQuery = view.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .any) else {return}
        
        raycastResult = view.session.raycast(raycastQuery).first
        
        // raycastResult = view.session.raycast(raycastQuery).first else {return}
        
        if raycastResult != nil {
            createImageNode(using: raycastResult!)
        }
        
        
        
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
        let pointSelectedInScreen = sceneView.hitTest(longPressLocation, options: nil)
        guard let selectedNode = pointSelectedInScreen.first?.node else {return}
        if longPress.state == .changed {
            guard let raycastQuery = sceneView.raycastQuery(from: longPressLocation, allowing: .existingPlaneGeometry, alignment: .any) else {return}
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
        let pointSelectedInScreen = sceneView.hitTest(pinchLocation, options: nil)
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
        let pointSelectedInScreen = sceneView.hitTest(rotateLocation, options: nil)
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
    
    
    
    
    //MARK: - Rendering Methods
    
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
            sceneView.scene.rootNode.addChildNode(imageNode)
            numberOfNodes.append(imageNode)
            fadeBackgroundPlane()
        } else {
            showWarning()
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
    
    func showWarning() {
        let alert = UIAlertController(title: "Warning", message: "Already added a design. Only 1 image allowed!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
