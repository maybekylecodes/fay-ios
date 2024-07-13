//
//  StatusSelectionView.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import SwiftUI

struct StatusSelectionView: View {

    @Binding var selected: StatusSelection

    var body: some View {
        ZStack(alignment: .bottom) {

            SeparatorView()

            HStack(spacing: 24) {
                ForEach(StatusSelection.allCases, id: \.self) { status in
                    Button {
                        selected = status
                    } label: {
                        VStack(spacing: 8) {
                            Text(status.rawValue)
                                .foregroundStyle(selected == status ? .fayBlue : .primary)

                            Rectangle()
                                .fill(selected == status ? .fayBlue : .clear)
                                .frame(height: 1)
                        }
                        .fixedSize()
                    }
                    .buttonStyle(.plain)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    VStack {
        StatusSelectionView(selected: .constant(.upcoming))
        StatusSelectionView(selected: .constant(.past))
    }
}
