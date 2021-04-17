import SpriteKit
import UIKit


public class ViewScene: SKScene {
    
    
    //MARK:  - Nodes and Components UI
    private let table = SKSpriteNode(imageNamed: "table")
    private let startButton = SKSpriteNode(imageNamed: "start_button")
    private let ground = SKSpriteNode(imageNamed: "ground")
    private var ritcherScaleDescription = SKSpriteNode(imageNamed: "ritcher_scale1")
    private let ritcherScaleLabel = SKLabelNode(text: "Ritcher Scale: 0")
    private let background = SKSpriteNode(imageNamed: "background")
    private let macbook1 = SKSpriteNode(imageNamed: "macbook")
    private let macbook2 = SKSpriteNode(imageNamed: "macbook2")
    private let homepod = SKSpriteNode(imageNamed: "homepod")
    private let books = SKSpriteNode(imageNamed: "books")
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .black
        slider.maximumTrackTintColor = .gray
        slider.setThumbImage(UIImage(named: "thumb_image")!, for: .normal)
        return slider
    }()
    
    
    // MARK: - Earthquake functionality properties
    private var prevScoreCalcTime: TimeInterval = 0 // keep track time to shake or simulate velocity in ground
    private let distanceConstant: Double = 5 // variable distance from the center of earthquake, for this purpose let set to 5km, the old one is 100km but the new one need to calculate the delta
    private var isNegativeVelocity: Bool = true
    private var isSimulateEarthquake = false {
        didSet{
            if !isSimulateEarthquake {
                physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)))
                startButton.texture = SKTexture(imageNamed: "start_button")
            } else {
                startButton.texture = SKTexture(imageNamed: "stop_button")
            }
        }
    }
    private var magnitude: Float = 0 {
        didSet{
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            let formattedAmount = formatter.string(from: magnitude as NSNumber)!
            ritcherScaleLabel.text = "Ritcher Scale: \(formattedAmount)"
        }
    }
 
    
    
    // MARK: - lifecycle SKScene
    
    public override func didMove(to view: SKView) {
        
        //create backgorund
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 0.7
        background.zPosition = -1
        addChild(background)
        
        //create ground
        ground.position = CGPoint(x: view.frame.midX, y: view.frame.midY - 100)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.frame.width, height: ground.frame.height - 15))
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.restitution = 0
        ground.physicsBody?.friction = 1.0
        ground.physicsBody?.mass = 500
        addChild(ground)
        
        //create table
        table.position = CGPoint(x: view.frame.midX, y: view.frame.midY - (table.frame.height / 2))
        table.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: table.frame.width, height: table.frame.height - 15))
        table.physicsBody?.allowsRotation = false
        table.physicsBody?.restitution = .zero
        table.physicsBody?.friction = 1.0
        table.physicsBody?.mass = 45
        addChild(table)
        
        // setup start button
        startButton.name = "start_button"
        startButton.position = CGPoint(x: view.frame.midX, y: 20)
        startButton.zPosition = 100
        addChild(startButton)
        
        // add slider
        slider.frame = CGRect(x: startButton.position.x - ((view.frame.width / 2) / 2), y: view.frame.height - startButton.frame.height - 30, width: view.frame.width / 2, height: 20)
        slider.addTarget(self, action: #selector(handleSlider(_:)), for: .valueChanged)
        view.addSubview(slider)
        
        // add title Slider
        ritcherScaleLabel.position = CGPoint(x: view.frame.midX, y:  view.frame.height - 20)
        ritcherScaleLabel.fontSize = 17
        ritcherScaleLabel.fontName = "super-bold"
        ritcherScaleLabel.fontColor = .black
        addChild(ritcherScaleLabel)
        
        //add ritcher scale description
        ritcherScaleDescription.position = CGPoint(x: view.frame.midX, y:  view.frame.height - ritcherScaleDescription.frame.height / 2)
        addChild(ritcherScaleDescription)
     
        //create firstlaptop
        macbook1.position = CGPoint(x: table.frame.minX + (macbook1.frame.width / 2), y: 400)
        macbook1.physicsBody = SKPhysicsBody(rectangleOf: macbook1.frame.size)
        macbook1.physicsBody?.allowsRotation = false
        macbook1.physicsBody?.restitution = .zero
        macbook1.physicsBody?.friction = 0.2
        macbook1.physicsBody?.mass = 1
        addChild(macbook1)
        
        
        //create secondLaptop
        macbook2.position = CGPoint(x: table.frame.maxX - (macbook2.frame.width / 2), y: 400)
        macbook2.physicsBody = SKPhysicsBody(rectangleOf: macbook2.frame.size)
        macbook2.physicsBody?.allowsRotation = false
        macbook2.physicsBody?.restitution = .zero
        macbook2.physicsBody?.friction = 0.2
        macbook2.physicsBody?.mass = 1
        addChild(macbook2)
        
        //create homepod
        homepod.position = CGPoint(x: table.frame.midX - (homepod.frame.width / 2), y: 400)
        homepod.physicsBody = SKPhysicsBody(rectangleOf: homepod.frame.size)
        homepod.physicsBody?.allowsRotation = false
        homepod.physicsBody?.restitution = .zero
        homepod.physicsBody?.friction = 0.4
        homepod.physicsBody?.mass = 2.5
        addChild(homepod)
        
        //create boooks
        books.position = CGPoint(x: table.frame.midX + (books.frame.width / 2), y: 400)
        books.physicsBody = SKPhysicsBody(rectangleOf: books.frame.size)
        books.physicsBody?.allowsRotation = false
        books.physicsBody?.restitution = .zero
        books.physicsBody?.friction = 0.2
        books.physicsBody?.mass = 2.4 // average weight of thick book (700 sheets) is 0.8 kg or 1 pound, 15 ounces
        addChild(books)
        
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)))
        
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if isSimulateEarthquake {
            if currentTime - prevScoreCalcTime > Double.random(in: 0.01...0.1) {
                prevScoreCalcTime = currentTime
                if isNegativeVelocity {
                    ground.physicsBody?.velocity = CGVector(dx: calculatePeakAmplitude(magnitude: Double(magnitude)) * -10, dy: calculatePeakAmplitude(magnitude: Double(magnitude)/2) * -10)
                } else {
                    ground.physicsBody?.velocity = CGVector(dx: calculatePeakAmplitude(magnitude: Double(magnitude)) * 10, dy: calculatePeakAmplitude(magnitude: Double(magnitude)/2) * 10)
                }
                isNegativeVelocity.toggle()
            }
        }
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        if let name = touchedNode.name {
            if name == "start_button" {
                isSimulateEarthquake.toggle()
            }
        }
    }
    
    
    // MARK: - helper function
    
    // M = log10(amplitude) + correctionfactor
    // correction factor will be assign in distanceConstant
    private func calculatePeakAmplitude(magnitude: Double) ->  Double{
        return Double(pow(10.0, Double((magnitude - distanceConstant))))
    }
    
    @objc private func handleSlider(_ sender: UISlider) {
        magnitude = sender.value * 10
        switch sender.value * 10 {
        case 0...2.5:
            ritcherScaleDescription.texture = SKTexture(imageNamed: "ritcher_scale1")
        case 2...3.9:
            ritcherScaleDescription.texture = SKTexture(imageNamed: "ritcher_scale2")
        case 4...4.9:
            ritcherScaleDescription.texture = SKTexture(imageNamed: "ritcher_scale3")
        case 5...5.9:
            ritcherScaleDescription.texture = SKTexture(imageNamed: "ritcher_scale4")
        case 6...6.9:
            ritcherScaleDescription.texture = SKTexture(imageNamed: "ritcher_scale5")
        case 7...7.9:
            ritcherScaleDescription.texture = SKTexture(imageNamed: "ritcher_scale6")
        case 7...10:
            ritcherScaleDescription.texture = SKTexture(imageNamed: "ritcher_scale7")
        default:
            break
        }
    }
    
    
}
