#include <iostream>
#include <fstream>
#include <string>

int main(int argc, char const *argv[])
{
    if (argc != 3)
    {
        std::cout << "Invalid arguments." << std::endl;
        exit(1);
    }

    std::string binPath = argv[1];
    std::string coePath = argv[2];
    std::ifstream ifs(binPath, std::ios::in | std::ios::binary);
    std::ofstream ofs(coePath, std::ios::out);
    char buffer[4];

    if (!ifs)
    {
        std::cout << "Fail to open file: " << binPath << std::endl;
    }
    if (!ofs)
    {
        std::cout << "Fail to open file: " << coePath << std::endl;
    }

    ofs << "memory_initialization_radix = 16;" << std::endl;
    ofs << "memory_initialization_vector =" << std::endl;

    while (ifs.read(buffer, sizeof(buffer)))
    {
        for (int i = 0; i < 4; ++i)
        {
            char hi = buffer[i] >> 4 & 0xf;
            char lo = buffer[i] & 0xf;
            if (hi < 10) hi += '0'; else hi += 'a' - 10;
            if (lo < 10) lo += '0'; else lo += 'a' - 10;
            ofs << hi << lo;
        }
        ofs << std::endl;
    }

    ofs << ';';

    return 0;
}
