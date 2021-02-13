//
//  CaptureViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 2/9/21.
//

import Foundation
import ARKit

struct Capture {
    
    func createARSCNView(using tap: UITapGestureRecognizer) -> ARSCNView? {
        guard let ARSCNView = tap.view as? ARSCNView else {return nil}
        return ARSCNView
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
                    position: SCNVector3) -> SCNNode {
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
    
    func getTapLocation(using tap: UITapGestureRecognizer, from view: ARSCNView) -> CGPoint {
        let tapLocation = tap.location(in: view)
        return tapLocation
    }
    
    func longPressLocation(using longPress: UILongPressGestureRecognizer) {
        
    }
    
    func performRaycast(on view: ARSCNView, _ tapLocation: CGPoint) -> ARRaycastResult? {
        guard let raycastQuery = view.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .any) else {return nil}
        guard let raycastResult = view.session.raycast(raycastQuery).first else {return nil}
        return raycastResult
    }
    
}
