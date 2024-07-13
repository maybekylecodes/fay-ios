//
//  MonthView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

struct MonthView: View {

    let month: String
    let day: String

    var body: some View {
        VStack(spacing: 8) {
            Text(month)
                .font(.footnote)
                .foregroundStyle(.fayBlue)

            Text(day)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
        }
        .frame(width: 56, height: 56)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.fayLightBlue)
        )
    }
}

#Preview {
    MonthView(month: "NOV", day: "12")
}
