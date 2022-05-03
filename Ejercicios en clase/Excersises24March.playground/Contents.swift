import UIKit

//var greeting = "Hello, playground"
//
//// MARK: -1
//// Chequear si 2 palabras son un anagrama, devuelve un booleano
//
//func isAnagram(_ lhs: String, _ rhs: String) -> Bool {
//    return lhs.sorted() == rhs.sorted();
//}
//
//print(isAnagram("hola","aloh"))


// MARK: -2

func isReverse(_ lhs: String, _ rhs : String) -> Bool {
    if lhs.count != rhs.count {
        return false;
    }
    
    var chars : [String.Element] = []
    
    for (_, char) in lhs.enumerated() {
        chars.append(char)
    }

    for (_, char) in rhs.enumerated() {
        if chars.popLast() != char {
            return false;
        }
    }
    
    return true;
}


//print(isReverse("hola","aloh"))
//print(isReverse("hola","alxh"))
//print(isReverse("hola","hola"))

// MARK: -3

func isPalindrome(_ word: String) -> Bool {
    return word == String(word.reversed())
}

//print(isPalindrome("anna"))
//print(isPalindrome("axna"))

// MARK: -4

//crear un juego de piedra papel o tijera usando un enumerado para las opciones. Otor para los resultaods (ganar, perder o empatar) y un metodo que a partir de 2 opciones devuelva el resultado del primer jugador

enum HandShape {
    case piedra, papel, tijera
}

enum MatchResult {
    case ganar, perder, empatar
}

func match(lhs: HandShape, rhs: HandShape) -> MatchResult {
    if(
        (lhs == HandShape.piedra && rhs == HandShape.tijera) ||
        (lhs == HandShape.tijera && rhs == HandShape.papel) ||
        (lhs == HandShape.papel && rhs == HandShape.piedra)
    
    ){
        return MatchResult.ganar;
    }
    
    if(
        (rhs == HandShape.piedra && lhs == HandShape.tijera) ||
        (rhs == HandShape.tijera && lhs == HandShape.papel) ||
        (rhs == HandShape.papel && lhs == HandShape.piedra)
    
    ){
        return MatchResult.perder;
    }
    
    return MatchResult.empatar;
}

//print(match(lhs: HandShape.piedra, rhs: HandShape.piedra));
//print(match(lhs: HandShape.piedra, rhs: HandShape.papel));
//print(match(lhs: HandShape.piedra, rhs: HandShape.tijera));

// MARK: -5
/*
    Contar la cantidad de ocurrencias de cad apalabra en una lista de strings
 */

func countStrings(_ strings: [String]) -> [String: Int] {
    var counter : [String: Int] = [:];
    
    for (_, str) in strings.enumerated() {
        for (_, element) in str.split(separator: " ").enumerated() {
            counter[String(element), default: 0] += 1;
        }
    }
    
    return counter;
}

//print(countStrings(["hola como estas","hola estoy bien","como estas tu"]));


// MARK: -6

func applyNTimes(_ n: Int, _ closure: () -> ()) {
    for _ in 1...n {
        closure()
    }
}

func showMessage(){
    print("hi")
}

//applyNTimes(5,showMessage)

// MARK: -7

func getInts(from string: String) -> [Int] {
    var array : [Int] = []
    do {
        let json = try JSONSerialization.jsonObject(with:  string.data(using: .utf8)!, options: []) as? [Any]
        json?.forEach({ item in
            if let _ = item as? Int {
            array.append(item as! Int)
           }
        })
    } catch {
        print("Error: Couldn't parse JSON. \(error.localizedDescription)")
    }
    return array;
}

print(getInts(from: "[\"a\", \"b\", 1, {}, 4.3, 2]"))
