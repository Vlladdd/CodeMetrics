//
//  main.swift
//  lab3
//
//  Created by Vlad Nechiporenko on 12/24/20.
//  Copyright © 2020 Vlad Nechyporenko. All rights reserved.
//

import Foundation

var countOfRows = 0
var countOfEmptyRows = 0
var coments = 0
var isLongComent = false
var physicRows = 0
var logicRows = 0
var text: String?
var comentsLevel = 0.0
var percentageComents = 0
var tempRows = 0
var tempComents = 0
let fileUrl = URL(string:"file:///Users/vladnechiporenko/Developer/lab3/lab3/test")
func calculateString(_ string:String) {
    logicRows += 1
    if isLongComent && !string.isEmpty{
        coments += 1
        logicRows -= 1
        tempComents += 1
    }
    if string.hasPrefix("//") && !isLongComent{
        coments += 1
        tempComents += 1
        logicRows -= 1
    }
    if (string == " " || string == "") && !isLongComent{
        logicRows -= 1
    }
    if string.contains(";") && !string.hasPrefix("//") && !string.hasPrefix("/*") && !string.hasSuffix("*/") && !isLongComent{
        let newStringArray = string.components(separatedBy:";")
        for _ in newStringArray {
            logicRows += 1
        }
        logicRows -= 1
    }
    if string.hasSuffix("*/") && string.hasPrefix("/*") && !isLongComent{
        coments += 1
        tempComents += 1
        logicRows -= 1
    }
    if string.hasPrefix("/*") && !string.hasSuffix("*/") && !isLongComent{
        isLongComent = true
        coments += 1
        logicRows -= 1
        tempComents += 1
    }
    if string.hasSuffix("*/") && !string.hasPrefix("/*"){
        isLongComent = false
    }
    if string == "{" || string == "}"{
        logicRows -= 1
    }
    if string.contains("import"){
        logicRows -= 1
    }
    if string.contains("struct"){
        logicRows -= 1
    }
    if string.contains("class"){
        logicRows -= 1
    }
    if string.contains("func"){
        logicRows -= 1
    }
    if string.contains("extension"){
        logicRows -= 1
    }
    if string.contains("init"){
        logicRows -= 1
    }
}
func calculate(_ fileUrl: URL?){
//    countOfRows = 0
//    countOfEmptyRows = 0
//    coments = 0
//    isLongComent = false
//    physicRows = 0
//    logicRows = 0
    do {
        text = try String(contentsOf: fileUrl!, encoding: .utf8)
    }
    catch {}
    let newStringArray = text?.components(separatedBy:"\n")
    countOfEmptyRows -= 1
    countOfRows -= 1
    tempRows = -1
    tempComents = 0
    for x in newStringArray! {
        var string = x.trimmingCharacters(in: .whitespaces)
        if string.isEmpty {
            countOfEmptyRows += 1
        }
        countOfRows += 1
        physicRows += 1
        tempRows += 1
        var y = ""
        var g = false
        for x in string {
            if x == "/" {
                g = true
            }
            if g {
                y.append(x)
            }
        }
        let z = y.replacingOccurrences(of: "{", with: "")
        let a = z.replacingOccurrences(of: "}", with: "")
        string = string.replacingOccurrences(of: y, with: a)

        
        if !string.hasPrefix("//") && !string.hasPrefix("/*") && !isLongComent && !string.isEmpty{
            let arrayString = string.components(separatedBy: "{")
            if arrayString.count != 0 {
                for x in arrayString {
                    let arrayString2 = x.components(separatedBy: "}")
                    for y in arrayString2 {
                        let string2 = y.trimmingCharacters(in: .whitespaces)
                        calculateString(string2)
                    }
                }
            }
        }
        else {
            calculateString(string)
        }
    }
    percentageComents = (tempRows * 25) / 100
    if tempComents > percentageComents {
        physicRows -= tempComents
        physicRows += percentageComents
    }
}
//calculate(fileUrl)
let fileManager = FileManager.default
let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: "/Users/vladnechiporenko/Developer/lab3/realm/RealmSwift")!

while let element = enumerator.nextObject() as? String {
    if element.hasSuffix("swift") {
        let path = "file:///Users/vladnechiporenko/Developer/lab3/realm/RealmSwift/" + element
//        print(path)
        let fileUrl = URL(string:path)
        calculate(fileUrl)
//        comentsLevel = Double(coments) / Double((countOfRows - countOfEmptyRows))
//        comentsLevel = Double(round(10*comentsLevel)/10)
//        print("Count of Rows:",countOfRows)
//        print("Count of Empty Rows:",countOfEmptyRows)
//        print("Count of Coments:",coments)
//        print("Coments Level:",comentsLevel)
//        print("Count of Logic Rows:",logicRows)
//        print("Count of Physics Rows:",physicRows)
    }
}
comentsLevel = Double(coments) / Double((countOfRows - countOfEmptyRows))
comentsLevel = Double(round(10*comentsLevel)/10)
print("Count of Rows:",countOfRows)
print("Count of Empty Rows:",countOfEmptyRows)
print("Count of Coments:",coments)
print("Coments Level:",comentsLevel)
print("Count of Logic Rows:",logicRows)
print("Count of Physics Rows:",physicRows)
