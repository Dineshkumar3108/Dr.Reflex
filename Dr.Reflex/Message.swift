//
//  Message.swift
//  Schmooze Nave
//
//  Created by priyanka gayathri on 13/07/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation

struct Message {
    let sender : String
    let body : String
}

struct DoctorToChat: Hashable {
    let email: String
    let name: String
}

