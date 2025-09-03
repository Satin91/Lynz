//
//  Pose.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation

enum Pose: CaseIterable, Identifiable {
    case standing
    case layingDown
    case sitting
    case closeUp
    
    var mainPhoto: ImageResource {
        switch self {
        case .standing:
            return .fullLenght
        case .layingDown:
            return .threeQuarter
        case .sitting:
            return .seatedPose
        case .closeUp:
            return .closeUp
        }
    }
    
    var name: String {
        switch self {
        case .standing:
            "Standing"
        case .layingDown:
            "Laying Down"
        case .sitting:
            "Sitting"
        case .closeUp:
            "Close-Up"
        }
    }
    
    var id: Self { self }
}

extension Pose {
    var photosExmples: [ImageResource] {
        switch self {
        case .standing:
            return [
                .fullLenght,
                .fullLenght1,
                .fullLenght4,
                .fullLenght5,
                .fullLenght6,
                .fullLenght7,
                .fullLenght8,
                .fullLenght10
            ]
        case .layingDown:
            return [
                .threeQuaters7,
                .threeQuaters9,
                .threeQuaters10,
                .threeQuaters11,
                .threeQuaters12,
                .threeQuaters13,
                .threeQuaters14,
                .threeQuaters15
            ]
        case .sitting:
            return [
                .sitting1,
                .sitting2,
                .sitting3,
                .sitting4,
                .sitting5,
                .sitting6,
                .sitting7
            ]
        case .closeUp:
            return [
                .portrait1,
                .portrait2,
                .portrait3,
                .portrait4,
                .portrait5,
                .portrait6,
                .portrait7,
                .portrait8
            ]
        }
    }
}
