//
//  ContentView.swift
//  CalculatorApp
//
//  Created by 김상준 on 4/21/24.
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
            return "/"
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

struct ContentView: View {
    
    @State var numSum : String = "0"
    @State var tempNumber : Double = 0
    @State var operatorType : ButtonType = .clear
    @State var isEditing : Bool = true
    
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
                
                Text("\(numSum)")
                    .foregroundStyle(.white)
                    .font(.system(size: 70))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                
                ForEach(buttonData, id: \.self){ line in
                    HStack{
                        ForEach(line,id: \.self){ item in
                            Button(action: {
                                if numSum == "0"{ // 계산기 시작 전
                                    if item == .plus ||
                                        item == .minus ||
                                        item == .multiple ||
                                        item == .devide ||
                                        item == .equal ||
                                        item == .percent ||
                                        item == .clear{
                                        numSum = "0"
                                    }else if item == .dot{
                                        numSum += "."
                                    }
                                    else if item == .opposite{
                                        numSum = "-\(numSum)"
                                        
                                    }
                                    else{numSum = item.ButtonDisplayName}
                                    
                                }
                                else{ // 계산기 시작 후
                                    if item == .clear {
                                        numSum = "0"
                                    }
                                    else if item == .opposite{
                                        if numSum.contains("-"){
                                            let editSum = numSum.dropFirst(1)
                                            numSum = String(editSum)
                                            
                                        }else{
                                            numSum = "-\(numSum)"
                                        }
                                    }
                                    else if item == .percent{
                                        numSum = String(0.01 * Double(numSum)!)
                                    }
                                    else if item == .plus {
                                        tempNumber = Double(numSum)!
                                        operatorType = .plus
                                        numSum = "0"
                                    }else if item == .multiple {
                                        tempNumber = Double(numSum)!
                                        operatorType = .multiple
                                        numSum = "0"
                                    }else if item == .minus {
                                        tempNumber = Double(numSum)!
                                        operatorType = .minus
                                        numSum = "0"
                                    }
                                    else if item == .devide {
                                        tempNumber = Double(numSum)!
                                        operatorType = .devide
                                        numSum = "0"
                                    }
                                    else if item == .dot{
                                        if(numSum.contains(".")){
                                            numSum = numSum
                                        }else{
                                            numSum += "."
                                        }
                                    }
                                    else if item == .equal{
                                        if operatorType == .plus {
                                            numSum = String(format: "%g",(Double(numSum))! + tempNumber)
                                        }else  if operatorType == .multiple {
                                            numSum = String(format: "%g",(Double(numSum))! * tempNumber)
                                        }else  if operatorType == .minus {
                                            numSum = String(format: "%g",tempNumber - (Double(numSum))!)
                                        }else  if operatorType == .devide {
                                            numSum = String(format: "%g",tempNumber / (Double(numSum))!)
                                        }
                                    }
                                    else{
                                        numSum += item.ButtonDisplayName
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
    ContentView()
}
