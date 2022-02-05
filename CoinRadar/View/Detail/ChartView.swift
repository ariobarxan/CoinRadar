//
//  ChartView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/5/22.
//

import SwiftUI

struct ChartView: View {
    
    //MARK: - Var
    @State private var percentageAnimation: CGFloat = 0
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let color: Color
    private let sDate: Date
    private let eDate: Date
    
    //MARK: - Initializer
    init(coin: Coin){
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceDirection = (data.last ?? 0) - (data.first ?? 0)
        
        color = priceDirection > 0 ? Color.theme.green : Color.theme.red
        eDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        sDate = eDate.addingTimeInterval(-7*24*60*60)
    }
    
    
    //MARK: - Body
    var body: some View {
        VStack{
            chartView
                .frame(height: 200)
                .background(background)
                .overlay(alignment: .leading, content: {chartYAxis.padding(.horizontal, 4)})
                
            dateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2)){
                    percentageAnimation = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView{
    //MARK: - Views
    private var chartView:  some View {
        //Calculating X Poistion
        /*
        
         Width of the Graph: 300
         Number of items:   100
         Indexes start at 0 and Count start from 1
         By division width / items we get each price point size
         By multiplication of each poin size to index + 1 we get the right position of the price poin in regards to X Axis
         */
        
        //Calculating Y Position
        /*
        The Gap between highest and lowest price determines the height portion of hour graph
         
         Distance between each price point and the bottom price point Divided by height portion determines the price point position in percentage related to the bottom point
         
         Price point portion postion multiply the height of graph frame determines exact position
         
         Swift cordinate starts from top left and the max point is at the bottom right opposite of real world axis. We need to calculate the point portion position and then substract it from 1 to gain portion from top point which is bottom point in real axis
         */
        
        GeometryReader{ geometry in
            Path{ path in
                for index in data.indices {
                        
                    ///X Position
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    ///Y Poistion
                    let yAxisSize = maxY - minY
                    
                    let yPosition = CGFloat(1 - (data[index] - minY) / yAxisSize)
                    * geometry.size.height
                    
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentageAnimation)
            .stroke(color ,
                    style: StrokeStyle(lineWidth: 2,
                                       lineCap: .round,
                                       lineJoin: .round)
            )
            .shadow(color: color, radius: 10, x: 0, y: 10)
            .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    private var background: some View {
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    private var chartYAxis: some View {
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
               Spacer()
            Text(minY.formattedWithAbbreviations())
               
        }
    }
    private var dateLabels: some View {
        HStack{
            Text(sDate.asShortDateString())
            Spacer()
            Text(eDate.asShortDateString())
        }

    }
}
