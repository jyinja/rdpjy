//jflex jason yin, compile with jflex jar file and javac, disregard warnings, to run type in: 'java rdp input_filename'
//Comments can be found throughout the file, comments include print statements that I commented out (but you could uncomment to see buncha output if you want) or descriptions of
//what my code functionality does
//error1 has OR on same line, error2 and 3 have missing arrows
//Notes:
//0000 0000 0000 0000 0000 0000 0000 0000
//---- E$zy xwvu tsrq ponm lkji hgfe dcba
//capital E is epsilon
import java.io.*;
import java.util.*;
%%
%class rdp
%unicode
%line
%column
%{
static rdp lexer=null;
static int NTcount = 0;
static int Tcount = 0;
static int arrowCount = 0;
static int semiCount = 0;
static int ORcount = 0;
static int linecount = 1;
static int lookahead = 0;
static int backtrack = 0;
static int first = 0;
static int follow = 0;
static int mask = 1;
//constants
static final int NTerm = 1;
static final int Term = 2;
static final int GOE = 3;
static final int SEMICOL = 4;
static final int Or = 5;
static final int EOLn = 6;
static final int EOFile = 7;
static int error_found = 0;

static ArrayList<String> states = new ArrayList<>();//store nonterm states
static ArrayList<ArrayList<String>> firsts = new ArrayList<>();//store first sets
static ArrayList<ArrayList<String>> follows = new ArrayList<>();//store follow
static ArrayList<String> followshelper = new ArrayList<>();//help setup follow
static Stack<String> stck = new Stack<String>();//stack data structure, initialize by pushing dollar sign and the start symbol
static String backtrackstr = "";
@SuppressWarnings("unchecked")
public static void main(String [] args) throws IOException{
    lexer = new rdp(new FileReader(args[0]));//pass in an argument which will be the filename of input
    stck.push("$");
    lookahead = lexer.yylex(); //start with start symbol first nonterminal
    stck.push(lexer.yytext());
    //System.out.print(lexer.yytext() );
    //System.out.println("lookahead: "+lookahead);
    error_found = 0;
    /*
    lookahead=lexer.yylex();//gives whitespace
    System.out.println("lookahead: "+lookahead);
    lookahead=lexer.yylex();//gives return of 3 which signifies an arrow symbol
    System.out.println("lookahead: "+lookahead);
    */
    prod_list();//start of recursive descent parse
    //nonTerminal();
    if(error_found==0 /*&& lookahead == 0*/){
        System.out.println("Input file is Accepted"); //test1, test2, test3, test4 all accepted
    }
    else{
        System.out.println("Input file is Rejected (ERROR)"); //error1, error2, error3 all rejected
        System.exit(0);
    }
    //System.out.println(NTcount + " "+Tcount+" "+arrowCount+" "+ semiCount+" "+ ORcount+" "+linecount);//print out some info
    ///follows.get(states.indexOf(lexer.yytext())).add("$");
    System.out.println("The Non-terminals are: \n"+states);

    for(int i = 0;i<states.size();i++){
        for( int j = 0;j<firsts.get(i).size();j++){
            if(!firsts.get(i).contains("eps") && firsts.get(i).get(j).length()>=2 && firsts.get(i).get(j).charAt(0)>=97 && !firsts.get(i).get(j).equals("eps") ){
                firsts.get(i).remove(j);//remove terminals that follow a nonterminal, if that nonterminal does not go to epsilon
                j--;
            }
        }
    }
    //System.out.println(firsts);
    //System.out.println(states.indexOf(firsts.get(0).get(0).substring(0,1)));
    //System.out.println(firsts.get(states.indexOf(firsts.get(0).get(0).substring(0,1))) );
    //old:
    /*for(int i = 0;i<states.size();i++){
        for( int j = 0;j<firsts.get(i).size();j++){
            if((int)firsts.get(i).get(j).charAt(0)<=90 && firsts.get(i).get(j).length()<2      && firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).contains("eps") ) {//check ascii decimal value for nonterm
                for(int k = 0;k<firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).size();k++ ){
                    if(!firsts.get(i).contains( firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k)) && !firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k).equals("eps")){
                    firsts.get(i).add(firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k) );
                    }


                }
                firsts.get(i).set(j,"");
            }
            else if( (int)firsts.get(i).get(j).charAt(0)<=90 && firsts.get(i).get(j).length()>=2){

            }
        }
    }*/

    for(int i = 0;i<states.size();i++){
        for( int j = 0;j<firsts.get(i).size();j++){
            if((int)firsts.get(i).get(j).charAt(0)<=90 && firsts.get(i).get(j).length()<2 /*&& firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).contains("eps")*/ ) {//check ascii decimal value for nonterm(which is less than or equal to 90) and process sets
                for(int k = 0;k<firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).size();k++ ){
                    if(!firsts.get(i).contains( firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k)) &&!firsts.get(i).contains( firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k).substring(0,1)) && !firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k).equals("eps")){
                    firsts.get(i).add(firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k) );
                    }



                }
               firsts.get(i).set(j,"");

            }
            else if( (int)firsts.get(i).get(j).charAt(0)<=90 && firsts.get(i).get(j).length()>=2){
               if( firsts.get(i).get(j-1).equals("")){
                //if previous empty string then set itself to empty
                  for(int k = 0;k<firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).size();k++ ){
                    if(!firsts.get(i).contains( firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k)) &&!firsts.get(i).contains( firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k).substring(0,1)) && !firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k).equals("eps")){
                    firsts.get(i).add(firsts.get(states.indexOf(firsts.get(i).get(j).substring(0,1))).get(k) );
                    }
                  }
                  firsts.get(i).set(j,"");
                  //remove extraneous nonterms, iteratively add to the set(s)
               }

            }
        }
    }

      for(int i = 0;i<firsts.size();i++){
         for(int j = 0;j<firsts.get(i).size();j++){
            if(firsts.get(i).get(j).equals("") || (int)firsts.get(i).get(j).charAt(0) <=90){//remove extraneous nonterms from set/list
               firsts.get(i).remove(j);
               j--;
            }
         }
      }
    System.out.println("\nFirst sets for each Non-terminal are as follows: \n"+firsts); //print result of first set

    for(int i = 0;i<followshelper.size();i++){ //prep follow set
        //;-follows, +-union

        if(followshelper.get(i).substring(1,2).equals(";") && !followshelper.get(i).substring(0,1).equals(followshelper.get(i).substring(2)) && (int)followshelper.get(i).charAt(0)<=90 ){
            //follow condition handling
            follows.get(states.indexOf(followshelper.get(i).substring(2))).addAll(firsts.get(states.indexOf(followshelper.get(i).substring(0,1))));
        }
        /*old
        if(followshelper.get(i).substring(1,2).equals("+") && !followshelper.get(i).substring(0,1).equals(followshelper.get(i).substring(2)) && (int)followshelper.get(i).charAt(0)<=90 ){
            //union condition handling
            follows.get(states.indexOf())
        }*/
    }
    //handle union of nonterminal follow sets
    for(int i =0;i<followshelper.size();i++){
        if(followshelper.get(i).substring(1,2).equals("+") && !followshelper.get(i).substring(0,1).equals(followshelper.get(i).substring(2)) && (int)followshelper.get(i).charAt(0)<=90 ){
            //union condition handling

            follows.get(states.indexOf(followshelper.get(i).substring(0,1))).addAll(follows.get(states.indexOf(followshelper.get(i).substring(2))));
        }
    }

    for(int i =0;i<follows.size();i++){ //follow sets cannot include epsilon
        for(int j=0;j<follows.get(i).size();j++){
            if(follows.get(i).get(j).equals("eps")){
                follows.get(i).remove(j);
                j--;
            }
        }
        follows.set(i,removeDups(follows.get(i)) );
    }
    System.out.println("\nFollow sets for each Non-terminal are as follows: \n"+follows);

    //System.out.println(stck);
}
public static <T> ArrayList<T> removeDups(ArrayList<T> list){
    ArrayList<T> newlis = new ArrayList<T>();
    for(T item:list){
        if(newlis.contains(item)==false){
            newlis.add(item);
        }
    }
    return newlis;
}
private static void error(String where){ //error method
    System.out.println("Error found in function "+ where+ " on line "+rdp.linecount+" with token "+lexer.yytext());
    if(lexer.yytext().equals("\n")){
        System.out.println("new line bro");
    }
    error_found = 1;//handle errors
}
private static void match(int token) throws IOException{ //match method
    if (token == lookahead){
        backtrackstr = lexer.yytext();
        backtrack = lookahead; //save the last lookahead as backtrack
        //System.out.println("before matching, the current token that will be saved as backtrack is of int type: "+backtrack);
        try{
        lookahead = lexer.yylex();
        //System.out.println("new lookahead token: "+lexer.yytext()+ " with token int of "+lookahead);
        }
        catch(NullPointerException e){
            System.out.println("Reached end of input file.");
        }
    }
    else{
        error("match");
        //System.out.println("int token:" +token);
    }
}
//6 methods made for LL
private static void prod_list() throws IOException{ //prod_list: production prod_list', predict(prod_list) = first(production) = {NT}
    if(lookahead == rdp.NTerm){
        //System.out.println("prod_list yytext is: "+lexer.yytext());
        if(!states.contains(lexer.yytext()) && states.size()==0){//first thing to be added
            states.add(lexer.yytext());
            firsts.add(new ArrayList());
            follows.add(new ArrayList());
            follows.get(states.indexOf(lexer.yytext())).add("$");
        }
        else if(!states.contains(lexer.yytext())){//update states list, n/a
            states.add(lexer.yytext());
            firsts.add(new ArrayList());
            follows.add(new ArrayList());
        }
        production();
        prod_list_prime();
    }

    else{
        error("prod_list");
    }
}
private static void prod_list_prime() throws IOException{ //prod_list': production prod_list' | eps, predict(prod_list') = {NT,$}
    if(lookahead == rdp.NTerm){
        if(!states.contains(lexer.yytext()) && states.size()==0){//first thing to be added, n/a
            states.add(lexer.yytext());
            firsts.add(new ArrayList());
            follows.add(new ArrayList());
            follows.get(states.indexOf(lexer.yytext())).add("$");
        }
        else if(!states.contains(lexer.yytext())){ //adds subsequent states
            states.add(lexer.yytext());
            firsts.add(new ArrayList());
            follows.add(new ArrayList());
        }
        production();
        prod_list_prime();
    }
    /*
    else if(lookahead == rdp.EOFile){
        System.out.println("dollar sign");
        return;
    }*/
    else if (lookahead == rdp.EOLn){
        return;//eps
    }
    else{
        error("prod_list_prime");
    }
}
private static void production() throws IOException{ //production --> NT GOES production_body SEMI EOL, predict(production) = {NT}
    if(lookahead == rdp.NTerm){
        match(rdp.NTerm);
        match(rdp.GOE);
        production_body();
        /// match(rdp.SEMICOL);
        match(rdp.EOLn);

    }
    else{
        error("production");
    }
}
private static void production_body() throws IOException{//production_body --> rule production_body', predict(production_body)= first(rule) = {NT,T,EOL}
    if(lookahead == rdp.NTerm){
        if ( (backtrack==3 || backtrack==5) && (firsts.get(states.size()-1).contains(lexer.yytext())==false) ){
            firsts.get(states.size()-1).add(lexer.yytext()); //added first nonterminals
        }



        rule();
        production_body_prime();
    }
    else if (lookahead == rdp.Term){
        if ( (backtrack==3 || backtrack==5) && (firsts.get(states.size()-1).contains(lexer.yytext())==false) ){
            firsts.get(states.size()-1).add(lexer.yytext()); //added first terminals
        }
        rule();
        production_body_prime();
    }
    else if(lookahead == rdp.EOLn){
        if(backtrack == 5){
            firsts.get(states.size()-1).add("eps");//if backtrack is OR and lookahead is a new line then add eps to the set
        }
        rule();
        production_body_prime();
    }
    else{
        error("production_body");
    }

}
private static void production_body_prime() throws IOException{ //production_body' : OR rule production_body' | eps, predict(production_body') = {OR, SEMI}
    if(lookahead == rdp.Or){
        match(rdp.Or);
        rule();
        production_body_prime();
    }
    else if(lookahead == rdp.SEMICOL){
        match(rdp.SEMICOL);//unsure, but if the match(semicolon) in production is commented out an error message problem does not arise

        //match(rdp.EOLn);//commented this out and error message only shows once now for test1
    }
    //else if(lookahead == rdp.EOLn){
        //match(rdp.EOLn);
    //}
    else{
        error("production_body_prime");
    }
}
private static void rule() throws IOException{//rule: NT rule| T rule | EOL, predict(rule) = {NT, T, EOL}
    if(lookahead == rdp.NTerm){
        if ( /*(backtrack==3 || backtrack==5) &&*/ (firsts.get(states.size()-1).contains(lexer.yytext())==false) ){
            if(backtrack==1){
                firsts.get(states.size()-1).add(lexer.yytext()+" "); //added subsequent nonterminals (len=2)
                //follows.get(states.size()-1).add(backtrackstr);

                followshelper.add(lexer.yytext()+";"+backtrackstr);
                //; means follows

            }
            else if(backtrack == 3 || backtrack ==5){
                firsts.get(states.size()-1).add(lexer.yytext());
            }
        }

        match(rdp.NTerm);
        rule();
    }
    else if(lookahead == rdp.Term){
        if ( (backtrack==3 || backtrack==5) && (firsts.get(states.size()-1).contains(lexer.yytext())==false) ){

            firsts.get(states.size()-1).add(lexer.yytext()); //added first terms

        }
        else if(backtrack == 1 && backtrackstr.equals(states.get(states.size()-1)) /*&& firsts.get(states.size()-1).contains("eps")*/ ){
            firsts.get(states.size()-1).add(lexer.yytext()+" "); //add terminals if the preceding thing is a nonterminal equal to the state itself (could potentially delete later with the detection of epsilon)
        }
        if(backtrack==1){//as long as the preceding was a NTerm we check for following terminals


            followshelper.add(lexer.yytext()+";"+backtrackstr);
            //; means follows




        }
        match(rdp.Term);
        rule();
    }
    else if(lookahead == rdp.EOLn){
        if(backtrack == 5){
            firsts.get(states.size()-1).add("eps");//if backtrack is OR and lookahead is a new line then add eps to the set
        }
        if(backtrack==1){
            followshelper.add(backtrackstr+"+"+states.get(states.size()-1));//union case for follow helper
        }
        match(rdp.EOLn);
    }
    else{
        error("rule");
    }
}
/*old code
private static void nonTerminal() throws IOException{
    if(lookahead == rdp.NTerm){//lookahead equals one
        if(!states.contains(lexer.yytext()) && states.size()==0){//first thing to be added
                states.add(lexer.yytext());
                //follows.get(states.indexOf(lexer.yytext())).add("$");
        }
    }
}*/
%}
%type Integer//changes yylex return type
//lex stuff below
NT = [A-Z]
T = [a-z]
GOES = (-->)
SEMI = (;)
OR = [|]
EOL = (\n)

EOF = [$]
%%
{NT}    { System.out.println("token: "+yytext());NTcount++;return NTerm;}
{T}     {System.out.println("token: "+yytext());Tcount++;return Term;}
{GOES}  {System.out.println("token: "+yytext());arrowCount++;return GOE;}
{OR}    {System.out.println("token: "+yytext());ORcount++;return Or;}
{SEMI}  {System.out.println("token: "+yytext());semiCount++;return SEMICOL;}
{EOL}   {System.out.println("nextline");linecount++;return EOLn;}

{EOF}   {return EOFile;}
.	{System.out.println("reached end of lex spec/ignore white space");}
