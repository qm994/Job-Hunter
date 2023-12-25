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
   
    var body: some View {
        DebugView("MainScreenView userProfile is: \(authModel.userProfile)")
        
        NavigationStack(path: $coreModel.path) {
            ZStack(
                alignment: Alignment(horizontal: .center, vertical: .bottom)
            ) {
                
                Group {
                    switch coreModel.selectedTab {
                        case .home:
                            HomeScreenView()
                        case .profile:
                            ProfileScreenView()
                    }
                }
                
                BottomNavigationView()
                
                
            }// Zstack ends
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(for: String.self) { value in
                if value == NavigationPath.addInterviewScreen.rawValue {
                    AddingScreenView(existingInterview: $coreModel.editInterview)
                }
            }
        } // NavigationStack ends
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
