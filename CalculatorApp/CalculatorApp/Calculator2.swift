//
//  Calculator2.swift
//  CalculatorApp
//
//  Created by 김상준 on 4/23/24.
//

import SwiftUI

enum ButtonType : String {
    case first, second, third, forth, fifth, sixth, seventh, eighth, nineth, zero
    case dot, equal, plus, minus, multiple, devide
    case percent, opposite, clear
    
    var ButtonDisplayName : String {
        switch self {
        case .first :
            return "1"
        case .second :
            return "2"
        case .third :
            return "3"
        case .forth :
            return "4"
        case .fifth :
            return "5"
        case .sixth :
            return "6"
        case .seventh :
            return "7"
        case .eighth :
            return "8"
        case .nineth :
            return "9"
        case .zero :
            return "0"
            
        case .dot:
            return "."
        case .equal:
            return "="
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .multiple:
            return "x"
        case .devide:
            return "÷"
        case .percent:
            return "%"
        case .opposite:
            return "+/-"
        case .clear:
            return "C"
        }
    }
    var backgroundColor : Color {
        switch self {
        case .first,.second,.third,.forth,.fifth,.sixth,.seventh,.eighth,.nineth,.zero,.dot :
            return Color("ButtonColor")
        case .equal,.plus,.minus,.multiple,.devide :
            return .orange
        case .percent,.opposite,.clear:
            return .gray
        }
    }
    var forgroundColor: Color {
        switch self {
        case .clear, .opposite, .percent : return .black
        default: return .white
        }
    }
}
struct Calculator2: View {
    
    @State var displayNumber : String = "0"
    @State var expression : String = ""
    @State var mathExpression = NSExpression()
    @State var mathValue : String = ""
    
    @State var isadd : Bool = false
    @State var isminus : Bool = false
    @State var ismultiple : Bool = false
    @State var isdevide : Bool = false
    @State var isequal : Bool = false
    
    private let buttonData: [[ButtonType]] = [
        [.clear,.opposite,.percent,.devide],
        [.seventh,.eighth,.nineth,.multiple],
        [.forth,.fifth,.sixth,.minus],
        [.first,.second,.third,.plus],
        [.zero,.dot,.equal],
        
    ]
    
    var body: some View {
        ZStack{
            VStack(alignment:.trailing) {
                Spacer()
                
                Text("\(displayNumber)")
                    .foregroundStyle(.white)
                    .font(displayNumber.count > 7 ? .system(size: 40) : .system(size: 60))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                ForEach(buttonData, id: \.self){ line in
                    HStack{
                        ForEach(line,id: \.self){ item in
                            Button(action: {
                                if displayNumber == "0"{ // 계산기 시작 전
                                    displayNumber = ""
                                    if item == .plus ||
                                        item == .minus ||
                                        item == .multiple ||
                                        item == .devide ||
                                        item == .equal ||
                                        item == .percent ||
                                        item == .clear{
                                        displayNumber = "0"
                                        
                                    }else if item == .dot{
                                        displayNumber += "."
                                        expression += "."
                                    }
                                    else if item == .opposite{
                                        displayNumber = "-\(displayNumber)"
                                        expression += "-\(expression)"
                                    }
                                    else{
                                        expression += item.ButtonDisplayName
                                        displayNumber += item.ButtonDisplayName
                                    }
                                }
                                else{ // 계산기 시작 후
                                    if item == .clear {
                                        displayNumber = "0"
                                        expression = ""
                                        return
                                    }
                                    else if item == .opposite{
                                        if expression.contains("-"){
                                            let editSum = expression.dropFirst(1)
                                            expression = String(editSum)
                                            
                                        }else{
                                            expression = "-\(expression)"
                                            displayNumber = "-\(displayNumber)"
                                        }
                                    }
                                    else if item == .percent{
                                        expression = String(0.01 * Double(displayNumber)!)
                                        displayNumber = String(0.01 * Double(displayNumber)!)
                                    }
                                    else if item == .plus {
                                        isadd.toggle() // true
                                        expression += "+"
                                    }
                                    else if item == .multiple {
                                        ismultiple.toggle()
                                        expression += "*"
                                    }
                                    else if item == .minus {
                                        isminus.toggle()
                                        expression += "-"
                                    }
                                    else if item == .devide {
                                        isdevide.toggle()
                                        expression += "/"
                                    }
                                    else if item == .dot{
                                        if(displayNumber.contains(".")){
                                            displayNumber = displayNumber
                                        }else{
                                            displayNumber += "."
                                        }
                                    }
                                    else if item == .equal{
                                        mathExpression = NSExpression(format: expression)
                                        mathValue = "\(mathExpression.expressionValue(with: nil, context: nil)!)"
                                        displayNumber = String(mathValue)
                                        print(type(of : expression))
                                    }
                                    else{
                                        
                                        if isadd{
                                            displayNumber = ""
                                            expression += item.ButtonDisplayName
                                            displayNumber += item.ButtonDisplayName
                                            isadd.toggle()
                                        }
                                        else if isminus{
                                            displayNumber = ""
                                            expression += item.ButtonDisplayName
                                            displayNumber += item.ButtonDisplayName
                                            isminus.toggle()
                                        }
                                        else if ismultiple{
                                            displayNumber = ""
                                            expression += item.ButtonDisplayName
                                            displayNumber += item.ButtonDisplayName
                                            ismultiple.toggle()
                                        }
                                        else if isdevide{
                                            displayNumber = ""
                                            expression += item.ButtonDisplayName
                                            displayNumber += item.ButtonDisplayName
                                            isdevide.toggle()
                                        }else{
                                            expression += item.ButtonDisplayName
                                            displayNumber += item.ButtonDisplayName
                                            
                                        }
                                    }
                                }
                                
                            }, label: {
                                Text(item.ButtonDisplayName)
                                    .frame(width:calculateButtonWidth(button: item),height: calculateButtonHeight(button: item))
                                    .background(item.backgroundColor)
                                    .cornerRadius(40)
                                    .foregroundColor(item.forgroundColor)
                                    .font(.system(size: 33))
                            })
                        }
                    }
                }
                
            }
        }
        
    }
    
    
    private func calculateButtonWidth(button buttonType: ButtonType) -> CGFloat {
        
        switch buttonType {
            
        case .zero:
            return (UIScreen.main.bounds.width - 5*10) / 2
        default:
            return (UIScreen.main.bounds.width - 5*10) / 4
        }
    }
    
    private func calculateButtonHeight(button: ButtonType)-> CGFloat{
        return (UIScreen.main.bounds.width - 5*10) / 4
        
    }
}

#Preview {
    Calculator2()
}
