import SwiftUI

enum NavigationPath: String {
    case addInterviewScreen
    case addInterviewPastRoundsScreen
    
    var id: String {
        self.rawValue
    }
}

struct MainScreenView: View {
    @EnvironmentObject var router: AddScreenViewRouterManager
    @EnvironmentObject var coreModel: CoreModel
    
    @State private var showAddView: Bool = false
    @State private var path: [String] = []
    
    var body: some View {
        
        //TODO: Fix navigation of + button to AddPendingScreen
        
        NavigationStack(path: $path) {
            ZStack{
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    
                    //MARK: TABVIEW
                    TabView(selection: $coreModel.selectedTab) {
                        HomeScreenView()
                            .tag(BottomNavigationModel.home)
                        
                        ProfileScreenView()
                            .tag(BottomNavigationModel.profile)
                        
                    } //TabView ends
                    .tabViewStyle(
                        PageTabViewStyle(indexDisplayMode: .always))
                    .ignoresSafeArea(.all, edges: .bottom)
                    
                    
                    VStack {
                        TabMenuIcon()
                            .onTapGesture {
                                withAnimation {
                                    path.append(NavigationPath.addInterviewScreen.rawValue)
                                }
                            }

                        //MARK: Bottom Navigation
                        BottomNavigationView()
                    }
                }// Zstack ends
                
                if (coreModel.showAddPopMenu) {
                    PopUpMenu()
                        .padding(.vertical, UIScreen.main.bounds.height / 8 + 40)
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == NavigationPath.addInterviewScreen.rawValue {
                    AddPendingScreen(path: $path)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
   
    static var previews: some View {
        NavigationStack {
            MainScreenView()
                .environmentObject(AuthenticationModel())
                .environmentObject(AddScreenViewRouterManager())
                .environmentObject(CoreModel())
        }
       
    }
}
