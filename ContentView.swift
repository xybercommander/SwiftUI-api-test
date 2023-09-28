//
//  ContentView.swift
//  course-test-api
//
//  Created by Samrat Mukherjee on 27/09/23.
//

import SwiftUI
import URLImage

struct Course: Hashable, Codable {
    let name: String
    let image: String
}

class ViewModel: ObservableObject {
    @Published var courses: [Course] = []
    
    func fetch() async throws {
        let url = URL(string: "http://iosacademy.io/api/v1/courses/index.php")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode([Course].self, from: data)
        print("DECODED DATA ====> \(decoded)")
        courses = decoded
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.courses, id: \.self) { course in
                    HStack {
                        URLImage(URL(string: course.image)!) { image in
                            image
                                .resizable()
                                .frame(width: 120, height: 70)
                                .cornerRadius(5)
                        }
                        
                        Text(course.name)
                            .font(.system(size: 14))
                    }
                    .background(.white)
                    .onTapGesture(perform: {
                        print(course)
                    })
                }
            }
            .listStyle(.plain)
            .navigationTitle("Courses")
            .padding(3)
            .background(.white)
        }
        .task {
            do {
                let _: () = try await viewModel.fetch()
            } catch {
                print(error)
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
        .edgesIgnoringSafeArea(.all)
}
