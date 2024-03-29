//
//  ContentView.swift
//  BucketList
//
//  Created by enesozmus on 29.03.2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41, longitude: 28),
            span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
        )
    )
    
    @State private var viewModel = ViewModel()
    
    let mapStyleList = ["Default", "Satellite", "Hybrid"]
    @State private var selectedMapStyle = "Default"
    
    var mapStyle: MapStyle {
        switch selectedMapStyle {
        case "Satellite":
            return .imagery
        case "Hybrid":
            return .hybrid
        default:
            return .standard
        }
    }
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        } onDelete: { place in
                            viewModel.deleteLocation(location: place)
                        }
                    }
                    .mapStyle(mapStyle)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Picker("Map Style", selection: $selectedMapStyle) {
                            ForEach(mapStyleList, id: \.self) { style in
                                Text("\(style)")
                            }
                        }
                        .background(Color(UIColor.systemBackground).opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding()
                    }
                    
                    Spacer()
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .buttonStyle(BorderedProminentButtonStyle())
        }
    }
}

#Preview {
    ContentView()
}
