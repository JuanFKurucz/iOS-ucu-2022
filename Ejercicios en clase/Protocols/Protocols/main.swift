//
//  main.swift
//  Protocols
//
//  Created by Juan Francisco Kurucz on 6/4/22.
//

protocol CanFly {
    func fly()
}

class Bird {
    var isFemale = true
    
    func layEgg() {
        if isFemale {
            print("laying egg")
        }
    }
    
}

class Eagel: Bird, CanFly {
    func soar(){
        print("soaring")
    }
    
    func fly(){
        print("flying as an eagle")
    }
}

let eagle = Eagel()
eagle.fly()

class Penguin: Bird {
    func swim() {
        print("swimming")
    }
}

let penguin = Penguin()

struct FlyingMuseum {
    func showFlyingDemo(flyingObject: CanFly){
        flyingObject.fly()
    }
}

let museum = FlyingMuseum()
museum.showFlyingDemo(flyingObject: eagle)
museum.showFlyingDemo(flyingObject: penguin)

class Airplane: Bird {
    
}
let airplane = Airplane()
museum.showFlyingDemo(flyingObject: airplane)
