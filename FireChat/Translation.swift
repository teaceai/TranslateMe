import Foundation
import FirebaseFirestore

struct Translation: Identifiable, Codable {
    @DocumentID var id: String?
    let originalText: String
    let translatedText: String
    let timestamp: Date
}

struct MyMemoryResponse: Codable {
    let responseData: TranslationData
}

struct TranslationData: Codable {
    let translatedText: String
}
