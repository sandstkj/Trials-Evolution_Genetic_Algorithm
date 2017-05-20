#include <string>
#include <iostream>
#include <vector>
#include <fstream>
#include <unordered_map>
#include <typeinfo>
#include <algorithm>

#include <stdlib.h>
#include <time.h>
#include <math.h>

struct organism {
	std::string sequence;
	int score;
};

const int CHUNK_SIZE = 4;
const int RANDOMS_SIZE = 50;

const int NUM_ELITES = 5;
const int NUM_RANDOMS = 3;

std::string INPUT_FILE = "TestedOrganisms.txt";
std::string OUTPUT_FILE = "UntestedOrganisms.txt";
std::string HISTORY_FILE = "History.txt";
std::string ELITE_FILE = "Elites.txt";

// A vector of chunks, with each having identities that have their scores
static std::vector<std::unordered_map<std::string, std::vector<int>>> chunkScores;

std::vector<organism> loadOrganisms(const std::string &inputFileName);

void findChamp(const std::vector<organism> &organisms);

void generateOffspring(const std::vector<organism> &organisms, const std::string outputFile);

std::string mutate(std::string subject);

int main(int argc, char* argv[]) {


	// Populate vector of organisms
	std::vector<organism> organisms = loadOrganisms(INPUT_FILE);
	if (organisms.size() == 0) {return 1;}

	findChamp(organisms);

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

	// Organize highest to lowest score
	std::sort(organisms.begin(), organisms.end(), [](organism a, organism b){return a.score > b.score;});

	// Save all organisms to history (used for ensuring new organisms
	// are not the same as redundant, bad organisms
	try {
		std::ofstream history;
		history.open(HISTORY_FILE, std::ios_base::app);
		for (auto o : organisms) {
//			std::cout << o.sequence << "\t" << o.score << std::endl;
			history << o.sequence << "\t" << o.score << std::endl;
		}
		history.close();
	} catch (std::exception &e) {
		std::cout << "Unable to write to history" << std::endl;
	}

	generateOffspring(organisms, OUTPUT_FILE);
}

std::vector<organism> loadOrganisms(const std::string &inputFileName) {
	std::vector<organism> organisms;
	char del1 = '\t';
	char  del2 = '\n';

	try {
		std::ifstream input(inputFileName);
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

	} catch (std::exception &e) {
		std::cout << "Problem loading input file: \"" << inputFileName << "\"" << std::endl;
	}
	return organisms;
}

void findChamp(const std::vector<organism> &organisms) {
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

}

void generateOffspring(const std::vector<organism> &organisms, const std::string outputFile) {
	srand(time(NULL));

	// Write elite organisms to output and elites file
	try {
		std::ofstream output(outputFile);
		std::ofstream elite_output(ELITE_FILE);

		// Elites
		for (auto i = 0; i < organisms.size() && i < NUM_ELITES; i++) {
			output << organisms[i].sequence << std::endl;
			elite_output << organisms[i].sequence << "\t" << organisms[i].score << std::endl;

			output << mutate(organisms[i].sequence) << std::endl;
		}
		elite_output.close();

		// Randoms
		for (auto i = 0; i < NUM_RANDOMS; i++) {
			// Generate new organism
			std::string randOrg = "";
			while (randOrg.size() < RANDOMS_SIZE) {
				randOrg += std::to_string(rand()%100);
			}
			// See if it's in history

			// Write to Untested
			std::cout << "Writing random organism " << randOrg << std::endl;
			output << randOrg << std::endl;
		}


		output.close();
	} catch (std::exception &e) {
		std::cout << "A problem occurred while writing elites" << std::endl;
	}
}

std::string mutate(std::string subject) {
	int numberMutations = (int)log(rand() % 1000);
	auto subjectMutable = subject;
	for (int i = 0; i < numberMutations; i++) {
		subjectMutable[rand() % subject.size()] = std::to_string(rand() % 9).at(0);
	}
	std::cout << "From " << subject;
	subject = subjectMutable;
	std::cout << " to " << subject << std::endl;
	return subject;
}
