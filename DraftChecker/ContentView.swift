//
//  ContentView.swift
//  DraftChecker
//
//  Created by 松本幸太郎 on 2022/11/21.
//

import SwiftUI
import Combine
import OrderedCollections

struct ContentView: View {
    //gitのリモート管理テスト
    @State var draft: String = ""
    @State var attriDraft: AttributedString = ""
    @State var attriDraft1: AttributedString = ""
    
    @State var usedwords: OrderedDictionary<String,Int> = [:]//使用単語と使用回数
    @State var usedwordsKeysAndValues:String = ""
    
    @State var wordlist = Wordlist(color: .red)
    @State var wordlist1 = Wordlist(color: .green)
    @State var wordlist2 = Wordlist(color: .yellow)
    @State var wordlist3 = Wordlist(color: .blue)
    
    
    var body: some View {
        HStack {
            VStack {
                Text("重複なし結果").font(.headline)
                ScrollView{
                    //textEditorで特定の文字をハイライトするのは難しそうなので、表示用のTextを用意し、そこにAttributedStringを渡す。
                    
                    Text(attriDraft)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        
                }.textSelection(.enabled)
                
            }
            
            Divider()
            
            VStack {
                Text("重複あり結果").font(.headline)
                ScrollView{
                    //textEditorで特定の文字をハイライトするのは難しそうなので、表示用のTextを用意し、そこにAttributedStringを渡す。
                    
                    Text(attriDraft1)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        
                        
                }.textSelection(.enabled)
                
            }
            Divider()
            
            VStack {
                Text("原稿").font(.headline)
                
                TextEditor(text: $draft)
                    .onChange(of: draft) { draft in
                        attriDraft = AttributedString(draft)
                        attriDraft1 = AttributedString(draft)
                    }.frame(minWidth: 250,maxHeight: 100)
                    
                    
                   
                
                Divider() .frame(minWidth: 250)
                
                HStack {
                    VStack {
                        Text("使用した単語")
                            .font(.headline)
                    
                        ScrollView{
                            Text(usedwordsKeysAndValues)
                                .frame( maxWidth: .infinity,  alignment: .leading)
                            
                            
                        }.frame(minHeight:110)
                            .textSelection(.enabled)
                        
                    }.frame(width: 200)
                    
                    Divider()
                    
                    VStack{
                        Text("検索ワード").font(.headline).frame(minWidth: 90)
                        ScrollView {
                            //単語リスト1
                            HStack {
                                TextEditor(text: $wordlist.words)
                                    .frame(minWidth: 90, idealHeight: 90)
                                Text(String(wordlist.count))
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(wordlist.color)
                                    .frame(width: 30)
                                
                            }
                            //単語リスト2
                            HStack {
                                TextEditor(text: $wordlist1.words)
                                    .frame(minWidth: 90, idealHeight: 90)
                                Text(String(wordlist1.count))
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(wordlist1.color)
                                    .frame(width: 30)
                                
                            }
                            //単語リスト3
                            HStack {
                                TextEditor(text: $wordlist2.words)
                                    .frame(minWidth: 90, idealHeight: 90)
                                Text(String(wordlist2.count))
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(wordlist2.color)
                                    .frame(width: 30)
                                
                            }
                            //単語リスト4
                            HStack {
                                TextEditor(text: $wordlist3.words)
                                    .frame(minWidth: 90, idealHeight: 90)
                                Text(String(wordlist3.count))
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(wordlist3.color)
                                    .frame(width: 30)
                                
                                
                            }
                            
                        }
                        Divider()
                            .frame(minWidth: 120)
                        Button(action: buttonAction){
                            HStack{
                                Image(systemName: "magnifyingglass")
                                Text("検索").font(.body).fontWeight(.semibold)
                            }
                        }
                        .frame(width: 65)
                        .controlSize(.large)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .blue, radius: 2)
                        .padding(.all)
                             }
                    }
            }
                }.frame(minHeight:300).padding(.all)
        
            
        }
    
    
    func buttonAction() -> Void{
        usedwords.removeAll()
        usedwordsKeysAndValues = ""
        
        wordlist.count = getDraftAttributed(wordlist)
        wordlist1.count = getDraftAttributed(wordlist1)
        wordlist2.count = getDraftAttributed(wordlist2)
        wordlist3.count = getDraftAttributed(wordlist3)
        
        getDraftAttributed1(wordlist)
        getDraftAttributed1(wordlist1)
        getDraftAttributed1(wordlist2)
        getDraftAttributed1(wordlist3)
        
        for (key, value) in usedwords {
            usedwordsKeysAndValues += "\(value)回\t\t\(key)\n"
        }
    }
    
    func getDraftAttributed(_ wordlist: Wordlist ) -> Int {
        var myCount:Int = 0
        let myWords = wordlist.words.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let myWordlist: [String] = myWords.components(separatedBy: "、")
        myWordlist.forEach {
            //ここでwordListの要素を一つずつハイライト
            if let range = attriDraft.range(of: $0) {
                myCount += 1
                
                attriDraft[range].foregroundColor = wordlist.color
                attriDraft[range].font = .system(size: 17, weight: .bold)
            }
        }
        return myCount
    }
    
    //重複をすべてハイライトする関数
    func getDraftAttributed1(_ wordlist: Wordlist ) -> Void {
        let myWords = wordlist.words.trimmingCharacters(in: .whitespacesAndNewlines)
        let myWordlist: [String] = myWords.components(separatedBy: "、")
        myWordlist.forEach {
            let ranges = attriDraft1.ranges(of: $0)
            for range in ranges {
                attriDraft1[range].foregroundColor = wordlist.color
                if usedwords[$0] != nil {
                    usedwords[$0]! += 1
                }else{
                    usedwords[$0] = 1
                }
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
    }
}
