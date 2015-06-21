//
//  ViewController.swift
//  Calculator Assignment
//
//  Created by Sam Scalise on 6/20/15.
//  Copyright (c) 2015 Sam Scalise. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        if !userIsInTheMiddleOfTypingANumber ||
            display.text!.rangeOfString(sender.currentTitle!) == nil {
            display.text = display.text! + sender.currentTitle!
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func invertDisplay() {
        if displayValue != 0 {
            if userIsInTheMiddleOfTypingANumber {
                if display.text!.rangeOfString("-") == nil {               display.text = "-" + display.text!
                } else {
                    display.text = dropFirst(display.text!)
                }
            } else {
                if operandStack.count >= 1 {
                    displayValue = -operandStack.removeLast()
                    enter()
                }
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        appendToHistory(operation)
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation { M_PI }
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: () -> Double) {
        displayValue = operation()
        enter()
    }
    
    private func appendToHistory(entry: String) {
        history.text = history.text! + " " + entry
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue!)
        println("operandStack = \(operandStack)")
        appendToHistory(display.text!)
    }
    
    @IBAction func clear() {
        displayValue = nil
        history.text! = ""
        operandStack.removeAll()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if count(display.text!) > 1 {
                display.text = dropLast(display.text!)
            } else {
                displayValue = nil
            }
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if newValue == nil {
                display.text = "0"
            } else {
                display.text = "\(newValue!)"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

