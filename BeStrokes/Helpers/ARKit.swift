//
//  ARKit.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/22/21.
//

import Foundation
import ARKit

struct ARKit {
    
    private var lastRotation: CGFloat?
    
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
    
    func performRaycast(on view: ARSCNView,
                        _ tapLocation: CGPoint) -> ARRaycastResult?
    {
        guard let raycastQuery = view.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .any) else {return nil}
        guard let raycastResult = view.session.raycast(raycastQuery).first else {return nil}
        return raycastResult
    }
    
    func performHitTest(using location: CGPoint,
                        from view: ARSCNView) -> [SCNHitTestResult]
    {
        let hitTest = view.hitTest(location, options: nil)
        return hitTest
    }
    
    func getSelectedNode(using hitTestResult: [SCNHitTestResult]) -> SCNNode? {
        guard let selectedNode = hitTestResult.first?.node else {return nil}
        return selectedNode
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
    
    func performPinchGesture(using pinchGesture: UIPinchGestureRecognizer,
                             on selectedNode: SCNNode)
    {
        if pinchGesture.state == .changed {
            selectedNode.scale = SCNVector3((pinchGesture.scale) * CGFloat(selectedNode.scale.x),
                                            (pinchGesture.scale) * CGFloat(selectedNode.scale.y),
                                            (pinchGesture.scale) * CGFloat(selectedNode.scale.z))
            pinchGesture.scale = 1
        }
    }
    
    mutating func performRotationGesture(using rotateGesture: UIRotationGestureRecognizer,
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
    
}
