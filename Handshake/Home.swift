import SwiftUI
import SpenceKit

struct Home: View {
    @EnvironmentObject var defaults: ObservableDefaults
    @ObservedObject var bleManager = BLEManager()

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Users\nNearby")
                        .font(.SpenceKit.SerifXLargeTitleFont)
                    Spacer()
                }

                ForEach(Array(zip(bleManager.discoveredDevices.indices, bleManager.discoveredDevices)), id: \.0) { index, device in
                    VStack(alignment: .leading) {
                        if bleManager.discoveredDevices[index].user != nil {
                            let user = bleManager.discoveredDevices[index].user!
                            HandshakeCardStatic(user: user)
                                .padding(.bottom, SpenceKit.Constants.spacing8)
                        }
                    }
                    .onAppear {
                        fetchPublicData(userId: device.name) { user in
                            if let index = bleManager.discoveredDevices.firstIndex(where: { $0.id == device.id }) {
                                DispatchQueue.main.async {
                                    bleManager.discoveredDevices[index].user = user
                                }
                            }
                        }
                    }
                }
    //            HStack {
    //                Button("Start Scanning") {
    //                    bleManager.startScanning()
    //                }
    //                .padding()
    //                .background(Color.blue)
    //                .foregroundColor(.white)
    //                .cornerRadius(8)
    //
    //                Button("Stop Scanning") {
    //                    bleManager.stopScanning()
    //                }
    //                .padding()
    //                .background(Color.red)
    //                .foregroundColor(.white)
    //                .cornerRadius(8)
    //            }
    //            .padding()
                
                Spacer()
            }.padding([.horizontal], SpenceKit.Constants.padding16)
        }
    }
    
    func fetchPublicData(userId: String, completion: @escaping (User) -> Void) {
        let url = URL(string: "\(CONSTANTS.endpoint)/auth/get_public_data/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }
            
            print(String(data: data ?? Data(), encoding: .utf8))
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Failed to fetch public data.")
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user)
            } catch {
                print("Error decoding User object: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
