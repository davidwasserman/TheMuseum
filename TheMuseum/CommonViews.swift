//
//  SharedViews.swift
//  TheMuseum
//
//  Created by David Wasserman on 2024-06-13.
//

import SwiftUI

struct LearnMoreButtonView: View {
  var body: some View {
    Text("Learn more")
      .font(.extraLargeTitle)
      .padding(.vertical, 40)
      .padding(.horizontal, 60)
      .glassBackgroundEffect()
  }
}

struct TitleTextView: View {
  var title: String
  var body: some View {
    Text(title)
      .font(.extraLargeTitle)
      .padding(.vertical, 40)
      .padding(.horizontal, 60)
  }
}

// MARK: - Description Modifier
struct DescriptionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .font(.title)
        .padding(.horizontal, 80)
    }
}

extension View {
    func DescriptionStyle() -> some View {
        modifier(DescriptionModifier())
    }
}

// MARK: - Title Modifier
struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .font(.extraLargeTitle)
        .bold()
    }
}

extension View {
    func TitleStyle() -> some View {
        modifier(TitleModifier())
    }
}

#Preview {
  LearnMoreButtonView()
}

#Preview {
  TitleTextView(title: "Test")
}
