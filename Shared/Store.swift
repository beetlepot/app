import StoreKit
import UserNotifications
import Combine
import Secrets

struct Store {
    let status = CurrentValueSubject<Status, Never>(.loading)
    
    init() {
        Task
            .detached {
                for await result in Transaction.updates {
                    if case let .verified(safe) = result {
                        await safe.process()
                    }
                }
            }
    }
    
    @MainActor func load() async {
        do {
            let products = try await Product.products(for: Purchase.allCases.map(\.rawValue))
            status.send(
                .products(
                    products
                        .sorted {
                            $0.price < $1.price
                        }))
        } catch let error {
            status.send(.error("Unable to connect to the App Store.\n" + error.localizedDescription))
        }
    }
    
    @MainActor func purchase(_ product: Product) async {
        status.send(.loading)
        
        do {
            switch try await product.purchase() {
            case let .success(verification):
                if case let .verified(safe) = verification {
                    await safe.process()
                    await load()
                } else {
                    status.send(.error("Purchase verification failed."))
                }
            case .pending:
                await load()
                await UNUserNotificationCenter.send(message: "Purchase is pending...")
            default:
                await load()
            }
        } catch let error {
            status.send(.error(error.localizedDescription))
        }
    }
}
