//
//  Encryption.swift
//  Sevenchats
//
//  Created by nagaraju k on 04/08/22.
//  Copyright © 2022 mac-00020. All rights reserved.
//

import Foundation

var emptyArr = [Int]()
var emptyArr2 = [Int]()
var globalVal = [Int]()
var globalVal2 = [Int]()
var mappedInfo = [Int]()
var string1 = ""
var intvalu = [Int]()
var unit_Code2 = [Int]()
var indexs:Int?
var indexresult = [Int]()
var globaltest = [Int]()
var globaltests = [Int]()
var appendMod1:Bool = false
var appendModVal: Int?
var hexavalues = ""
var hexaval = 0
var globaldecrypt = [Int]()
var globalFinaldecrypt = [Int]()
var gblFinaldecrypt = [String]()
var privateVal = [Int]()
var finalEncrypt = ""
var decrpytedHex = ""

class EncryptDecrypt: NSObject{
    
    
    var callback : ((String) -> Void)?
    var callbackFolderCreate : ((String) -> Void)?
    
    private static var encryptDecrypt:EncryptDecrypt = {
        let encryptDecrypt = EncryptDecrypt()
        return encryptDecrypt
    }()
    static func shared() ->EncryptDecrypt {
        return encryptDecrypt
    }
    override init() {
        super.init()
    }
    
    func encryptDecryptModel(userResultStr:String) -> String{
        
        let  PRIVATE_KEY = "nallath cheythaal nallath kittum"
        let letters = PRIVATE_KEY.map { String($0) }
        let hexa = letters.map{String(format:"%02X", $0)}.joined(separator: " ")
        let numbers = letters
        var unitcode = [Int]()
        for data in numbers{
            let number:Int = Int(UnicodeScalar(data)!.value)
            print(number)
            unitcode.append(number)
            
        }
        string1 = userResultStr
        let numberSum = unitcode.reduce (0, { x, y in x ^ y})
        privateVal = [numberSum]
        for str in string1 {
            if str.isNumber{
                emptyArr.append(numberSum)
                let intConv:Int = Int(String(str)) ?? 0
                emptyArr.append(intConv)
                let ConverData = emptyArr.reduce (0, { x, y in x ^ y})
                globalVal.append(ConverData)
            }else {
                globalVal.append(numberSum)
            }
        }
        let baseStringConv = string1.map { String($0) }
        
        for str2 in baseStringConv{
            let numberConv:Int = Int(UnicodeScalar(str2)!.value)
            unit_Code2.append(numberConv)
            hexaval = numberConv
            globalFinaldecrypt.append(numberConv)
        }
        
        print("decimal value.......\(globalFinaldecrypt)")
        for data in globalFinaldecrypt{
            let xor = zip(privateVal, [data]).map {( $0 ^ $1)}
            print("XOR----------\(xor)")
            hexavalues = xor.map{String(format:"%02x", $0)}.joined(separator: "")
            print("FinalEcrypt--------------\(hexavalues)")
            finalEncrypt.append(hexavalues)
            
        }
        print("FinalEcryptHEX--------------\(finalEncrypt)")
        //MARK: -  DECRYPTION
        
        let final = finalEncrypt.inserting(separator: " ", every: 2)
        print("split HEX ---------- \(final)")
        let hexatoArr = final.components(separatedBy: " ")
        print("final---------\(hexatoArr)")
        for hextoDec in hexatoArr {
            if let Convalue = UInt8(hextoDec, radix: 16) {
                //print("converted\(Convalue)")
                globaldecrypt.append(Int(Convalue))
            }
        }
        
        print(globaldecrypt)
        
        for hexDecrpyt in globaldecrypt{
            let result = zip(privateVal, [hexDecrpyt]).map {( $0 ^ $1)}
            print("hexavaluesDecrpyt--\(result)")
            let convertUnr =  (Unicode.Scalar(result[0]))
            print("decrpytedHex--------------\(convertUnr)")
            
        }
        
        let result = zip(privateVal, globaldecrypt).map {( $0 ^ $1)}
        
        for decrypt in string1 {
            if decrypt.isNumber{
                print("decrypt\(decrypt)")
                if let i = string1.firstIndex(of: decrypt) {
                    indexs = string1.distance(from: string1.startIndex, to: i)
                    let numbers = 0...string1.count
                    for (word, number) in zip(result, numbers) {
                        if number == indexs{
                            let intConv:Int = Int(String(decrypt)) ?? 0
                            var appendVal = [Int]()
                            appendVal.append(word)
                            appendVal.append(intConv)
                            let final =  appendVal.reduce (0, { x, y in x ^ y})
                            let convertUnr =  (Unicode.Scalar(final))
                            gblFinaldecrypt.append((convertUnr)!.description)
                            print(convertUnr ?? 0)
                        }else {
                            let convertUnr =  (Unicode.Scalar(word))
                            gblFinaldecrypt.append((convertUnr)!.description)
                            print(convertUnr ?? 0)
                        }
                    }
                }
//                print("gblFinaldecrypt ;;;;;;;\(gblFinaldecrypt))")
                let stringRepresentation = gblFinaldecrypt.joined(separator: "")
//                print("stringRepresentation ;;;;;;;\(stringRepresentation))")
                
            }
            
        }
        return finalEncrypt
        
    }
    
}

extension String {
    func inserting(separator: String, every n: Int) -> String
    {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        
        return result
        
    } }
