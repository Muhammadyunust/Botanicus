//
//  BotanicusVC.swift
//  WhatFlower
//
//  Created by Mukhammadyunus on 2/7/20.
//  Copyright © 2020 Shakhzodbek Azizov. All rights reserved.
//


import UIKit
import SceneKit
import ARKit
import SpriteKit

class BotanicusVC: UIViewController, ARSCNViewDelegate {
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var isPaused = false
    var nodetoscale = SCNNode()
    var textNode = SCNNode()
    var videoNode = SKVideoNode()
    
    var videos: [String: SKVideoNode] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Botany Book Images", bundle: Bundle.main){
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 3
            print("Images succesfully finded")
        }
        
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    
    @IBAction func gestureUsed(_ sender: UIPinchGestureRecognizer) {
        scaleObject(gesture: sender)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    //MARK: - Touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentTouchLocation = touches.first?.location(in: sceneView){
            if let hitTestResultNode = sceneView.hitTest(currentTouchLocation, options: nil).last?.node {
                print(hitTestResultNode.name?.starts(with: "v"))
                if ((hitTestResultNode.name?.starts(with: "v"))!){
                    
                    for video in videos{
                        
                        if video.key == hitTestResultNode.name{
                            print("hi")
                            if isPaused{
                                print("ki")
                                video.value.play()
                            }else{
                                
                                video.value.pause()
                            }
                            isPaused = !isPaused
                        }
                    }
                    
                }else{
                    if hitTestResultNode.opacity >= 0.1 && hitTestResultNode.opacity < 1{
                        
                        let animation = CABasicAnimation(keyPath: "opacity")
                        animation.fromValue = 0.0
                        animation.toValue = 1.0
                        animation.duration = 0.5
                        //animation.autoreverses = true
                        //animation.repeatCount = .infinity
                        hitTestResultNode.addAnimation(animation, forKey: "opacity")
                        let moveUp = SCNAction.move(by: SCNVector3(0.0, 0.00, 0.0), duration: 1)
                        hitTestResultNode.runAction(moveUp)
                    hitTestResultNode.childNodes.first?.addAnimation(animation, forKey: "opacity")
                        hitTestResultNode.opacity = 1
                    }else{
                        
                        let animation = CABasicAnimation(keyPath: "opacity")
                        animation.fromValue = 1
                        animation.toValue = 0.1
                        animation.duration = 0.5
                        hitTestResultNode.addAnimation(animation, forKey: "opacity")
                       let moveDown = SCNAction.move(by: SCNVector3(0.0, 0.0, -0.01), duration: 1)
                        hitTestResultNode.runAction(moveDown)
                    hitTestResultNode.childNodes.first?.addAnimation(animation, forKey: "opacity")
                        hitTestResultNode.opacity = 0.1
                    }
                }
                
            }
        }
    }
    
    
    // MARK: - Rendering boxNodes
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            
            
            
            if (imageAnchor.referenceImage.name?.starts(with: "v"))!{
                
                var a = 0
                if (imageAnchor.referenceImage.name?.starts(with: "vL"))! {
                    a = 1
                }
                
                let videoNode = pasteVideo(imageAnchor: imageAnchor, imageName: imageAnchor.referenceImage.name!, a: a)
                
                let nameOfNode = videoNode[0] as? SCNNode
                nameOfNode?.name = imageAnchor.referenceImage.name
                
                videos[imageAnchor.referenceImage.name!] = videoNode[1] as? SKVideoNode
                
                node.addChildNode((videoNode[0] as? SCNNode)!)
                
                
            }else if imageAnchor.referenceImage.name == "Cell"{
                videoNode.pause()
                isPaused = true
                
                if let cellScene = SCNScene(named: "art.scnassets/plant-cell2.scn"){
                    if let cellNode = cellScene.rootNode.childNodes.first{
                        
                        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                        
                        plane.firstMaterial?.diffuse.contents = UIColor(displayP3Red: 63, green: 220, blue: 84, alpha: 0.1)
                        
                        let planeNode = SCNNode(geometry: plane)
                        
                        planeNode.eulerAngles.x = -Float.pi/2
                        
                        node.addChildNode(planeNode)
                        
                        planeNode.addChildNode(cellNode)
                        
                        cellNode.eulerAngles.x = .pi/2
                        
                        cellNode.position = SCNVector3(0.0, 0.02, 0.0)
                        cellNode.opacity = 0.0
                        let moveUp = SCNAction.move(to: SCNVector3(0.0, 0.02, 0.02), duration: 1)
                        let fadeIn = SCNAction.fadeOpacity(to: 1, duration: 1)
                        
                        cellNode.runAction(moveUp)
                        cellNode.runAction(fadeIn)
                        nodetoscale = cellNode
                        
                        print("success")
                    }
                }
            }else{
                
                videoNode.pause()
                isPaused = true
                
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                
                plane.firstMaterial?.diffuse.contents = UIColor(displayP3Red: 63, green: 220, blue: 84, alpha: 1)
                
                let planeNode = SCNNode(geometry: plane)
                
                planeNode.eulerAngles.x = -Float.pi/2
                
                node.addChildNode(planeNode)
                
                createBoxNode(refImageName: imageAnchor.referenceImage.name ?? "garmala", planeNode: planeNode, opacity: 0.1)
            }
        }
        
        
        
        
        
        
        
        
        return node
    }
    
    //MARK: Paste Video
    
    func pasteVideo(imageAnchor: ARImageAnchor, imageName: String, a: Int) -> [Any] {
        
        videoNode = SKVideoNode(fileNamed: "\(imageName).mp4")
        videoNode.play()
        
        var width = 0
        var height = 0
        
        if a == 0 {
            width = 1280
            height = 720
        } else {
            width = 480
            height = 360
        }
        
        let videoScene = SKScene(size: CGSize(width: width, height: height))
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        
        videoNode.yScale = -1.0
        videoScene.addChild(videoNode)
        var plane = SCNPlane()
        if a == 1{
            plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width , height: imageAnchor.referenceImage.physicalSize.height)
        }else{
            plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width + 0.05, height: imageAnchor.referenceImage.physicalSize.height)
        }
        
        plane.firstMaterial?.diffuse.contents = videoScene
        plane.cornerRadius = 0.005
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/3
        
        planeNode.position = SCNVector3(0.0, 0.0, -0.1)
        
        if a == 1 {
            planeNode.position = SCNVector3(0.0, 0.0, 0.0)
        }
        return [planeNode, videoNode]
    }
    
    
    
    //MARK: - Creating Box Node
    func createBoxNode(refImageName: String?, planeNode: SCNNode, opacity: CGFloat){
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.01, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemPurple
        let material2 = SCNMaterial()
        
        if let imageName = refImageName{
            let img = UIImageView(image: UIImage(named: "n\(imageName)"))
            img.contentMode = .scaleAspectFill
            material2.diffuse.contents = img
            box.materials = [material2, material, material, material, material, material]
            
            let boxNode = SCNNode(geometry: box)
            boxNode.position = SCNVector3(0.0, 0.0, 0.0)
            
            setTextToPlane(text: imageName, position: SCNVector3(boxNode.position.x, boxNode.position.y + 0.02, boxNode.position.z), planeNode: boxNode)
            boxNode.opacity = opacity
            boxNode.name = refImageName
            planeNode.addChildNode(boxNode)
            
        }
        
        
        
        
    }
    
    //MARK: - set text to Plane
    func setTextToPlane(text: String, position: SCNVector3, planeNode: SCNNode){
        
        
        let textGeometry = SCNText(string: text, extrusionDepth: 0.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x - 0.025, position.y + 0.01, position.z + 0.01)
        textNode.scale = SCNVector3(0.001, 0.001, 0.001)
        
        planeNode.addChildNode(textNode)
    }
    
    
    //MARK: - scale Object
    @objc func scaleObject(gesture: UIPinchGestureRecognizer) {
        
        guard let nodeToScale = nodetoscale as? SCNNode else { return }
        if gesture.state == .changed {
            
            let pinchScaleX: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.x))
            let pinchScaleY: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.y))
            let pinchScaleZ: CGFloat = gesture.scale * CGFloat((nodeToScale.scale.z))
            nodeToScale.scale = SCNVector3Make(Float(pinchScaleX), Float(pinchScaleY), Float(pinchScaleZ))
            gesture.scale = 1
            
        }
        if gesture.state == .ended { }
    }
    
    
}

