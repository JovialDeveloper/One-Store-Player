//
//  EPGLiveView.swift
//  One Store Player
//
//  Created by MacBook Pro on 16/12/2022.
//

import SwiftUI
import XMLMapper
import ToastUI
struct EPGLiveView: View {
    let columns : [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    //@Binding var data : [MovieCategoriesModel]
    @StateObject private var vm = EPGLiveViewModel()
    var queue = DispatchQueue.global()
    var body: some View {
        ZStack{
            Color.primaryColor.ignoresSafeArea()
            VStack{
                NavigationHeaderView(title: "EPG Live",isHideOptions: true)
                if vm.namesTitle.isEmpty {
                    Text("Loading....")
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .font(.carioBold)
                        .foregroundColor(.white)
                }else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(vm.namesTitle, id: \.id) { item in
                                EPGRowCell(data: item.displayName)
                            }
                        }
                    }
                }
                
            }
            
            
        }.onAppear {
            queue.async {
                vm.parseData()
            }
        }
    }
}

extension EPGLiveView {
    
    struct EPGRowCell:View{
        let data:String
        @State var isToastToggle = false
        var body: some View{
            HStack{
                // Logo
                Image("tv")
                    .resizable()
                    .frame(width:40,height: 40)
                    .scaledToFill()
                    .foregroundColor(.white)
                Spacer()
                
                Text(data)
                    .font(.carioBold)
                    .padding()
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .foregroundColor(.white)
                Spacer()
                
                
                
                Spacer()
                // Users Catalog
                Text("")
                    .font(.carioBold)
                    .foregroundColor(.white)
                
                HStack{
                    Button {
                        isToastToggle.toggle()
                    } label: {
                        Image("arrow_right")
                            .resizable()
                            .frame(width:30,height: 30)
                            .scaledToFill()
                            .foregroundColor(.white)
                    }
                    .frame(width:40,height: 40)
                }
                
            }
            .padding()
            .frame(maxWidth:.infinity,maxHeight: 60)
            .background(RoundedRectangle(cornerRadius: 2).fill(Color.secondaryColor))
            .toast(isPresented: $isToastToggle) {
                ToastView("No Program Available")
                    .toastViewStyle(.failure)
            }
        }
    }
    
    class EPGLiveViewModel:NSObject,ObservableObject,XMLParserDelegate{
        @Published var namesTitle = [ChannelInfo]()
        func parseData(){
            //var semaphore = DispatchSemaphore (value: 0)
            guard let info = Networking.shared.getUserDetails() else {
                return
            }
            var request = URLRequest(url: URL(string: "\(info.port)xmltv.php?username=\(info.username)&password=\(info.password)")!,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    //semaphore.signal()
                    return
                }
                do {
                    let dic = try XMLSerialization.xmlObject(with: data,options: [.default, .cdataAsString]) as! [String:Any]
                    
                    let channelDic = dic["channel"] as! [[String:Any]]
                    var temp = [ChannelInfo]()
                    for i in channelDic {
                        let displayName = i["display-name"] as! String
                        temp.append(.init(displayName: displayName))
                    }
                    DispatchQueue.main.async {
                        self.namesTitle = temp
                    }
                    


                }catch {
                    print(error)
                }
                
//                let parser = XMLParser(data: data)
//
//
//                //setting delegate
//                parser.delegate = self
//
//                //call the method to parse
//                var result: Bool? = parser.parse()
//
//
//                parser.shouldResolveExternalEntities = true
                //semaphore.signal()
            }
            
            task.resume()
            //semaphore.wait()
        }
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            print(attributeDict)
            print("CurrentElementl: [\(elementName)]")
        }
    }
}

struct ChannelInfo:Identifiable{
    var id = UUID().uuidString
    var displayName: String

//    required init?(map: XMLMap) {}
//
//    func mapping(map: XMLMap) {
//        displayName <- map.attributes["display-name"]
//    }
}


//struct EPGLiveView_Previews: PreviewProvider {
//    static var previews: some View {
//        EPGLiveView()
//    }
//}
/*
 {
     "__name" = channel;
     "__nodes_order" =     (
         "display-name",
         icon
     );
     "_id" = "caz.be";
     "display-name" = "VTM 4 HD";
     icon =     {
         "__name" = icon;
         "_src" = "http://s3.i3ns.net/portal/picon/2021-07/4e8abea4175a3b73d00f98947a6620fe.png";
     };
 }
 */
