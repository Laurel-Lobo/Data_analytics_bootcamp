import os
import re

with open("paragraph_1.txt", 'r') as para:
    
    paraReader = para.read()
    letterCount = 0
    wordCount = 0
    sentenceCount = 0
    
    for char in paraReader:
        if char.isalpha():
            letterCount += 1
    
    words = re.split(r" ", paraReader)

    for word in words:
        wordCount += 1
        if "\n\n" in word:
            wordCount +=1
        #to account for initials inflating sentenceCount
        if "." in word and len(word) == 2:
            sentenceCount -= 1
            
    sentenceCount += paraReader.count('.') + paraReader.count('?') + paraReader.count('!')
    
    sentenceLength = round((wordCount / sentenceCount), 1)
    letterWordCount = round((letterCount / wordCount), 1)
    
    print("Paragraph Analysis")
    print("-----------------")
    print(f"Approximate Word Count: {wordCount}")
    print(f"Approximate Sentence Count: {sentenceCount}")
    print(f"Average Letter Count: {letterWordCount}")
    print(f"Average Sentence Length: {sentenceLength}")