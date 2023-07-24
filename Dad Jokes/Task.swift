//
//  Task.swift
//  Dad Jokes
//
//  Created by Yiqiu Huang on 7/22/23.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var time: Int
    var color: Color
    var type: String
    var name: String
}
