import Foundation

var barriers: [Shape] = []

var targets: [Shape] = []

let ball = OvalShape(width: 40, height: 40)

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/

fileprivate func setupBall() {
    ball.position = Point(x: 175, y: 400)
    scene.add(ball)
    ball.fillColor = .blue;
    ball.hasPhysics = true
    ball.isDraggable = false
    ball.onCollision = ballCollided(with:)
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    ball.bounciness = 1.4
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]

    let barrier = PolygonShape(points: barrierPoints)

    barriers.append(barrier)

    // Existing code from setupBarrier() below.

//fileprivate func addBarrier() {
    barrier.position = position
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.fillColor = .green
    barrier.isImmobile = true
    barrier.isDraggable = false
    barrier.angle = angle
}

    
fileprivate func setupFunnel() {
    // Add a funnel to the scene.
    funnel.position = Point(x: 175, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.fillColor = .darkGray
    funnel.isDraggable = false
}

func setup() {
    setupBall()
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 10, y: 400), width: 80, height: 25, angle: -1.2)
    addBarrier(at: Point(x: 85, y: 150), width: 40, height: 15, angle: -0.4)
    addBarrier(at: Point(x: 325, y: 150), width: 100, height: 25, angle: 0.3)
    setupFunnel()
    addTarget(at: Point(x: 150, y: 400))
    addTarget(at: Point(x: 184, y: 563))
    addTarget(at: Point(x: 238, y: 624))
    addTarget(at: Point(x: 269, y: 453))
    addTarget(at: Point(x: 213, y: 348))
    addTarget(at: Point(x: 113, y: 267))
    resetGame()
}

// Drops the ball by moving it to the funnel's position.
func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
            barrier.isDraggable = false
        }
    
    for target in targets {
        target.fillColor = .magenta
    }
}


func addTarget(at position: Point) {
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]

    let target = PolygonShape(points: targetPoints)

    targets.append(target)
    
 // func addTarget() {
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
    //target.isDraggable = false
    
}

// Handles collisions between the ball and the targets.
func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" {return }
    otherShape.fillColor = .orange
}

func ballExitedScene() {
    for barrier in barriers {
            barrier.isDraggable = true
        
        var hitTargets = 0
        for target in targets {
            if target.fillColor == .green {
                hitTargets += 1
            }
        }

        if hitTargets == targets.count {
            scene.presentAlert(text: "You won!", completion: alertDismissed)
        }
        
    }
}

func alertDismissed() {
    
}

// Resets the game by moving the ball below the scene,
// which will unlock the barriers.
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}
