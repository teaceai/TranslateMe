import SwiftUI
import FirebaseFirestore

struct SavedTranslationsView: View {
    @State private var savedTranslations: [Translation] = []
    @State private var showClearConfirmation: Bool = false
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            List {
                ForEach(savedTranslations) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.originalText)
                            .font(.headline)
                        Text(item.translatedText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                // Bonus 3: Swipe to Delete Individual Translation
                .onDelete(perform: deleteTranslation)
            }
            .listStyle(.plain)

            // Bonus 4: Confirmation Alert Before Clearing
            Button("Clear All Translations", role: .destructive) {
                showClearConfirmation = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding(.bottom, 20)
            .confirmationDialog(
                "Are you sure you want to delete all saved translations?",
                isPresented: $showClearConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete All", role: .destructive) {
                    clearAll()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .onAppear {
            fetchTranslations()
        }
    }

    private func fetchTranslations() {
        db.collection("translations")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.savedTranslations = documents.compactMap { doc in
                    try? doc.data(as: Translation.self)
                }
            }
    }

    private func deleteTranslation(at offsets: IndexSet) {
        for index in offsets {
            let item = savedTranslations[index]
            if let id = item.id {
                db.collection("translations").document(id).delete()
            }
        }
    }

    private func clearAll() {
        db.collection("translations").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let batch = db.batch()
            for doc in documents {
                batch.deleteDocument(doc.reference)
            }
            batch.commit()
        }
    }
}

#Preview {
    NavigationStack {
        SavedTranslationsView()
    }
}
