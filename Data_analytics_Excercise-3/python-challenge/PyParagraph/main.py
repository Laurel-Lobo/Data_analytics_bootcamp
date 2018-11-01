import os
import re

with open("paragraph_2.txt", 'r', newline = '') as para:
    
    paraReader = para.read()
    letterCount = 0
    
    for char in paraReader:
        if char.isalpha():
            letterCount += 1
    
    wordCount = len(re.split(r' ', paraReader))
    sentenceCount = paraReader.count('.') + paraReader.count('?') + paraReader.count('!')
    sentenceLength = round((wordCount / sentenceCount), 1)
    letterWordCount = round((letterCount / wordCount), 1)
    
    print("Paragraph Analysis")
    print("-----------------")
    print(f"Approximate Word Count: {wordCount}")
    print(f"Approximate Sentence Count: {sentenceCount}")
    print(f"Average Letter Count: {letterWordCount}")
    print(f"Average Sentence Length: {sentenceLength}")
