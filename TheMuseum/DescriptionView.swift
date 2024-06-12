//
//  DescriptionView.swift
//  TheMuseum
//
//  Created by David Wasserman on 2024-06-10.
//

import SwiftUI

/// Various textual descriptions of all artifacts found in the museum
/// - Parameters:
///   - title: Title value to match textual description of artifact
struct DescriptionView: View {
  @State var title: String

  @Environment(\.dismissWindow) private var dismissWindow
  var body: some View {
    VStack(spacing: 50) {
      // MARK: - Maria Theresia
      if title.contains("MariaTheresia") {
        Text("Empress Maria Theresa Statue")
          .font(.extraLargeTitle)
          .bold()

        Text("Empress Maria Theresa statue in the French gardens of the Grassalkovich Palace in Bratislava. The statue is a reconstruction of the horse sculpture from the 2nd half of the 18th century.")
          .font(.title)

        // MARK: - St. Anna
      } else if title.contains("StAnna") {
        Text("St. Anna Sculpture")
          .font(.extraLargeTitle)
          .bold()

        Text("An altar sculpture showing an unknown saint, probably saint Anna, was made by an unknown artist in the 18th century. It supposedly comes from the wooden All Saints’ Church in Kęty which was dismantled on the command of Austrian authorities. The main reason for this decision was the poor technical condition of the building. Moreover, after the great fire which broke out in 1797, there were attempts to eliminate the wooden buildings from the centre in order to reduce the danger.")
          .font(.title)

        // MARK: - Queen Judith
      } else if title.contains("QueenJudith") {
        Text("Queen Judith Sculpture")
          .font(.extraLargeTitle)
          .bold()

        Text("The sculpture depicts Queen Judith, daughter of Emperor Henry III, wife first of King Solomon of Hungary and, after his death, of the Duke of Poland, Władysław Herman (died 1102). She granted the abbey an extensive property (the so-called klucz książnicki - lands surrounding Książnice Wielkie), which is why she was considered a co-founder and benefactor of the abbey. The polychrome sculpture was probably made in the 1st half of the 17th century, perhaps in connection with the 600th anniversary of the monastery’s foundation, which was celebrated in 1644.")
          .font(.title)
      }

      // MARK: - Dismiss DescriptionView
      Button {
        dismissWindow(id: "DescriptionView")
      } label: {
        Text("Dismiss")
          .font(.title)
          .frame(width: 360)
          .padding(24)
          .glassBackgroundEffect()
      }
    }
    .padding()
  }
}

#Preview {
  DescriptionView(title: "MariaTheresa")
}
