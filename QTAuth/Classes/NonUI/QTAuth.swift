//
//  QTAuth.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 21/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import Foundation

public class QTAuth {
    
    var config: QTAuthUIConfig?
    
    public static let instance: QTAuth = QTAuth()
    
    private init() {
        
    }
    
    public func initialize(with config: QTAuthUIConfig) {
        self.config = config
    }
}
