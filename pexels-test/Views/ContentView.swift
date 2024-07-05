//
//  ContentView.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 01/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VideoListView()
        }
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
