//
//  SeparatorView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

struct SeparatorView: View {
    var body: some View {
        Rectangle()
            .fill(.separatorGray)
            .frame(height: 1)
            .padding(.top, 8)
    }
}

#Preview {
    SeparatorView()
}
