import os
import UIKit

public class UnsplashImageView: UIImageView {

    // MARK: - Public properties

    @IBInspectable public var accessKey: String = ""
    @IBInspectable public var query: String = ""
    var imageURL: URL?

    // MARK: - Public functions

    public func fetchPhoto() {
        if let imageURL = imageURL {
            fetchImage(with: imageURL)
            return
        }

        guard photoDataTask == nil, let urlRequest = photoURLRequest() else { return }

        photoDataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }
            strongSelf.photoDataTask = nil

            if let error = error { return os_log("%@", log: .default, type: .error, error.localizedDescription) }
            guard let data = data, let imageURL = strongSelf.imageURL(from: data) else { return }

            strongSelf.imageURL = imageURL
            strongSelf.fetchImage(with: imageURL)
        }
        photoDataTask?.resume()
    }

    // MARK: - Private properties

    private var photoDataTask: URLSessionDataTask?
    private var imageDataTask: URLSessionDataTask?
    private let apiEndpoint = "https://api.unsplash.com/photos/random"
    private var screenScale: CGFloat { return window?.screen.scale ?? 2 }  // Default to 2x
    private static var cache = URLCache(memoryCapacity: 50.megabytes, diskCapacity: 100.megabytes, diskPath: "unsplash")

    // MARK: - Private functions

    private func fetchImage(with url: URL) {
        guard imageDataTask == nil else { return }

        if let cachedResponse = UnsplashImageView.cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {

            DispatchQueue.main.async {
                self.image = image
            }
            return
        }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            strongSelf.imageDataTask = nil

            if let error = error { return os_log("%@", log: .default, type: .error, error.localizedDescription) }
            guard let data = data, let response = response, let image = UIImage(data: data) else { return }

            let cachedResponse = CachedURLResponse(response: response, data: data)
            UnsplashImageView.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))

            DispatchQueue.main.async {
                UIView.transition(with: strongSelf, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.image = image
                }, completion: nil)
            }
        }
        imageDataTask?.resume()
    }

    private func photoURLRequest() -> URLRequest? {
        assert(accessKey.isEmpty == false, "The Unsplash API access key is missing.")
        guard var components = URLComponents(string: apiEndpoint) else { return nil }

        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")

        return request
    }

    private func imageURL(from data: Data) -> URL? {
        do {
            if
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let urls = jsonObject["urls"] as? [String: Any],
                let urlString = urls["full"] as? String,
                let url = URL(string: urlString) {
                return sizedImageURL(from: url)
            }
        } catch {
            os_log("%@", log: .default, type: .error, error.localizedDescription)
        }
        return nil
    }

    private func sizedImageURL(from url: URL) -> URL {
        var width: CGFloat = 0
        var height: CGFloat = 0

        DispatchQueue.main.sync {
            width = frame.width * screenScale
            height = frame.height * screenScale
        }

        return url.appending(queryItems: [
            URLQueryItem(name: "max-w", value: "\(width)"),
            URLQueryItem(name: "max-h", value: "\(height)")
            ])
    }

}

// MARK: - URL extension

private extension URL {

    func appending(queryItems: [URLQueryItem]) -> URL {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        var queryDictionary = [String: String]()
        if let queryItems = components.queryItems {
            for item in queryItems {
                queryDictionary[item.name] = item.value
            }
        }

        for item in queryItems {
            queryDictionary[item.name] = item.value
        }
        var newComponents = components
        newComponents.queryItems = queryDictionary.map({ URLQueryItem(name: $0.key, value: $0.value) })
        return newComponents.url ?? self
    }

}

// MARK: - Int extension

private extension Int {
    var megabytes: Int { return self * 1024 * 1024 }
}
