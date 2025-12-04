#include <iostream>
#include <fstream>
#include <string>
#include <cstdint>
#include <iomanip>
#include <cstdlib>
#include <ctime>

using namespace std;

void tea(uint32_t v[2], uint32_t k[4]) {
    uint32_t y = v[0], z = v[1];
    uint32_t sum = 0;
    uint32_t delta = 0x9e3779b9;
    uint32_t n = 32;
    
    for (int round = 0; round < 32; round++) {
        sum += delta;
        y += ((z << 4) + k[0]) ^ (z + sum) ^ ((z >> 5) + k[1]);
        z += ((y << 4) + k[2]) ^ (y + sum) ^ ((y >> 5) + k[3]);
    }
    
    v[0] = y;
    v[1] = z;
}

// Функция для генерации случайного 32-битного числа
uint32_t generateRandom32() {
    return (rand() << 16) ^ rand();
}

// Функция для преобразования uint32_t в бинарную строку заданной длины
string uint32ToBinary(uint32_t value, int bits = 32) {
    string binary;
    for (int i = bits - 1; i >= 0; i--) {
        binary += ((value >> i) & 1) ? '1' : '0';
    }
    return binary;
}

int main() {
    srand(time(nullptr));
    
    ofstream outFile("iter_sequence.tv");
    
    if (!outFile) {
        cerr << "Error: Cannot open output file!\n";
        return 1;
    }
    
    for (int testNum = 0; testNum < 100; testNum++) {
        uint32_t v[2];
        v[0] = generateRandom32();
        v[1] = generateRandom32();
        
        uint32_t k[4];
        k[0] = generateRandom32();
        k[1] = generateRandom32();
        k[2] = generateRandom32();
        k[3] = generateRandom32();
        
        uint32_t v_encrypt[2] = {v[0], v[1]};
        
        tea(v_encrypt, k);
        
        string input_str = uint32ToBinary(v[0]) + uint32ToBinary(v[1]);
        string key_str = uint32ToBinary(k[0]) + uint32ToBinary(k[1]) + uint32ToBinary(k[2]) + uint32ToBinary(k[3]);
        string output_str = uint32ToBinary(v_encrypt[0]) + uint32ToBinary(v_encrypt[1]);
        
        outFile << input_str << "_" << key_str << "_" << output_str << endl;
    }
    
    outFile.close();    
    return 0;
}