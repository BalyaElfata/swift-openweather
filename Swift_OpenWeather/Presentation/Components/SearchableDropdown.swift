import SwiftUI

enum DropdownType {
    case city, province
}

struct SearchableDropdown: View {
    @State private var isExpanded = false
    @EnvironmentObject var viewModel: FormViewModel
    var type: DropdownType
    var options: [String]
    
    var filteredOptions: [String] {
        if viewModel.searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.lowercased().contains(viewModel.searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    if type == .city {
                        Text(viewModel.selectedCity)
                    } else {
                        Text(viewModel.selectedProvince)
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            if isExpanded {
                VStack {
                    TextField("Search...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    ForEach(filteredOptions, id: \.self) { option in
                        Text(option)
                            .padding()
                            .onTapGesture {
                                if type == .province {
                                    viewModel.selectedProvince = option
                                } else {
                                    viewModel.selectedCity = option
                                }
                                isExpanded = false
                            }
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
            }
        }
        .padding()
    }
}
#Preview {
    SearchableDropdown(type: .province, options: FormViewModel().provinces)
        .environmentObject(FormViewModel())
}
