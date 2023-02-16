//
//  NewStockView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/14.
//

import SwiftUI

struct StockFinancialView: View {
    var body: some View {
        ZStack{
            VStack {
                TitleView()
                Stockview()
            }
        }.background(Color.blue)
        .padding()
    }
}

struct TitleView: View {
    var body: some View {
        HStack {
            Image(systemName: "e.square")
                .foregroundColor(.red)
                .padding(.leading, 7)
                .padding(.vertical, 15)
            Text("TestData")
            ZStack {
                Rectangle().strokeBorder(.red).frame(width: 40, height: 25)
                Text("申购")
            }.foregroundColor(.red)
            Spacer()
        }
    }
}

struct Stockview:View {
    @State private var isShowingBottomView = false
    
    var body: some View {
        VStack {
            HStack {
                //Stock Title
                Text("中润申购")
                //Stock ID
                Text("123456")
                ZStack {
                    Text("・新股")
                }.foregroundColor(.red)
                Spacer()
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        self.isShowingBottomView.toggle()
                    }
                
            }.padding([.horizontal], 30)
            
            HStack{
                Text("发行价 100元")
                Spacer()
            }.padding(.top, -5)
            .padding(.leading, 30)
            .padding(.bottom, 5)

        }
        .background(BottomViewRepresentable().frame(width: 0, height: 0))
    }
}

struct StockFinancialView_Previews: PreviewProvider {
    static var previews: some View {
        StockFinancialView()
    }
}

class BottomViewController: UIViewController {
    let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.backgroundColor = .blue
        view.addSubview(bottomView)
    }
}

struct BottomViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BottomViewController {
        let controller = BottomViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: BottomViewController, context: Context) {
    }
    
    typealias UIViewControllerType = BottomViewController
}
