//
//  HapticManager.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/4/22.
//

import Foundation
import SwiftUI

class HapticManager{
   
    static private let  generator = UINotificationFeedbackGenerator()
    
    static func notification(type : UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
