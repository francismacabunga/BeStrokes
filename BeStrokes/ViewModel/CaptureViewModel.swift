//
//  CaptureViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 6/1/21.
//

import Foundation
import ARKit

class CaptureViewModel {
    
    private let networking = Networking()
    private let trackingConfiguration = ARWorldTrackingConfiguration()
    private var raycastTargetAlignment: ARRaycastQuery.TargetAlignment?
    private var lastRotation: CGFloat?
    private var planeNodes = [SCNNode]()
    private var stickerNodes = [SCNNode]()
    let stickerMaterial = SCNMaterial()
    var stickerIsPicked = false
    var presentedFromLandingPage = false
    
    
    //MARK: - User Defaults
    
    func setUserDefaultsKeysOnWillAppear() {
        if UserDefaults.standard.bool(forKey: Strings.homeTabKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.homePageKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.notificationTabKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.notificationPageKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.accountTabKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.accountPageKey)
        }
    }
    
    func setUserDefaultsKeysOnExitButton() {
        if UserDefaults.standard.bool(forKey: Strings.homeTabKey) {
            UserDefaults.standard.setValue(true, forKey: Strings.homePageKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.notificationTabKey) {
            UserDefaults.standard.setValue(true, forKey: Strings.notificationPageKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.accountTabKey) {
            UserDefaults.standard.setValue(true, forKey: Strings.accountPageKey)
        }
        UserDefaults.standard.setValue(false, forKey: Strings.capturePageKey)
    }
    
    
    //MARK: - UIGesture Handlers
    
    func tapToDeleteGesture() {
        if !stickerNodes.isEmpty {
            stickerNodes.removeLast().removeFromParentNode()
        }
        if !planeNodes.isEmpty {
            for everyGrid in planeNodes {
                everyGrid.runAction(SCNAction.fadeIn(duration: 0.2))
            }
        }
    }
    
    func tapStickerGesture(with tapGesture: UITapGestureRecognizer, completion: @escaping (Bool, Bool, String?, String?, String?) -> Void) {
        if !stickerIsPicked {
            completion(false, false, Strings.captureAlertNoStickerErrorMessage, nil, nil)
            return
        }
        guard let ARSCNView = tapGesture.view as? ARSCNView else {return}
        let tapLocation = tapGesture.location(in: ARSCNView)
        guard let raycastResult = performRaycast(on: ARSCNView, tapLocation) else {
            completion(true, false, nil, Strings.captureAlertRaycastErrorMessage, nil)
            return
        }
        raycastTargetAlignment = raycastResult.targetAlignment
        createStickerNode(using: raycastResult, on: ARSCNView) { (excessStickerErrorMessage) in
            completion(true, false, nil, nil, Strings.captureAlertExcessStickerErrorMessage)
        }
        completion(true, true, nil, nil, nil)
    }
    
    func longPressStickerGesture(with longPressGesture: UILongPressGestureRecognizer) {
        guard let ARSCNView = longPressGesture.view as? ARSCNView else {return}
        let longPressLocation = longPressGesture.location(in: ARSCNView)
        let pointSelectedInScreen = performHitTest(using: longPressLocation, from: ARSCNView)
        guard let selectedNode = getSelectedNode(using: pointSelectedInScreen) else {return}
        performLongPressGesture(using: longPressGesture, from: ARSCNView, on: selectedNode)
    }
    
    func pinchStickerGesture(with pinchGesture: UIPinchGestureRecognizer) {
        guard let ARSCNView = pinchGesture.view as? ARSCNView else {return}
        let pinchLocation = pinchGesture.location(in: ARSCNView)
        let pointSelectedInScreen = performHitTest(using: pinchLocation, from: ARSCNView)
        guard let selectedNode = getSelectedNode(using: pointSelectedInScreen) else {return}
        performPinchGesture(using: pinchGesture, on: selectedNode)
    }
    
    func rotateStickerGesture(with rotateGesture: UIRotationGestureRecognizer) {
        guard let ARSCNView = rotateGesture.view as? ARSCNView else {return}
        let rotateLocation = rotateGesture.location(in: ARSCNView)
        let pointSelectedInScreen = performHitTest(using: rotateLocation, from: ARSCNView)
        guard let selectedNode = getSelectedNode(using: pointSelectedInScreen) else {return}
        performRotationGesture(using: rotateGesture, on: selectedNode, raycastTargetAlignment: raycastTargetAlignment!)
    }
    
    func performLongPressGesture(using longPressGesture: UILongPressGestureRecognizer,
                                 from view: ARSCNView,
                                 on selectedNode: SCNNode)
    {
        let longPressLocation = longPressGesture.location(in: view)
        if longPressGesture.state == .changed {
            guard let raycastResult = performRaycast(on: view, longPressLocation) else {return}
            selectedNode.position = SCNVector3(raycastResult.worldTransform.columns.3.x,
                                               raycastResult.worldTransform.columns.3.y,
                                               raycastResult.worldTransform.columns.3.z)
        }
    }
    
    func performPinchGesture(using pinchGesture: UIPinchGestureRecognizer, on selectedNode: SCNNode) {
        if pinchGesture.state == .changed {
            selectedNode.scale = SCNVector3((pinchGesture.scale) * CGFloat(selectedNode.scale.x),
                                            (pinchGesture.scale) * CGFloat(selectedNode.scale.y),
                                            (pinchGesture.scale) * CGFloat(selectedNode.scale.z))
            pinchGesture.scale = 1
        }
    }
    
    func performRotationGesture(using rotateGesture: UIRotationGestureRecognizer,
                                on selectedNode: SCNNode,
                                raycastTargetAlignment: ARRaycastQuery.TargetAlignment)
    {
        let rotation = -rotateGesture.rotation
        switch rotateGesture.state {
        case .changed:
            if lastRotation != nil {
                if raycastTargetAlignment == .horizontal {
                    selectedNode.eulerAngles.y = Float(rotation) + Float(lastRotation!)
                } else {
                    selectedNode.eulerAngles.z = Float(rotation) + Float(lastRotation!)
                }
            }
        case.ended:
            if raycastTargetAlignment == .horizontal {
                lastRotation = CGFloat(selectedNode.eulerAngles.y)
            } else {
                lastRotation = CGFloat(selectedNode.eulerAngles.z)
            }
        default:
            break
        }
    }
    
    
    //MARK: - ARKit Related Functions
    
    func setPlaneDetection(on ARSCNView: ARSCNView) {
        trackingConfiguration.planeDetection = [.horizontal, .vertical]
        ARSCNView.session.run(trackingConfiguration)
    }
    
    func setNoPlaneDetection(on ARSCNView: ARSCNView) {
        trackingConfiguration.planeDetection = []
        ARSCNView.session.run(trackingConfiguration)
    }
    
    func createPlaneAnchor(using anchor: ARAnchor) -> ARPlaneAnchor? {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return nil}
        return planeAnchor
    }
    
    func createNode(using planeAnchor: ARPlaneAnchor? = nil,
                    width: CGFloat? = nil,
                    height: CGFloat? = nil,
                    material: SCNMaterial,
                    transform: SCNMatrix4? = nil,
                    position: SCNVector3) -> SCNNode
    {
        var plane = SCNPlane()
        if planeAnchor != nil {
            plane = SCNPlane(width: CGFloat(planeAnchor!.extent.x), height: CGFloat(planeAnchor!.extent.z))
        } else {
            plane = SCNPlane(width: width!, height: height!)
        }
        plane.materials = [material]
        let planeNode = SCNNode(geometry: plane)
        if transform != nil {
            planeNode.transform = transform!
        }
        planeNode.eulerAngles.x = planeNode.eulerAngles.x + (-Float.pi / 2)
        planeNode.position = position
        return planeNode
    }
    
    func createPlaneNode(using anchor: ARAnchor, completion: @escaping (String) -> Void) -> SCNNode? {
        guard let planeAnchor = createPlaneAnchor(using: anchor) else {
            completion(Strings.captureAlertAnchorErrorMessage)
            return nil
        }
        let planeMaterials = SCNMaterial()
        planeMaterials.diffuse.contents = UIColor(white: 1, alpha: 0.5)
        let planeNode = createNode(using: planeAnchor,
                                   material: planeMaterials,
                                   position: SCNVector3(CGFloat(planeAnchor.center.x),
                                                        CGFloat(planeAnchor.center.y),
                                                        CGFloat(planeAnchor.center.z)))
        planeNodes.append(planeNode)
        return planeNode
    }
    
    func createStickerNode(using raycastResult: ARRaycastResult,
                           on ARSCNView: ARSCNView,
                           completion: @escaping (String) -> Void)
    {
        if stickerNodes.count == 0 {
            guard let raycastResultTransform = raycastResult.anchor?.transform else {return}
            let stickerNode = createNode(width: 0.1,
                                         height: 0.1,
                                         material: stickerMaterial,
                                         transform: SCNMatrix4(raycastResultTransform),
                                         position: SCNVector3(raycastResult.worldTransform.columns.3.x,
                                                              raycastResult.worldTransform.columns.3.y,
                                                              raycastResult.worldTransform.columns.3.z))
            ARSCNView.scene.rootNode.addChildNode(stickerNode)
            stickerNodes.append(stickerNode)
            fadePlaneNode()
        } else {
            completion(Strings.captureAlertExcessStickerErrorMessage)
        }
    }
    
    func performRaycast(on view: ARSCNView, _ tapLocation: CGPoint) -> ARRaycastResult? {
        guard let raycastQuery = view.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .any) else {return nil}
        guard let raycastResult = view.session.raycast(raycastQuery).first else {return nil}
        return raycastResult
    }
    
    func performHitTest(using location: CGPoint, from view: ARSCNView) -> [SCNHitTestResult] {
        let hitTest = view.hitTest(location, options: nil)
        return hitTest
    }
    
    func getSelectedNode(using hitTestResult: [SCNHitTestResult]) -> SCNNode? {
        guard let selectedNode = hitTestResult.first?.node else {return nil}
        return selectedNode
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
    
    func reset(_ ARSCNView: ARSCNView) {
        ARSCNView.session.pause()
        setNoPlaneDetection(on: ARSCNView)
        stickerIsPicked = false
        if !stickerNodes.isEmpty {
            stickerNodes.removeLast().removeFromParentNode()
        }
        if !planeNodes.isEmpty {
            planeNodes.removeLast().removeFromParentNode()
        }
    }
    
    
    //MARK: - Fetching of Sticker
    
    func downloadStickerImage(using stickerURL: String, completion: @escaping (Error) -> Void) {
        networking.fetchData(using: stickerURL) { [weak self] (error, data) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                guard let error = error else {
                    guard let stickerData = data else {return}
                    self.stickerMaterial.diffuse.contents = UIImage(data: stickerData)
                    return
                }
                completion(error)
            }
        }
    }
    
    
    //MARK: - ARSCN View Delegate
    
    func didAddNode(with anchor: ARAnchor,
                    on node: SCNNode,
                    completion: @escaping (String) -> Void)
    {
        guard let planeNode = createPlaneNode(using: anchor, completion: { (anchorErrorMessage) in
            completion(anchorErrorMessage)
        }) else {return}
        node.addChildNode(planeNode)
    }
    
    func didUpdateNode(with anchor: ARAnchor,
                       on node: SCNNode,
                       completion: @escaping (String) -> Void)
    {
        if stickerNodes.isEmpty {
            removePlaneNode()
            guard let planeNode = createPlaneNode(using: anchor, completion: { (anchorErrorMessage) in
                completion(anchorErrorMessage)
            }) else {return}
            node.addChildNode(planeNode)
        }
    }
    
}
