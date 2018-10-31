import os
import csv

with open ("election_data.csv", "r", newline = "") as electionFile:
    electionReader = csv.reader(electionFile)
    AllCand = []
    UniqCand = []
    Results = []
    Percent = []
    CandResults = {}
    next(electionReader, None)
    
    for line in electionReader:
        AllCand.append(line[2])
    
    TotalVotes = len(AllCand)
    
    for line in AllCand:
        if line not in UniqCand:
            UniqCand.append(line)
    
    for candidate in UniqCand:
        Results.append(AllCand.count(candidate))
        Percent.append(round((AllCand.count(candidate)/TotalVotes) * 100))
                        
    CandResults = dict(zip(UniqCand, zip(Percent, Results)))
    
    #gets ticker for candidate with maximum votes
    Winner = max(CandResults, key = CandResults.get)
    
    #prints output
    print("Election Results")
    print("-------------------------")
    print(f"Total Votes: {TotalVotes}")
    print("-------------------------")
    for line in CandResults:
        print (f"{line}: {CandResults[line][0]}% ({CandResults[line][1]})")
    print("-------------------------")
    print(f"Winner: {Winner}")
    print("-------------------------")

    #prints to file
with open("Election Results.txt", 'w') as file:
    file.write("Election Results\n")
    file.write("-------------------------\n")
    file.write(f"Total Votes: {TotalVotes}\n")
    file.write("-------------------------\n")
    for line in CandResults:
        file.write (f"{line}: {CandResults[line][0]}% ({CandResults[line][1]})\n")
    file.write("-------------------------\n")
    file.write(f"Winner: {Winner}\n")
    file.write("-------------------------\n")    