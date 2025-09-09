import UIKit

struct SplashScreenContainer {
    struct Dependency {
        let userSession: UserSessionManager
        let networkMonitoring: NetworkMonitoringProtocol
        let routerDelegate: SplashScreenRouterDelegate
    }
    
    func build(_ dependency: Dependency) -> UIViewController {
        let router = SplashScreenRouter()
        router.delegate = dependency.routerDelegate
        let viewModel = SplashScreenViewModel(
            router: router,
            userSession: dependency.userSession,
            networkMonitoring: dependency.networkMonitoring
        )
        let viewController = SplashScreenViewController(output: viewModel)
        return viewController
    }
}
