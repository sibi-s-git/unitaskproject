import SwiftUI
import MapKit

struct MapSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedLocation: CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion

    init(selectedLocation: Binding<CLLocationCoordinate2D>) {
        self._selectedLocation = selectedLocation
        self._region = State(initialValue: MKCoordinateRegion(
            center: selectedLocation.wrappedValue, // Start at last selected location
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: .all)
                .edgesIgnoringSafeArea(.all)

            // Fixed Pin in the Center
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.red)
                .offset(y: -20) // Adjust so pin tip aligns with center

            VStack {
                Spacer()
                Button("Confirm Location") {
                    selectedLocation = region.center // Save last confirmed coordinates
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.bottom, 30)
            }
        }
    }
}
