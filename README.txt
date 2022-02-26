rdp.jflex by Jason Yin in Java.  

compile with jflex jar file and javac, disregard warnings, to run type in: 'java rdp input_filename'

specifically type something like these:
java -jar jflex-full-1.7.0.jar rdp.jflex
javac rdp.java 
java rdp inputfilename

Output will specify the Nonterminals, first sets, and follow sets.  These sets are specified in the order that the Nonterminals are listed in so for example:
[A,B]
[[set1],[set2]]
[[set3],[set4]]

note: set1 and set3 correspond to A while set2 and set4 correspond to B. The first nonterminal in the first line of the output is the start symbol, which in this case is A. This is to cover the requirement for productions of "start" symbol printed first.