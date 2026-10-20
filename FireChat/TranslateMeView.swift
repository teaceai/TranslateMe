import SwiftUI
import FirebaseFirestore

struct TranslateMeView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var selectedLanguage: String = "es"
    @State private var isLoading: Bool = false
    @State private var showCopiedAlert: Bool = false
    private let db = Firestore.firestore()

    let languages = [
        ("Spanish", "es"),
        ("French", "fr"),
        ("German", "de"),
        ("Italian", "it")
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                // Bonus 1: Target Language Picker
                Picker("Target Language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.1) { name, code in
                        Text(name).tag(code)
                    }
                }
                .pickerStyle(.segmented)

                TextField("Enter text", text: $inputText)
                    .textFieldStyle(.roundedBorder)

                Button {
                    Task {
                        await translateAndSave()
                    }
                } label: {
                    Text(isLoading ? "Translating..." : "Translate Me")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)

                // Translation Result Container
                VStack(alignment: .leading) {
                    HStack {
                        Text(translatedText)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Bonus 2: Copy to Clipboard
                        if !translatedText.isEmpty {
                            Button {
                                UIPasteboard.general.string = translatedText
                                showCopiedAlert = true
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 1.5)
                )

                HStack {
                    Spacer()
                    NavigationLink("View Saved Translations") {
                        SavedTranslationsView()
                    }
                    Spacer()
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationTitle("Translate Me")
            .navigationBarTitleDisplayMode(.large)
            .alert("Copied!", isPresented: $showCopiedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Translated text copied to clipboard.")
            }
        }
    }

    private func translateAndSave() async {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        guard let encodedQuery = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.mymemory.translated.net/get?q=\(encodedQuery)&langpair=en|\(selectedLanguage)") else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
            let resultText = decoded.responseData.translatedText

            await MainActor.run {
                self.translatedText = resultText
            }

            let newTranslation = Translation(
                originalText: trimmed,
                translatedText: resultText,
                timestamp: Date()
            )
            try db.collection("translations").addDocument(from: newTranslation)
        } catch {
            print("Translation error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TranslateMeView()
}
