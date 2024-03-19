import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            ReceiveDataView()
            RemoteImage()
            ValidateForms()
            HapticsSimple()
            HapticsComplex()
            EncodingRename()
        }
    }
}
