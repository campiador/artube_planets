//
//  ViewController.swift
//  Planets
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    /* Apple Coordinate System:
     -red: x-coord (horizontal axis)
     -green: y-coord (vertical axis)
     -blue: z-coord (depth - how far or how close to us)
     */
    
    //https://stackoverflow.com/questions/45134068/how-can-i-move-a-node-in-arscnview-with-a-pan-gesture-recognizer
    
    let configuration = ARWorldTrackingConfiguration()
    let offsetY: Float = 0.3     //green axis
    let offsetZ: Float = -1.0    //blue axis (depth relative to our view)
    
    @IBOutlet weak var sceneView: ARSCNView!

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints] //Uncomment to show green/blue/red debug lines
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let options: [SCNHitTestOption: Any]? = nil //[SCNHitTestOption.firstFoundOnly: true]
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates, options: options)
        
        
        let contentLabel = UILabel()
        let frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        contentLabel.frame = frame
        contentLabel.font = UIFont.boldSystemFont(ofSize: 36)
        contentLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        contentLabel.textAlignment = NSTextAlignment.center
        contentLabel.numberOfLines = 0
        contentLabel.text = ""
        contentLabel.isHidden = false
        self.view.addSubview(contentLabel)
        
        //SCNHitTestIgnoreChildNodesKey
        if hitTest.isEmpty {
            print("empty")
            contentLabel.isHidden = true
        } else {
            print("tapped")
            let results = hitTest
            let name = results.first!.node.name
            if let name = name {
                //print("Name is:", name)
                contentLabel.text = "\(name)"
                contentLabel.isHidden = false
            }
        }
       
    }

    override func viewDidAppear(_ animated: Bool) {
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.name = "Sun"
        let earthParent = SCNNode()
        earthParent.name = "Earth"
        let venusParent = SCNNode()
        venusParent.name = "Venus"
        let moonParent = SCNNode()
        moonParent.name = "Moon"

        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun diffuse")
        sun.position = SCNVector3(0, 0 + offsetY, -1 + offsetZ)
        earthParent.position = SCNVector3(0, 0 + offsetY, -1 + offsetZ)
        venusParent.position = SCNVector3(0, 0 + offsetY, -1 + offsetZ)
        moonParent.position = SCNVector3(1.2, 0 + offsetY, 0 + offsetZ)
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)

        //Gesture recognizer:
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapgesture)
        
        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earth day"), specular: #imageLiteral(resourceName: "Earth Specular"), emission: #imageLiteral(resourceName: "Earth Emission"), normal: #imageLiteral(resourceName: "Earth Normal"), position: SCNVector3(1.2, 0, 0))
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "Venus Surface"), specular: nil, emission: #imageLiteral(resourceName: "Venus Atmosphere"), normal: nil, position: SCNVector3(0.7, 0, 0))
        let moon = planet(geometry: SCNSphere(radius: 0.05), diffuse: #imageLiteral(resourceName: "moon Diffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))

        let sunAction = rotation(time: 8)
        let earthParentRotation = rotation(time: 14)
        let venusParentRotation = rotation(time: 10)
        let earthRotation = rotation(time: 8)
        let moonRotation = rotation(time: 5)
        let venusRotation = rotation(time: 8)
        
        earth.runAction(earthRotation)
        venus.runAction(venusRotation)
        earthParent.runAction(earthParentRotation)
        venusParent.runAction(venusParentRotation)
        moonParent.runAction(moonRotation)

        sun.runAction(sunAction)
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venus)
        earth.addChildNode(moon)
        moonParent.addChildNode(moon)
    }
    
    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
    
    func rotation(time: TimeInterval) -> SCNAction {
        let Rotation = SCNAction.rotateBy(x: 0, y: 360.inRadians, z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(Rotation)
        return foreverRotation
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
    var inRadians: CGFloat { return CGFloat(self) * .pi/180}
}


