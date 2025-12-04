#include <iostream>
#include <string>
#include <cstdint>
#include <iomanip>
#include <sstream>

using namespace std;

void tea_encrypt(uint32_t v[2], uint32_t k[4]) {
    uint32_t y = v[0], z = v[1];
    uint32_t sum = 0;
    uint32_t delta = 0x9e3779b9;
    
    for (int i = 0; i < 32; i++) {
        sum += delta;
        y += ((z << 4) + k[0]) ^ (z + sum) ^ ((z >> 5) + k[1]);
        z += ((y << 4) + k[2]) ^ (y + sum) ^ ((y >> 5) + k[3]);
    }
    
    v[0] = y;
    v[1] = z;
}

uint32_t hexStringToUint32(const string& hexStr) {
    if (hexStr.length() > 8) {
        throw invalid_argument("Hex string too long for 32-bit value");
    }
    
    uint32_t value;
    stringstream ss;
    ss << hex << hexStr;
    ss >> value;
    
    if (ss.fail()) {
        throw invalid_argument("Invalid hex string");
    }
    
    return value;
}

string uint32ToHexString(uint32_t value) {
    stringstream ss;
    ss << hex << setw(8) << setfill('0') << value;
    return ss.str();
}

int main() {
    string msgHex, keyHex;
    bool validInput = false;
    
    while (!validInput) {
        cout << "Enter 64-bit message (16 hex characters): ";
        cin >> msgHex;
        
        if (msgHex.length() != 16) {
            cout << "Error: Message must be exactly 16 hex characters (got " << msgHex.length() << ")\n\n";
            continue;
        }
        
        validInput = true;
    }
    
    validInput = false;
    
    while (!validInput) {
        cout << "Enter 128-bit key (32 hex characters): ";
        cin >> keyHex;
        
        if (keyHex.length() != 32) {
            cout << "Error: Key must be exactly 32 hex characters (got " << keyHex.length() << ")\n\n";
            continue;
        }
        
        validInput = true;
    }
    
    try {
        uint32_t v[2];
        uint32_t k[4];
        
        v[0] = hexStringToUint32(msgHex.substr(0, 8));
        v[1] = hexStringToUint32(msgHex.substr(8, 8));
        
        k[0] = hexStringToUint32(keyHex.substr(0, 8));
        k[1] = hexStringToUint32(keyHex.substr(8, 8));
        k[2] = hexStringToUint32(keyHex.substr(16, 8));
        k[3] = hexStringToUint32(keyHex.substr(24, 8));
        
        uint32_t original_v[2] = {v[0], v[1]};
        uint32_t original_k[4] = {k[0], k[1], k[2], k[3]};

        tea_encrypt(v, k);

        string encryptedHex = uint32ToHexString(v[0]) + uint32ToHexString(v[1]);
        cout << "Encrypted message: " << encryptedHex << "\n";
        
    } catch (const exception& e) {
        cout << "Error: " << e.what() << "\n";
        return 1;
    }
    
    return 0;
}
