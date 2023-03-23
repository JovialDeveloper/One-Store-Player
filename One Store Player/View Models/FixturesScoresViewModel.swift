//
//  FixturesScoresViewModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 03/12/2022.
//

import Foundation
import Combine

extension FixturesScoresView{
    class FixturesScoresViewModel:ObservableObject{
        var storeAble = [AnyCancellable]()
        @Published var model : Fixtures_ScoresModel?
        @Published var isLoading = false
        func fetchFixtures_Scores() -> AnyPublisher<[Fixtures_ScoresModel], APIError>
        {
            let uri = "https://api.1store.ae/users/8c094a6b-597b-4564-8bd7-e1a541805def/fixtures?time=2022-09-14&time_zone=Africa/Casablanca"
            
            //"https://api.1store.ae/users/8c094a6b-597b-4564-8bd7-e1a541805def/fixtures?time=2022-09-14&time_zone=Africa/Casablanca"
            
            return Networking.shared.fetch(uri: uri)
        }
        private var semaphore = DispatchSemaphore (value: 0)

        func fetchData(time:String){
            DispatchQueue.main.async {
                self.isLoading = true
            }
            var request = URLRequest(url: URL(string: "https://api.1store.ae/users/8c094a6b-597b-4564-8bd7-e1a541805def/fixtures?time=\(time)&time_zone=Africa/Casablanca")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5Njc0MTU1OC0yZGZhLTQ4ODktYjI2MS0xYTBmMmZiOWE1YTgiLCJqdGkiOiIyMGNlYTZkOGEyYWVjOTI2Y2FlMjU0NzhkMTRjYzcyMjgyOWU0Zjc5OGQyZmZjZGUwNTlmMTgxMWQ4YjkyMzdlMDNhMDc2NjE0NzMyZmI5MSIsImlhdCI6MTY3MDA4MTU2OS41MzMwODcsIm5iZiI6MTY3MDA4MTU2OS41MzMxMDEsImV4cCI6MTcwMTYxNzU2OS41Mjc0OCwic3ViIjoiIiwic2NvcGVzIjpbXX0.M-is7GR8Ub2YCuKGkl48_621iSXBT64gWi6dMyG6st1c_T2hTCa-f3cGAGuOypZ5dkZ7Nd4dMDHPO5p1QzMsra7BhYUYPezX1kQS0IJSQRxDlxj8slY93gwIzRXXkgO4sT5k3dOn7NYO4QYzZ3JT_8pYmHs2EM-LYgSXtJcSTtJjMosXZHpC4nv3NqcaOBWBnpEadFTTD1VLSwDeiFMEAGa79DF2IJnKz3bsSE_1DMNdBn9WW7Uo1F8uq_cXDZX_hMLC6INCNAt_17nFxd9gGbHDnlEnec84xcDzTTfTcZcIMZpO4009fPPakSLINzVOfufu5GYGekQpP-aAQLbZCmCBbDjwdNAp-Cq5__UXFhNQzgmHAuNMAPyQHEx_KENCWxhtzOKHXEW5SX77HP6vknwixHsLtmdpqApZk7D_zQr0Jw5ueI8OB_mi_dM-UFFMHrIYKsPhU0NyPLELF6Rna6RJVMrWV5mTQCt0FYQiwx4X7OJn9fhILQ1OyPMb3pgCJhhY_Tcn3ERPEaWpQItMV4OM2yTIOq7lUwxfoVDAMgnl2yXWnz4RWHt0YhGZdspcEdBwayRIsZN_vrfLWwfyhsBSeQk5k9yAYfqOTmXqXoRAKIpiL_A4xotjqsOsnzbpQJpvS8_txEJz9T4B70RabZYvwF_FXH3m8aO_pyj53SU", forHTTPHeaderField: "Authorization")

            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
              guard let data = data else {
                print(String(describing: error))
                  DispatchQueue.main.async {
                      self.isLoading = false
                  }
                  
                  self.semaphore.signal()
                return
              }
                
                do{
                    let js = try JSONDecoder().decode(Fixtures_ScoresModel.self, from: data)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if self.model != nil {
                            self.model = nil
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                self.model = js
                            }
                        }else {
                            self.model = js
                        }
                    }
                    
                }
                catch {
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    debugPrint("Decode Error",error)
                }
                
                self.semaphore.signal()
            }

            task.resume()
            semaphore.wait()

        }
    }
}
