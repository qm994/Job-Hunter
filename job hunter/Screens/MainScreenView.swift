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
    @State private var path: [String] = []
    
    var body: some View {
        DebugView("MainScreenView userProfile is: \(authModel.userProfile)")
        
        NavigationStack(path: $path) {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                
                TabView(selection: $coreModel.selectedTab) {
                    HomeScreenView()
                        .tag(BottomNavigationModel.home)
                        .navigationTitle("Home")
                    
                    ProfileScreenView()
                        .tag(BottomNavigationModel.profile)
                        .navigationTitle("Profile")
                    
                } //TabView ends
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .always))
                
                
                VStack {
                    CirclePlusAddButton() {
                        withAnimation {
                            path.append(NavigationPath.addInterviewScreen.rawValue)
                        }
                    }
                    
                    //MARK: Bottom Navigation
                    BottomNavigationView()
                        .padding(.bottom, 5)
                    
                }
                
            }// Zstack ends
            
            .navigationDestination(for: String.self) { value in
                if value == NavigationPath.addInterviewScreen.rawValue {
                    AddingScreenView(path: $path)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
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
