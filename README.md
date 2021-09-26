# Prog-Languange-Recognizer

NOTICE : You must install GOSU, and run the program by typing the following:

gosu program_recognizer.gsp



The objective of this program is to create a language recognizer that only accepts strings that are based on the grammar that was shown above. 
The program should display the BNF grammar and prompt the user for an input which should be a string. The string must be enclosed by the keywords “to” and “end”. 
Once the string is entered, the program must perform a leftmost derivation on it. 

If the derivation is successful, a parse tree will be drawn and displayed, and the user will be asked to enter another string to perform the same operation. 
Otherwise, if the derivation fails, the strings will be declared as invalid with an error message. To terminate the program, the user must enter “STOP” when the 
program asks them for an input.



<chart>→ to <plot_cmd> end
<plot_cmd>→ <cmd>
| <cmd> ; < plot_cmd >
<cmd>→ vbar <x><y>,<y>
| hbar <x><y>,<x>
| fill <x><y>
<x>→ 1 | 2 | 3 | 4 | 5 | 6 | 7
<y>→ 1 | 2 | 3 | 4 | 5 | 6 | 7
Examples of accepted string: "to vbar 43,1; fill 22 end"
