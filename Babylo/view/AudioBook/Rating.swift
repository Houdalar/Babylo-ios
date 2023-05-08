import SwiftUI
import Cosmos


struct CosmosRatingView: UIViewRepresentable {
    @Binding var rating: Double

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> Cosmos.CosmosView {
        let cosmosView = Cosmos.CosmosView()
        cosmosView.settings.fillMode = .precise
        cosmosView.rating = rating
        cosmosView.settings.starSize = 30
        cosmosView.settings.starMargin = 10
        cosmosView.settings.updateOnTouch = true
        cosmosView.settings.filledImage = UIImage(named: "GoldStar")
        cosmosView.settings.emptyImage = UIImage(named: "GoldStarEmpty")

       

        cosmosView.didTouchCosmos = { rating in
            self.rating = rating
        }
        return cosmosView
    }

    func updateUIView(_ uiView: Cosmos.CosmosView, context: Context) {
        uiView.rating = rating
    }

    class Coordinator: NSObject {
        var cosmosRatingView: CosmosRatingView

        init(_ cosmosRatingView: CosmosRatingView) {
            self.cosmosRatingView = cosmosRatingView
        }
    }
}
