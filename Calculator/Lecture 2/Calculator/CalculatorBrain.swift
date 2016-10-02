//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Apollonian on 4/24/16.
//  Copyright © 2016 WWITDC. All rights reserved.
//

import Foundation

class CalculatorBrain{

    private var accumulator = 0.0

    func setOperand(operand: Double) {
        accumulator = operand
    }

    private var operations : [String: Operation] = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "−": Operation.BinaryOperation({$0 - $1}),
        "=": Operation.Equals
    ]

    enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }

    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executeBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator)
            case .Equals:
                executeBinaryOperation()
            }
        }
    }

    private func executeBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }

    private var pending: PendingBinaryOperationInfo?

    private struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double) ->Double
        var firstOperand: Double
    }

    var result: Double{
        get{
            return accumulator
        }
    }
}