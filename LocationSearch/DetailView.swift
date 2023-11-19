//
//  DetailView.swift
//  LocationSearch
//
//  Created by Yoo on 2023/11/19.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var lookArroundScene: MKLookAroundScene?
    @Binding var getDirection: Bool
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, content: {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top, 12)
                    
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                })

                Spacer()
                
                Button(action: {
                    show.toggle()
                    mapSelection = nil
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                })
            }
            
            if let scene = lookArroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
            }
            
            HStack(spacing: 24) {
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                } label: {
                    Text("マップで表示")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                Button {
                    getDirection = true
                    show = false
                } label: {
                    Text("経路を表示")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            fetchLookAroundPreview()
        }
        .padding()
    }
}

extension DetailView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookArroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookArroundScene = try? await request.scene
            }
        }
    }
}

#Preview {
    DetailView(mapSelection: .constant(nil), show: .constant(false), getDirection: .constant(false))
}
