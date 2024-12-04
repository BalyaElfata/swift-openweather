import SwiftUI

enum DropdownType {
    case city, province
}

struct CustomPicker: View {
    @EnvironmentObject var viewModel: FormViewModel
    var type: DropdownType
    var options: [String] = []
    
    var filteredOptions: [String] {
        if viewModel.searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.lowercased().contains(viewModel.searchText.lowercased()) }
        }
    }
    
    var body: some View {
        Button {
            if type == .province {
                viewModel.isSelectingProvince = true
            } else {
                viewModel.isSelectingCity = true
            }
        } label: {
            VStack {
                HStack {
                    if type == .city {
                        Text(viewModel.selectedCity)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                    } else {
                        Text(viewModel.selectedProvince)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.primary)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary, lineWidth: 2)
                )
            }
        }
    }
}
#Preview {
    NavigationStack {
        CustomPicker(type: .province, options: FormViewModel().provinces.map { $0.name })
            .environmentObject(FormViewModel())
    }
}
