#include <string>
#include <iostream>
#include <vector>
#include <fstream>
#include <unordered_map>
#include <typeinfo>
#include <algorithm>

struct organism {
	std::string sequence;
	int score;
};

const int CHUNK_SIZE = 4;
const int NUM_ELITES = 4;

std::string INPUT_FILE = "org.txt";
std::string ELITE_OUTPUT_FILE = "eliteOrg.txt";


// A vector of chunks, with each having identities that have their scores
static std::vector<std::unordered_map<std::string, std::vector<int>>> chunkScores;


int main(int argc, char* argv[]) {
	std::ifstream input(INPUT_FILE);

	char del1 = '\t';
	char  del2 = '\n';

	std::vector<organism> organisms;

	// Populate vector of organisms
	while (!input.eof()) {
		std::string line;
		std::getline(input, line);

		std::string sequence = line.substr(0, line.find(del1));
		std::string score = line.substr(line.find(del1) + 1, line.find(del2));

		if (sequence.compare("") == 0) break;

		organism curOrg;
		curOrg.sequence = sequence;
		curOrg.score = std::stoi(score);

		organisms.push_back(curOrg);
	}
	input.close();

	// For each organism
	for (auto curOrg : organisms) {
		// See if it's larger than what chunkScores can handle
		while (curOrg.sequence.length() / CHUNK_SIZE >= chunkScores.size()) {
			std::unordered_map<std::string, std::vector<int>> c;
			chunkScores.push_back(c);
		}

		// Look at each chunk in it
		for (int i = 0; i < curOrg.sequence.length(); i += CHUNK_SIZE) {
			std::string chunkId = "";

			if (i + CHUNK_SIZE <= curOrg.sequence.length()) {
				chunkId = curOrg.sequence.substr(i, CHUNK_SIZE);
			} else {
				chunkId = curOrg.sequence.substr(i, curOrg.sequence.length() % CHUNK_SIZE);
				if (chunkId.size() == 0) break;
			}
//			std::cout << "CHUNK ID = " << chunkId << std::endl;

			std::vector<int> v;
			chunkScores[i/CHUNK_SIZE].insert(std::make_pair(chunkId, v));
			chunkScores[i/CHUNK_SIZE][chunkId].push_back(curOrg.score);

		}
	}

	std::string championSequence = "";
	auto championScore = 0;
	unsigned long int totalScores = 0;

	for (organism curOrg : organisms) {
		totalScores += curOrg.score;
		if (curOrg.score > championScore) {
			championScore = curOrg.score;
			championSequence = curOrg.sequence;
		}
	}

	auto averageScore = totalScores / organisms.size();
	std::cout << "Champion is " << championSequence << " with a score of " << championScore << std::endl;
	std::cout << "Average score is " << averageScore << std::endl;

	// Organize highest to lowest score
	std::sort(organisms.begin(), organisms.end(), [](organism a, organism b){return a.score > b.score;});
	/*
	for (auto o : organisms) {
		std::cout << o.sequence << "\t" << o.score << std::endl;
	}
	*/
	// Write elite organisms to file
	std::ofstream output(ELITE_OUTPUT_FILE);
	try {
		for (auto i = 0; i < organisms.size() && i < NUM_ELITES; i++) {
			output << organisms[i].sequence << "\t" << organisms[i].score << std::endl;
		}
	} catch (std::exception &e) {

	}
}
