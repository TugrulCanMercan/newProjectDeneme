//
//  ContentView.swift
//  EnglishTinder
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 13.06.2022.
//

import SwiftUI
import Combine

struct EnglishToTurkishWord:Hashable {
    let english:String
    let turkish:String
}

class EnglishTinderViewModel:ObservableObject {
    @Published var data = [EnglishToTurkishWord(english: "tugrul", turkish: "mercan"),
                           EnglishToTurkishWord(english: "tolga", turkish: "nafiye")]
    @Published var checkPopUp = false
    var cancellable = Set<AnyCancellable>()
    init(){
        $data.map({ dataList in
            dataList.isEmpty ? false : true
        })
        .filter { check in
            check == false
        }
        .sink { checkRequest in
            print("istek at")
        }
        .store(in: &cancellable)
        
        $checkPopUp
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] check in
                guard let self = self else { return }
                self.checkPopUp = false
            }
            .store(in: &cancellable)
    }
}

struct ContentView: View {
    
    @StateObject var englishTinderVM = EnglishTinderViewModel()
    @State var popUpShowCheck = false
    var body: some View {
        VStack(alignment: .center){
            GeometryReader { geometry in
                HStack {
                    animationnPopUp()
                        .frame(width: geometry.size.width / 2,
                               height: 75,
                               alignment: .top)
                }
                .frame(maxWidth: .infinity)
                .padding()
                ForEach(englishTinderVM.data.indices,id:\.self) { idx in
                    VStack(alignment: .leading) {
                        CardView(selectionCard: englishTinderVM.data[idx])
                            .environmentObject(englishTinderVM)
                            .animation(.spring(),value: idx)
                            .frame(width: self.getCardWidth(geometry, id: idx), height: 400)
                            .offset(x: 0, y: self.getCardOffset(geometry, id: idx))
                        
                    }
                }
            }
        }
    }
    
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(englishTinderVM.data.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(englishTinderVM.data.count - 1 - id) * 10
    }
    private func animationnPopUp() -> some View {
        VStack {
            if popUpShowCheck {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(lineWidth: 8)
                    .overlay {
                        Text("Sol")
                            .foregroundColor(.red)
                            .font(.title)
                            .bold()
                        
                    }
                    .background(LinearGradient(colors: [Color.purple,
                                                        Color.yellow,
                                                        Color.green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundColor(.red)
            }

        }
        .onReceive(englishTinderVM.$checkPopUp) { check in
            withAnimation {
                popUpShowCheck = check
            }
        }
        
    }
    
    
}
struct CardView:View {
    @EnvironmentObject var vm: EnglishTinderViewModel
    @State var selectionCard:EnglishToTurkishWord
    @State private var translation: CGSize = .zero
    private var thresholdPercentage: CGFloat = 0.5
    private var leftSwipeLimit: CGFloat = -0.5
    private var rightSwipeLimit: CGFloat = 0.5
    
    init(selectionCard:EnglishToTurkishWord){
        self.selectionCard = selectionCard
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                
                Text(selectionCard.english.capitalized)
                    .font(.title)
                    .bold()
                Text(selectionCard.turkish.capitalized)
                    .font(.subheadline)
                    .bold()
                Text("13 Mutual Friends")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack {
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.purple)
                            .overlay {
                                Text("Listeye Ekle")
                                    .foregroundColor(.white)
                            }
                        
                    }
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .overlay {
                                Text("Arkadaşına sor")
                                    .foregroundColor(.white)
                            }
                    }
                    
                }
                .frame(maxHeight: 40)
                .padding()
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: geometry.size.height / 2)
            .background(Color.yellow)
            .cornerRadius(10)
            .shadow(radius: 5)
            .offset(x: self.translation.width, y: self.translation.height)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                    }.onEnded { value in
                        withAnimation(.interactiveSpring()) {
                            if self.getGesturePercentage(geometry, from: value) <= leftSwipeLimit {
                                print("sol")
                                vm.checkPopUp = true
                                vm.data.popLast()
                            } else if self.getGesturePercentage(geometry, from: value) >= rightSwipeLimit {
                                print("sağ")
                                vm.data.popLast()
                            } else {
                                self.translation = .zero
                            }
                            
                        }
                    }
            )
            .offset(y: geometry.size.height / 3)
            .padding()
        }
    }
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        print("gesture.translation.width\(gesture.translation.width)")
        print("geometry.size.width\(geometry.size.width)")
        return gesture.translation.width / geometry.size.width
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static func randomColor() -> Self? {
        let randomColorList: [Color] = [Color.pink,
                                        Color.blue,
                                        Color.purple,
                                        Color.yellow
        ]
        return randomColorList.randomElement()
    }
}
