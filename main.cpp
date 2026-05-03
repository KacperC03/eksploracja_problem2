#include <iostream>
#include <chrono>

// Podłączamy nasz kombajn
#include "fp-growth.cpp"

int main() {
    std::cout << "=== START ALGORYTMU ===" << std::endl;

    AssociationRuleMiner miner; 
    auto start_time = std::chrono::high_resolution_clock::now();

    // Szukamy reguł: wsparcie 2% (0.02), pewność 50% (0.5)
    auto rules = miner.solve(0.02, 0.2, true); 

    auto end_time = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end_time - start_time;

    std::cout << "\n--- WYNIKI (Max 10 pierwszych) ---" << std::endl;
    int limit = std::min(10, (int)rules.size());
    for (int i = 0; i < limit; ++i) {
        const auto& rule = rules[i];
        std::cout << "{ ";
        for (const auto& a : rule.A) std::cout << a << " ";
        std::cout << "} => { ";
        for (const auto& b : rule.B) std::cout << b << " ";
        std::cout << "} (Wsparcie: " << rule.support 
                  << ", Pewnosc: " << rule.confidence * 100 << "%)\n";
    }
    
    std::cout << "===============================" << std::endl;
    std::cout << "Czas wykonania: " << elapsed.count() << " s." << std::endl;
    
    return 0;
}