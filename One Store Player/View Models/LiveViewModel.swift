//
//  LiveViewModel.swift
//  One Store Player
//
//  Created by MacBook Pro on 19/05/2023.
//

import Foundation
import SwiftUI
class LiveStreamsFavourite:ObservableObject
{
    func saveMovies(model:LiveStreams){
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favLiveStreams.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favLiveStreams = try decoder.decode([LiveStreams].self, from: data)
                
                if favLiveStreams.contains(where: {$0.streamID == model.streamID}) {
                    return
                }else{
                    favLiveStreams.append(model)
                    
                    let encoder = JSONEncoder()
                    // Encode Note
                    let modelData = try encoder.encode(favLiveStreams)
                    
                    UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favLiveStreams.rawValue)
                    UserDefaults.standard.synchronize()
                    
                }
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
            
        }
        else{
            do{
                let encoder = JSONEncoder()
                // Encode Note
                
                let modelData = try encoder.encode([model])
                UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favLiveStreams.rawValue)
                UserDefaults.standard.synchronize()
            }
            catch {
                debugPrint(error)
            }
            
            //return model
        }
    }
    
    func findItem(model:LiveStreams)->Bool{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favLiveStreams.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let favLiveStreams = try decoder.decode([LiveStreams].self, from: data)
                
                if favLiveStreams.contains(where: {$0.streamID == model.streamID}) {
                    if let _ = favLiveStreams.firstIndex(where: {$0.streamID == model.streamID}) {
                        return true
                    }
                    
                    return false
                }
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }

        }
        return false
    }
    
    func deleteObject(model:LiveStreams) {
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favLiveStreams.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favLiveStreams = try decoder.decode([LiveStreams].self, from: data)
                
                if favLiveStreams.contains(where: {$0.streamID == model.streamID}) {
                    if let inde = favLiveStreams.firstIndex(where: {$0.streamID == model.streamID}) {
                        favLiveStreams.remove(at: inde)
                        let encoder = JSONEncoder()
                            // Encode Note
                        let modelData = try encoder.encode(favLiveStreams)

                        UserDefaults.standard.set(modelData, forKey: AppStorageKeys.favLiveStreams.rawValue)
                        UserDefaults.standard.synchronize()
                    }
                    
                    return
                }
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }

        }
    }
    
    func getLiveStreams()->[LiveStreams]{
        if let data = UserDefaults.standard.value(forKey: AppStorageKeys.favLiveStreams.rawValue) as? Data {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                var favLiveStreams = try decoder.decode([LiveStreams].self, from: data)
                
                return favLiveStreams
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
            
        }
        return []
    }
}
