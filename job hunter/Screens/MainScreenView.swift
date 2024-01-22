import SwiftUI

enum NavigationPath: String {
    case addInterviewScreen
    case addInterviewPastRoundsScreen
    case settingsView
    case resetPasswordView
    
    var id: String {
        self.rawValue
    }
}

struct MainScreenView: View {
    //@EnvironmentObject var coreModel: CoreModel
    @EnvironmentObject var authModel: AuthenticationModel
    @StateObject var interviewModel: InterviewsViewModel = InterviewsViewModel()
    @StateObject var coreModel: CoreModel = CoreModel()
   
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
                            case .companies:
                                CompaniesListScreenView()
                            case .logInterview:
                                EmptyView()
                        }
                    }
                    .frame(height: geometry.size.height * 0.9) // 90% of available height
                    //.environmentObject(interviewModel)
                    
                    
                    BottomNavigationView(interviewModel: interviewModel)
                        .frame(height: geometry.size.height * 0.1)
                        //.overlay(Rectangle().stroke(Color.red, lineWidth: 1))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(edges: .bottom)
                .navigationDestination(for: String.self) { value in
                    if value == NavigationPath.addInterviewScreen.rawValue {
                        AddingScreenView(existingInterview: $coreModel.editInterview)
                    } else if value == NavigationPath.settingsView.rawValue {
                        SettingsView()
                    } else if value == NavigationPath.resetPasswordView.rawValue {
                        ResetPasswordView()
                    }
            }
            }
        } // NavigationStack ends
        .environmentObject(interviewModel)
        .environmentObject(coreModel)
    }
}

struct MainScreenView_Previews: PreviewProvider {
   
    static var previews: some View {
        NavigationStack {
            MainScreenView()
                .environmentObject(AuthenticationModel())
                //.environmentObject(CoreModel())
        }
       
    }
}
