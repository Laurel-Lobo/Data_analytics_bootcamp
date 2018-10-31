import os
import csv

def convertDate(date):
    year = date[0:4]
    month = date[5:7]
    day = date[8:10]
    
    return (f"{month}/{day}/{year}")

def convertSSN(SSN):
    SSN2 = "***-**-" + SSN[7:11]
    return(SSN2)

StateAbbrev = {
   'Alabama': 'AL',
   'Alaska': 'AK',
   'Arizona': 'AZ',
   'Arkansas': 'AR',
   'California': 'CA',
   'Colorado': 'CO',
   'Connecticut': 'CT',
   'Delaware': 'DE',
   'Florida': 'FL',
   'Georgia': 'GA',
   'Hawaii': 'HI',
   'Idaho': 'ID',
   'Illinois': 'IL',
   'Indiana': 'IN',
   'Iowa': 'IA',
   'Kansas': 'KS',
   'Kentucky': 'KY',
   'Louisiana': 'LA',
   'Maine': 'ME',
   'Maryland': 'MD',
   'Massachusetts': 'MA',
   'Michigan': 'MI',
   'Minnesota': 'MN',
   'Mississippi': 'MS',
   'Missouri': 'MO',
   'Montana': 'MT',
   'Nebraska': 'NE',
   'Nevada': 'NV',
   'New Hampshire': 'NH',
   'New Jersey': 'NJ',
   'New Mexico': 'NM',
   'New York': 'NY',
   'North Carolina': 'NC',
   'North Dakota': 'ND',
   'Ohio': 'OH',
   'Oklahoma': 'OK',
   'Oregon': 'OR',
   'Pennsylvania': 'PA',
   'Rhode Island': 'RI',
   'South Carolina': 'SC',
   'South Dakota': 'SD',
   'Tennessee': 'TN',
   'Texas': 'TX',
   'Utah': 'UT',
   'Vermont': 'VT',
   'Virginia': 'VA',
   'Washington': 'WA',
   'West Virginia': 'WV',
   'Wisconsin': 'WI',
   'Wyoming': 'WY',
}

with open ("employee_data.csv", 'r', newline = "") as employeeFile:
    employeeRead = csv.reader(employeeFile)
    
    next(employeeRead, None)
    
    Names = []
    FirstName = ["First Name"]
    LastName = ["Last Name"]
    NewData = ["Emp ID"]
    Dates = []
    NewDates = ["DOB"]
    SSNs = []
    NewSSNs = ["SSN"]
    States = []
    NewStates = ["State"]
    
    #column parser for transformations to follow
    for line in employeeRead:
        Names.append(line[1])
        NewData.append(line[0])
        Dates.append(line[2])
        SSNs.append(line[3])
        States.append(line[4])
    
    #separate name columns   
    for name in Names:
        first,last = name.split(" ")
        FirstName.append(first)
        LastName.append(last)
    
    #converts dates to new format 
    for date in Dates:
        NewDates.append(convertDate(date))
    
    #converts SSNs to masked format
    for SSN in SSNs:
        NewSSNs.append(convertSSN(SSN))
    
    #abbreviates State names
    for state in States:
        NewStates.append(StateAbbrev.get(state))
    
    #rebuilds transformed columns
    NewData = zip(NewData, FirstName, LastName, NewDates, NewSSNs, NewStates)

with open ("Clean_employee_data.csv", "w") as file:
    writer = csv.writer(file, delimiter=',', lineterminator = '\n')
    writer.writerows(NewData)