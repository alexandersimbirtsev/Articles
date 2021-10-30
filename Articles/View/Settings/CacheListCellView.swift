//
//  CacheListCellView.swift
//  Articles
//
//  Created by Александр on 30.10.2021.
//

import SwiftUI

struct CacheListCellView: View {
    let title:  String
    let size:   String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
            Text(size)
            Spacer()
            Button("Delete", role: .destructive, action: action)
        }
    }
}

struct CacheListCellView_Previews: PreviewProvider {
    static var previews: some View {
        CacheListCellView(title: "Images", size: "100 MB", action: {})
    }
}
