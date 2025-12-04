#include <iostream>
#include <fstream>
#include <string>
#include <cstdint>
#include <iomanip>
#include <sstream>
#include <cstdlib>
#include <ctime>

using namespace std;

void tea_round(uint32_t& y, uint32_t& z, uint32_t sum, uint32_t k[4]) {
    y += ((z << 4) + k[0]) ^ (z + sum) ^ ((z >> 5) + k[1]);
    z += ((y << 4) + k[2]) ^ (y + sum) ^ ((y >> 5) + k[3]);
}

uint32_t generateRandom32() {
    return (rand() << 16) ^ rand();
}

string uint32ToBinary(uint32_t value, int bits = 32) {
    string binary;
    for (int i = bits - 1; i >= 0; i--) {
        binary += ((value >> i) & 1) ? '1' : '0';
    }
    return binary;
}

void generate_round_test_vector(ofstream& outFile, int testNum, int roundNum, uint32_t y_in, uint32_t z_in, uint32_t sum, uint32_t k[4], uint32_t y_out, uint32_t z_out) {
    
    string input_str = uint32ToBinary(y_in) + uint32ToBinary(z_in);
    string sum_str = uint32ToBinary(sum);
    string key_str = uint32ToBinary(k[0]) + uint32ToBinary(k[1]) + uint32ToBinary(k[2]) + uint32ToBinary(k[3]);
    string output_str = uint32ToBinary(y_out) + uint32ToBinary(z_out);
    
    outFile << input_str << "_" << sum_str << "_" << key_str << "_" << output_str << endl;
}

int main() {
    srand(time(nullptr));
    
    ofstream outFile("round_sequence.tv");
    
    if (!outFile) {
        cerr << "Error: Cannot open output file!" << endl;
        return 1;
    }
    
    cout << "Generating test vectors for TEA round module...\n";
    
    const uint32_t delta = 0x9e3779b9;
    int vector_count = 0;
    
    for (int testNum = 0; testNum < 100; testNum++) {
        uint32_t y_in = generateRandom32();
        uint32_t z_in = generateRandom32();
        
        uint32_t k[4];
        k[0] = generateRandom32();
        k[1] = generateRandom32();
        k[2] = generateRandom32();
        k[3] = generateRandom32();
        
        uint32_t y = y_in;
        uint32_t z = z_in;
        uint32_t sum = 0;
        
        for (int roundNum = 0; roundNum < 32; roundNum++) {
            sum += delta;
            
            uint32_t y_before = y;
            uint32_t z_before = z;
            uint32_t sum_for_round = sum;
            
            tea_round(y, z, sum_for_round, k);
            
            generate_round_test_vector(outFile, testNum, roundNum, y_before, z_before, sum_for_round, k, y, z);
            vector_count++;
            
            if (vector_count >= 100) break;
        }
        
        if (vector_count >= 100) break;
    }
    
    outFile.close();
      
    return 0;
}