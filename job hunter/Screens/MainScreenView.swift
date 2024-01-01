import SwiftUI

enum NavigationPath: String {
    case addInterviewScreen
    case addInterviewPastRoundsScreen
    
    var id: String {
        self.rawValue
    }
}

struct MainScreenView: View {
    @EnvironmentObject var coreModel: CoreModel
    @EnvironmentObject var authModel: AuthenticationModel
    @StateObject var interviewModel: InterviewsViewModel = InterviewsViewModel()
   
    var body: some View {        
        NavigationStack(path: $coreModel.path) {
            GeometryReader { geometry in
                VStack(spacing: 5) {
                    Group {
                        switch coreModel.selectedTab {
                            case .home:
                                HomeScreenView()
                            case .profile:
                                ProfileScreenView()
                        }
                    }
                    .frame(height: geometry.size.height * 0.9) // 90% of available height
                    .environmentObject(interviewModel)
                    
                    
                    BottomNavigationView()
                        //.overlay(Rectangle().stroke(Color.red, lineWidth: 1))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(edges: .bottom)
                .navigationDestination(for: String.self) { value in
                    if value == NavigationPath.addInterviewScreen.rawValue {
                        AddingScreenView(existingInterview: $coreModel.editInterview)
                    }
            }
            }
        } // NavigationStack ends
        //.environment(CoreModel())
    }
}

struct MainScreenView_Previews: PreviewProvider {
   
    static var previews: some View {
        NavigationStack {
            MainScreenView()
                .environmentObject(AuthenticationModel())
                .environmentObject(CoreModel())
        }
       
    }
}
