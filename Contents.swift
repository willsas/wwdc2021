import PlaygroundSupport
import SpriteKit

/*:
 # Welcome to EarthQuacke🦆!
 the simulation of earthquake
 
 I'm going to present to simulate each number on the Ritcher scale in an earthquake, the purpose of this simulates is I want people to appreciate how big earthquake is, what does those Scale Ritcher mean in news? why does 7 Ritcher seem to have a really big deal but 6 isn't?  you don't know,  neither I'm!
 
 So, to know how big differences I create this turns out it's really Ritcher scale is 10x scale!  that's why the 5 Ritcher scale is not much compared to the 7 Ritcher scale! that's 100x bigger!
 
 Hopefully, this will help people to appreciate how big the earthquake is, if other parts of the earth experienced a big disaster, we do not only know the numbers but we now know what actually is
 
 [Let's get started!](@next)
 
 Property reference:
 * Background image: https://www.freepik.com/free-photo/design-space-paper-textured-background_3220799.htm#page=1&query=paper&position=0
 * Otherwise,  i draw by myself, thanks to https://sketch.io

*/


let baseView = SKView(frame: CGRect(x: 0, y: 0, width: 600, height: 700))
let scene = ViewScene()
scene.scaleMode = .resizeFill
baseView.presentScene(scene)
baseView.ignoresSiblingOrder = true


/// Uncomment this to see earthquake clearly
//baseView.showsFPS = true
//baseView.showsNodeCount = true
//baseView.showsPhysics = true


PlaygroundPage.current.setLiveView(baseView)

