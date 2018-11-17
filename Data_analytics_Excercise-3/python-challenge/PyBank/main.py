
import csv

bankData = []
months = []
profitsLosses = []
AvgChange = 0

with open("budget_data.csv", 'r', newline="", encoding='utf-8') as bankFile:
    bankReader = csv.reader(bankFile, delimiter=",")
    next(bankReader, None)
    
    for line in bankReader:
        months.append(line[0])
        profitsLosses.append(int(line[1]))
        
    TMonths = len(months)
    
    # calculates total across months
    Total = sum(i for i in profitsLosses)
    
    ChangeCount = (len(profitsLosses) - 1)
    
    for i in range(ChangeCount):
        Current = profitsLosses[i]
        Following = profitsLosses[i + 1]
        Change = Following - Current
        AvgChange += Change

    CumChange = round((AvgChange/ChangeCount), 2)
    
    # outputs maximum value and corresponding month
    Max = max(profitsLosses)
    MonthMax = months[int(profitsLosses.index(Max))]
    
    # outputs minimum value and corresponding month
    Min = min(profitsLosses)
    MonthMin = months[int(profitsLosses.index(Min))]
    
    # print to terminal
    print("Financial Analysis")
    print("----------------------------")
    print(f"Total Months: {TMonths}")
    print(f"Total: ${Total}")
    print(f"Average Change: ${CumChange}")
    print(f"Greatest Increase in Profits: {MonthMax} (${Max})")
    print(f"Greatest Decrease in Profits: {MonthMin} (${Min})")
    
    # print to output file
    with open("FinancialAnalysis.txt", "w") as file:
        file.write("Financial Analysis\n")
        file.write("----------------------------\n")
        file.write(f"Total Months: {TMonths}\n")
        file.write(f"Total: ${Total}\n")
        file.write(f"Average Change: ${CumChange}\n")
        file.write(f"Greatest Increase in Profits: {MonthMax} (${Max})\n")
        file.write(f"Greatest Decrease in Profits: {MonthMin} (${Min})\n")