import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.on.doc.fill")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
            
            Text("PDF Combine & Stamp")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("A Quick Action for combining PDFs and adding Bates stamps")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("How to use:")
                    .font(.headline)
                
                HStack(alignment: .top, spacing: 8) {
                    Text("1.")
                        .fontWeight(.bold)
                    Text("Select one or more PDF or image files in Finder")
                }
                
                HStack(alignment: .top, spacing: 8) {
                    Text("2.")
                        .fontWeight(.bold)
                    Text("Right-click (or Control-click) on the selected files")
                }
                
                HStack(alignment: .top, spacing: 8) {
                    Text("3.")
                        .fontWeight(.bold)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Choose Quick Actions → Combine PDFs and Stamp")
                        Text("(or find it under Services → Combine PDFs and Stamp)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(alignment: .top, spacing: 8) {
                    Text("4.")
                        .fontWeight(.bold)
                    Text("Configure your Bates stamp options and click \"Combine and Stamp\"")
                }
            }
            .frame(maxWidth: 400, alignment: .leading)
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
            
            Text("The extension is active and ready to use!")
                .font(.caption)
                .foregroundColor(.green)
        }
        .padding(30)
        .frame(minWidth: 500, minHeight: 550)
    }
}

#Preview {
    ContentView()
}
