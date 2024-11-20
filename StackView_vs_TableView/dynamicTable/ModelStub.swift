//
//  ModelStub.swift
//  StackView_vs_TableView
//
//  Created by Sergey Kozlov on 19.11.2024.
//

import Foundation
import Combine


class ModelStub {
    var airplaneMode = CurrentValueSubject<Bool, Never>(false)
    var bluetooth = CurrentValueSubject<Bool, Never>(false)
    var wifi = CurrentValueSubject<String, Never>("Home")
    var personalHotspot = CurrentValueSubject<Bool, Never>(false)
    var vpn = CurrentValueSubject<Bool, Never>(false)
    
    static let shared = ModelStub()
}
