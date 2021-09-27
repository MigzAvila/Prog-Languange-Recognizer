uses java.io.InputStreamReader
uses java.util.Scanner
uses java.lang.System
uses java.util.*


//displaying the prog regcon. Gobal Var so that is accesseble in the main/bottom code
var program = "to <plot_cmd> end"
var plot_cmd = "<cmd> | <cmd> ; <plot_cmd> -- statement"
var cmd = "vbar <x><y>,<y> | hbar <x><y>,<x> | fill <x><y>"
var x = "x: 1 | 2 | 3 | 4 | 5 | 6 | 7"
var y = "y: 1 | 2 | 3 | 4 | 5 | 6 | 7"

var good_exm = "Examples of accepted string: 'to vbar 43,1; fill 22 end' -- without quotes"
var bad_exm = "Examples of bad string: 'to vbar 93,1; fill 22 end' ERROR: x coord 9 not valid "
var prevHasSemiColon = true
var errorForNum = false
var passesValidation = true

var breaksProgram = false



//testing class
public class recognizer {


  //function MAIN
  function MAIN() : void {

//prints commands
    print("******************************************************* ")
    print("\t\t BNF grammar ")
    print("******************************************************* ")
    print(program)
    print(plot_cmd)
    print(cmd)
    print(x)
    print(y)
    print(good_exm)
    print(bad_exm)

    print("Your Turn Now: \n")

//scan for input
    var sc = new Scanner(new InputStreamReader(System.in))
    var str = sc.nextLine();              //reads string
    var isWhiteSpace = str.split(" ")



//call MAIN function
//create a while loop ...
    var result = false
    if (str != "STOP") {
      result = validator(str)
      if (result) {
        print_derivation(str.split("\\s"))
        parse_tree(str.split("\\s"))
      }
    }


    while (str != "STOP") {
      if (isWhiteSpace.length < 4) {
        print("\n\n")
        print("Error! ")
        print("Incomplete program Statement: ")
        print(str)
        print("Accepted program Statement as follow: ")
        print(program)
        print(cmd)
        print(x)
        print(y)
        print(good_exm + "\n")
        print("\n\n\n")
      }

      print("Enter STOP to stop the program or a string to continue using the program. :) \n")
      print("\n******************************************************* ")
      print("\t\t BNF grammar ")
      print("*******************************************************\n ")
      print(program)
      print(plot_cmd)
      print(cmd + "\n")
      print(x)
      print(y + "\n")
      print(good_exm)
      print(bad_exm + "\n")


      prevHasSemiColon = true
      errorForNum = false
      passesValidation = true

      breaksProgram = false
      print("Your Turn Now: \n")
      str = sc.nextLine();              //reads string
      isWhiteSpace = str.split(" ")
      if (str != "STOP" || isWhiteSpace.length != 0) {
        result = validator(str)
        print("\n\n")
        if (result) {
          print_derivation(str.split("\\s"))
          parse_tree(str.split("\\s"))
        }

      }

    }
  }




  //change to validate input cmd
  function validator(value : String) : boolean {

    print("\n")

    //split a string input by user : return in array format of split result
    var arrOfStr = value.split(" ");

    //loop until user at least has 4 strings == "to <plot_cmd> <cmd> end"
    if (arrOfStr.length < 4)
    {
      return false
    }

    //calls function validatesCmd that checks that the programs has a 'to' and a 'end' in the string
    if (validatesCmd(arrOfStr)) {
      //joins array previously spilted
      var joinInput = arrOfStr.join(" ")
      //removes 'to' and 'end'
      var plot_Cmd = joinInput.split("(?:^to|end$|\\s+)") //['', '', vbar, sdadas, ]

      //count is 2 since plot_Cmd[0 && 1] is empty == ""
      var count = 2
      var valid_cmd = true
      //loop for 2 in a single loop - passes <plot_cmd> with <cmd> <cmd> to check if there is to be expect a next <plot_cmd>
      while (count < plot_Cmd.length - 1 && valid_cmd) {
        //checks that next value exists in array plot_cmd
        if (count + 1 <= plot_Cmd.length) {
          var current = {plot_Cmd[count], plot_Cmd[count + 1]}
          var plotcmd = current.toTypedArray()
          //validates single command
          valid_cmd = validates_cmd(plotcmd)
        }

        count = count + 2

      }

      //breaksProgram determines to continue or not
      if (!prevHasSemiColon) {
        if (!breaksProgram) {
          //checks for xy,x for vbar && hbar - fill - xy
          var hold = true
          count = 2

          //loop for 2 in a single loop - passes <plot_cmd> with <cmd> <values> to check if numbers <x> and <y> are valid
          while (count + 1 < plot_Cmd.length && hold) {
            //checks that next value exists in array plot_cmd
            if (count + 1 <= plot_Cmd.length - 1) {
              var current = {plot_Cmd[count], plot_Cmd[count + 1]}
              var plotcmd = current.toTypedArray()
              //calls function to validate numbers
              validatesnums(plotcmd)
            }
            count = count + 2
            //if there an with a x or y not value it prints the error and stop loop
            if (errorForNum) {
              hold = false
            }
          }
          //check if user enter a ; but not following <plot_cmd>
          if (count < plot_Cmd.length) {
            print("\nError. No cmd found for <plot_cmd> : " + plot_Cmd[count])
            print("\nMissing cmd: ")
            print(cmd)
            print(x)
            print(y)
            print(good_exm)
            passesValidation = false

          }
        }
        //return true/false based on the
        return passesValidation
      } else if (breaksProgram)
      {
        return false
      }
      else if (plot_Cmd.length < 4)
      {
        print("Error! ")
        print("Incomplete program Statement: ")
        print(joinInput)
        print("Accepted program Statement as follow: ")
        print(program)
        print(cmd)
        print(x)
        print(y)
        print(good_exm + "\n")
        print("\n\n\n\n\n")
        passesValidation = false
        return false
      }
      else
      {
        print("Error! ")
        print("You State a semi colon, Yet no next <plot_cmd> was found ")
        print(plot_Cmd[plot_Cmd.length - 1])
        print("\n\n\n\n\n")
        return false
      }
    } else {
      return passesValidation
    }
  }

  // validate input cmd to and end
  function validatesCmd(value : String[]) : boolean {
    var firstVal = value[0]
    var lastVal = value[value.length - 1]
    //validate input if cmd == to and end
    if (firstVal.toLowerCase() == "to" && lastVal.toLowerCase() == "end")
      return true
    else {
      //input cmd not recongnized
      print("Unrecognized chart input: ")
      print(firstVal)
      print(lastVal)
      print("Valid chart input: to <plot_cmd> end ")
      breaksProgram = true
      passesValidation = false
      print("\n\n\n\n\n")
      return false
    }
  }

  //validates numbers for plot_cmd
  function validatesnums(value : String[]) : boolean {
    //passes first value e.g vbar,hbar or fill
    var firstVal = value[0]
    firstVal = firstVal.toString()

    //passes value_cmd e.g 12,3; | 12 | 12,3;
    var holder = value[1]
    var counter = (holder.length())

    //checks if firstVal is vbar of hbar
    if (firstVal.toLowerCase() == "vbar" || firstVal.toLowerCase() == "hbar") {
      //checks hbar | vbar has , as describe on report
      if (counter > 3 && counter < 6 && holder.charAt(2) == ',') {
        //checks if x,y are from 1 - 7
        if (holder.charAt(0) == '1' || holder.charAt(0) == '2' || holder.charAt(0) == '3' || holder.charAt(0) == '4' || holder.charAt(0) == '5' || holder.charAt(0) == '6' || holder.charAt(0) == '7') {
          if (holder.charAt(1) == '1' || holder.charAt(1) == '2' || holder.charAt(1) == '3' || holder.charAt(1) == '4' || holder.charAt(1) == '5' || holder.charAt(1) == '6' || holder.charAt(1) == '7') {
            if (holder.charAt(3) == '1' || holder.charAt(3) == '2' || holder.charAt(3) == '3' || holder.charAt(3) == '4' || holder.charAt(3) == '5' || holder.charAt(3) == '6' || holder.charAt(3) == '7') {
              return true

            } else {
              //last values x not valid
              print("Unrecognized last x val for " + firstVal + ":")
              print(holder.charAt(3))
              print("x: 1 | 2 | 3 | 4 | 5 | 6 | 7")
              print("y: 1 | 2 | 3 | 4 | 5 | 6 | 7")
              print("Valid cmd input: vbar <x><y>,<y> ")
              print("               | hbar <x><y>,<x>")
              print("              | fill <x><y> ")
              breaksProgram = true
              passesValidation = false
              errorForNum = true
              print("\n\n\n\n\n")
              return false
            }

          } else {
            //values y not valid
            print("Unrecognized y val for " + firstVal + ":")
            print(holder.charAt(1))
            print("x: 1 | 2 | 3 | 4 | 5 | 6 | 7")
            print("y: 1 | 2 | 3 | 4 | 5 | 6 | 7")
            print("Valid cmd input: vbar <x><y>,<y> ")
            print("               | hbar <x><y>,<x>")
            print("              | fill <x><y> ")
            breaksProgram = true
            passesValidation = false
            errorForNum = true
            print("\n\n\n\n\n")
            return false
          }


        } else
        //values x not valid
        {
          print("Unrecognized x val for " + firstVal + ": " + holder)
          print(holder.charAt(0))
          print("x: 1 | 2 | 3 | 4 | 5 | 6 | 7")
          print("y: 1 | 2 | 3 | 4 | 5 | 6 | 7")
          print("Valid cmd input: vbar <x><y>,<y> ")
          print("               | hbar <x><y>,<x>")
          print("              | fill <x><y> ")
          breaksProgram = true
          passesValidation = false
          errorForNum = true
          print("\n\n\n\n\n")
          return false
        }
      } else {
        //values not valid in xy,x
        print("Unrecognized value: " + firstVal + " " + holder + " HERE")
        print("Valid cmd input:  vbar <x><y>,<y> ")
        print("                | hbar <x><y>,<x>")
        print("                | fill <x><y> \n")
        print("Where x and y are: ")
        print("x: 1 | 2 | 3 | 4 | 5 | 6 | 7")
        print("y: 1 | 2 | 3 | 4 | 5 | 6 | 7 \n")
        breaksProgram = true
        passesValidation = false
        errorForNum = true
        print("\n\n\n\n\n")
        return false
      }
    }
    //checks if firstVal is fill
    else if (firstVal.toLowerCase() == "fill") {
      if (counter > 1 && counter < 4) {
        //check that x and y are from 1 - 7
        if (holder.charAt(0) == '1' || holder.charAt(0) == '2' || holder.charAt(0) == '3' || holder.charAt(0) == '4' || holder.charAt(0) == '5' || holder.charAt(0) == '6' || holder.charAt(0) == '7') {

          if (holder.charAt(1) == '1' || holder.charAt(1) == '2' || holder.charAt(1) == '3' || holder.charAt(1) == '4' || holder.charAt(1) == '5' || holder.charAt(1) == '6' || holder.charAt(1) == '7') {
            //everythings is ok
            return true
          } else {
            //value y not accepted
            print("Unrecognized y val for " + firstVal + ":")
            print(holder.charAt(1))
            print("x: 1 | 2 | 3 | 4 | 5 | 6 | 7")
            print("y: 1 | 2 | 3 | 4 | 5 | 6 | 7")
            print("Valid cmd input: vbar <x><y>,<y> ")
            print("               | hbar <x><y>,<x>")
            print("              | fill <x><y> ")
            breaksProgram = true
            passesValidation = false
            errorForNum = true
            print("\n\n\n\n\n")
            return false
          }


        }
        //If it reach here plot_cmd, the plot_cmd is not valid
        else {
          //values x not accepted
          print("Unrecognized x val for " + firstVal + ":")
          print(holder.charAt(0))
          print("x: 1 | 2 | 3 | 4 | 5 | 6 | 7")
          print("y: 1 | 2 | 3 | 4 | 5 | 6 | 7")
          print("Valid cmd input: vbar <x><y>,<y> ")
          print("               | hbar <x><y>,<x>")
          print("              | fill <x><y> ")
          breaksProgram = true
          passesValidation = false
          errorForNum = true
          print("\n\n\n\n\n")
          return false
        }
      } else {
        //values not accepted
        print("Unrecognized value: " + holder)
        print("x: 1 | 2 | 3 | 4 | 5 | 6 | 7")
        print("y: 1 | 2 | 3 | 4 | 5 | 6 | 7 \n")
        print("Valid cmd input:  vbar <x><y>,<y> ")
        print("                | hbar <x><y>,<x>")
        print("                | fill <x><y> \n")
        breaksProgram = true
        passesValidation = false
        errorForNum = true
        print("\n\n\n\n\n")
        return false
      }

    } else {
      //cmd not accepted
      print("Unrecognized cmd (fill||vbar||hbar): ")
      print(firstVal)
      print("Valid cmd input: vbar <x><y>,<y> ")
      print("               | hbar <x><y>,<x>")
      print("              | fill <x><y> ")
      print("Where x and y: ")
      print("x: 1 | 2 | 3 | 4 | 5 | 6 | 7")
      print("y: 1 | 2 | 3 | 4 | 5 | 6 | 7")
      breaksProgram = true
      passesValidation = false
      errorForNum = true
      print("\n\n\n\n\n")
      return false
    }
  }


  //check if cmd == vbar, hbar, fill and check if the following cmd has semi-colon (;)
  function validates_cmd(value : String[]) : boolean {
    //prints error for user he state a mutiple cmd with no semi colons
    if (!(prevHasSemiColon)) {
      print("\nIllegal! Previous <plot_cmd> doesn't have semi colon, yet another <plot_cmd> was stated.")
      print("\nYour <cmd> :" + value[0])
      print("\nValid  <plot_cmd>: <cmd>  || <cmd>; <plot_cmd> ")
      print(cmd)
      passesValidation = false
      breaksProgram = true
      return false

    }

    var firstVal = value[0]
    firstVal = firstVal.toString()

    //length for cmd
    var counter = firstVal.length()
    var holder = value[1]


    if (counter > 1 && counter < 6) {
      //check if cmd is vbar or hbar
      if (firstVal.toLowerCase() == "vbar" || firstVal.toLowerCase() == "hbar") {
        //check if values for cmd has a semi colon
        if (holder.charAt(holder.length() - 1) == ';') {
          return true
        } else if (holder.charAt(holder.length() - 1) == '1' || holder.charAt(holder.length() - 1) == '2' || holder.charAt(holder.length() - 1) == '3' || holder.charAt(holder.length() - 1) == '4' || holder.charAt(holder.length() - 1) == '5' || holder.charAt(holder.length() - 1) == '6' || holder.charAt(holder.length() - 1) == '7')
        {
          prevHasSemiColon = false
          return false
        }
        else
        {
          print("\nUnrecognized value for " + firstVal + " : " + holder)
          print(firstVal)
          print("\nx: 1 | 2 | 3 | 4 | 5 | 6 | 7")
          print("\ny: 1 | 2 | 3 | 4 | 5 | 6 | 7")
          print("\nValid cmd input: vbar <x><y>,<y> | hbar <x><y>,<x>  | fill <x><y>")
          prevHasSemiColon = false
          breaksProgram = true
          passesValidation = false
          return false
        }
      }
      //check if cmd is fill
      else if (firstVal.toLowerCase() == "fill") {
        //check if cmd values has semicolon
        var hasSemiColon = (holder.charAt(holder.length() - 1)) == ';'
        if (hasSemiColon) {
          return true
        } else if (holder.charAt(holder.length() - 1) == '1' || holder.charAt(holder.length() - 1) == '2' || holder.charAt(holder.length() - 1) == '3' || holder.charAt(holder.length() - 1) == '4' || holder.charAt(holder.length() - 1) == '5' || holder.charAt(holder.length() - 1) == '6' || holder.charAt(holder.length() - 1) == '7')
        {
          prevHasSemiColon = false
          return false
        }
        else
        {
          print("\nUnrecognized value for " + firstVal + " : " + holder)
          print(firstVal)
          print("\nx: 1 | 2 | 3 | 4 | 5 | 6 | 7")
          print("\ny: 1 | 2 | 3 | 4 | 5 | 6 | 7")
          print("\nValid cmd input: vbar <x><y>,<y> | hbar <x><y>,<x>  | fill <x><y>")
          prevHasSemiColon = false
          breaksProgram = true
          passesValidation = false
          return false
        }


      } else {
        //Cmd not recognized
        print("\nUnrecognized cmd (fill | vbar | hbar): ")
        print(firstVal)
        print("\nx: 1 | 2 | 3 | 4 | 5 | 6 | 7")
        print("\ny: 1 | 2 | 3 | 4 | 5 | 6 | 7")
        print("\nValid cmd input: vbar <x><y>,<y> ")
        print("\n               | hbar <x><y>,<x>")
        print("\n              | fill <x><y> ")
        breaksProgram = true
        passesValidation = false
        print("\n\n\n\n\n")
        return false
      }
    }
    print("\n\n")
    print("Error! ")
    print("Invalid program Statement: ")
    System.out.print("\nto ")
    for (val in value)
    {
      System.out.print(val + " ")
    }
    System.out.print("end \n\n")

    print("Accepted program Statement as follow: ")
    print(program)
    print(cmd)
    print(x)
    print(y)
    print(good_exm + "\n")
    print("\n\n\n")
    breaksProgram = true
    passesValidation = false
    return false
  }

  function print_derivation(value : String[]) : void {
    print("******************************************************* ")
    print("\t\tPrinting Derevation ")
    print("*******************************************************\n")
    //creating a counter from 1
    var counter = 1
    //creating a arraylen of the value passed
    var arrayLength = value.length
    //cmd to use for the derivation
    var stdVar = "<plot_cmd>"
    var singleCmd = "<cmd>"
    var holdersOfValues = {"<x>","<y>"}
    var vBar = "vbar <x><y>,<y>"
    var hBar = "hbar <x><y>,<x>"
    var fill = "fill <x><y>"
    //holds current value
    var currentValues = ""

    //gets the final result to print the final output
    var finalResult = ""
    // while the counter is less than the arraylength and it hasnd reachend the loop will continue
    var commingToEnd = false
    var reachEnd = false

    //prints before reaching the 'end'
    while (counter < arrayLength && !reachEnd ) {
      //if not reachend
      if(!reachEnd)
      {
        if (currentValues.isEmpty() )// if the current value is empty prints the to plot_cmd end
        {
          System.out.print("to " + finalResult + stdVar + " end \n")// print finalresult and plot_cmd cmd

          currentValues = singleCmd//makes singlecmd = the currentvalue and currentCmdValues too

        }

        else if (value[counter + 2] != "end")// else if the current value != to end
        {
          //append the cmd to currentValues
          currentValues = currentValues + ";" + singleCmd

        }
        var temp = 0
        if(value[counter + 2].isEmpty() )//check if the current value is empty and if yes temp = 1, so as to skip that value
          temp = 1

        if(value[counter + temp + 2] == "end" || value[counter + 2].isEmpty() )// if current value == end or it is empty
        {
          commingToEnd = true
        }

        if (finalResult.isEmpty() && arrayLength > 5)//if final result and arry length is less than 5 then the output is printed
        {
          System.out.print("to " + finalResult + singleCmd + "; " + stdVar + " end \n")
        }

        else
        {
          if( value[counter + 2] != "end" && !commingToEnd && arrayLength > 5)//if value counter +2 and arry length greater than 5 and not coming to end prints the cmd
          {
            //print current values plus a plot_cmd
            System.out.print("to " + finalResult + singleCmd + "; " + stdVar + " end \n")
          }

          else
          {
            //else print current values plus a cmd only
            commingToEnd = true
            System.out.print("to " + finalResult + singleCmd + " end \n")
          }

        }


      }
      switch (value[counter])// checks  the current values for vbar | fill | hbar
      {
        case "hbar":
        {
          var tempy = 0
          var tempVal = "; <plot_cmd> "

          if(value[counter + 2].isEmpty() )//check if it is empty and sets temp to 1
            tempy = 1
          if(value[counter + tempy + 2] == "end" || value[counter + 2].isEmpty() )// check if it == end
          {
            tempVal = ""//so as to erase the ;plot_cmd since there is no front values to be evaluated
            commingToEnd = true
          }

          if(!commingToEnd)// if not coming to the end
            print("to " + finalResult + hBar + "; " + stdVar + " end")//print currents values of finalResult plus a hbar and a plot_cmd
          else
            print("to " + finalResult + hBar + " end")//print currents values of finalResult plus a hbar
          var simpleCounter = 0
          // print the cmd chars
            print("to " + finalResult + "hbar " + value[counter + 1].charAt(simpleCounter) + holdersOfValues[1] + "," + holdersOfValues[0] + tempVal + " end")
          simpleCounter ++
            print("to " + finalResult + "hbar " + value[counter + 1].charAt(simpleCounter - 1) + value[counter + 1].charAt(simpleCounter) + "," + holdersOfValues[0] + tempVal + " end")
          simpleCounter ++
            print("to " + finalResult + "hbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1 ) + "," + value[counter + 1].charAt(simpleCounter + 1)  + tempVal + " end")
          if ( value[counter + 2] == "end" || commingToEnd)
            finalResult = finalResult + "hbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1 ) + "," + value[counter + 1].charAt(simpleCounter + 1) + " "
          else
            finalResult = finalResult + "hbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1 ) + "," + value[counter + 1].charAt(simpleCounter + 1) + "; "

        }
        break
        case "vbar":
        {
          var tempy = 0
          var tempVal = "; <plot_cmd> "

          if(value[counter+2].isEmpty())// checks if it is not empty
            tempy = 1


          if(value[counter + tempy + 2] == "end")// check for end
          {
            tempVal = ""//so as to erase the ;plot_cmd since there is no front values to be evaluated
            commingToEnd = true
          }

          if(!commingToEnd)// check if not coming to end
            print("to " + finalResult + vBar + "; " + stdVar + " end")//prints the finalResult with a vbar and plot_cmd
          else
            print("to " + finalResult + vBar + " end")//else just prints the finalResult with a vbar
          var simpleCounter = 0

          // print the cmd chart
          print("to " + finalResult + "vbar " + value[counter + 1].charAt(simpleCounter) + holdersOfValues[1] + "," + holdersOfValues[1] + tempVal + " end")
          simpleCounter ++
          print("to " + finalResult + "vbar "  + value[counter + 1].charAt(simpleCounter - 1) + value[counter + 1].charAt(simpleCounter) + "," + holdersOfValues[1] + tempVal + " end")
          simpleCounter ++
          print("to " + finalResult + "vbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "," + value[counter + 1].charAt(simpleCounter + 1) + tempVal + " end")
          if ( value[counter + 2] == "end" || commingToEnd)
            finalResult = finalResult + "vbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "," + value[counter + 1].charAt(simpleCounter + 1)
          else
            finalResult = finalResult + "vbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "," + value[counter + 1].charAt(simpleCounter + 1) + "; "
          }

        break
        case "fill":
        {
          var tempy =0
          var simpleCounter = 0
          var tempVal = "; <plot_cmd> "

          if(value[counter+2].isEmpty())//check if it is empty
            tempy = 1

          if(value[counter + tempy + 2] == "end")// check for end
          {
            tempVal = ""//so as to erase the ;plot_cmd since there is no front values to be evaluated
            commingToEnd = true
          }

          if(!commingToEnd)// check if not coming to end
            print("to " + finalResult + fill + "; " + stdVar + " end")//prints the finalResult with a fill and plot_cmd
          else
            print("to " + finalResult + fill + " end")//else just prints the finalResult with a vbar

          if(value[counter+2] == "end")//check if currentState + 2 == end
          {
            tempVal = ""//so as to erase the ;plot_cmd since there is no front values to be evaluated
          }
          // print the cmd chart
          print("to " + finalResult + "fill " + value[counter + 1].charAt(simpleCounter) + holdersOfValues[1] + tempVal + " end")
          simpleCounter ++
          print("to " + finalResult + "fill "  + value[counter + 1].charAt(simpleCounter - 1) + value[counter + 1].charAt(simpleCounter) + tempVal + " end")
          simpleCounter ++
          if ( value[counter + 2] == "end" || commingToEnd)
            finalResult = finalResult + "fill " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1)
          else
            finalResult = finalResult + "fill " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "; "
        }
        break
        default:
          print("")
      }
      //checks if currentvalues + 2 == ""
      if(value[counter+2].isEmpty())
      {
        counter++//increments counter
      }

      counter = counter + 2
      if ((counter + 1) == arrayLength || value[counter] == "end")//checks if values is end
      {
        reachEnd = true
      }

    }

    System.out.print("\n\n")

  }


    function parse_tree(value : String[]) : void {
      print("******************************************************* ")
      print("\t\tPrinting parse tree ")
      print("******************************************************* ")
      //creating a counter from 1
      var counter = 1
      //array size
      var arrayLength = value.length

      //holds current value
      var currentValues = ""

      //cmd to use for the derivation
      var holdersOfValues = {"<x>","<y>"}
      var stdVar = "<plot_cmd>"
      var singleCmd = "<cmd>"
      var vBar = "vbar <x><y>,<y>"
      var hBar = "hbar <x><y>,<x>"
      var fill = "fill <x><y>"

      //holds current value
      var finalResult = ""

      //holds current value
      var commingToEnd = false
      var reachEnd = false

      //prints before reaching the 'end'
      while (counter < arrayLength && !reachEnd ) {
        var spacer = ""
        if (counter > 1)//if not reachend
        {
          spacer = spacer + "\t"//create spacer for the pare tree
        }

        if(!reachEnd)//check if the cmd is near the end
        {

          if (currentValues.isEmpty() )// if the current value is empty prints the to programs and the following cmd plotcmd
          {
            print("    <program>     ")
            print("  /     |    \\ ")
            print("to " + finalResult + stdVar + " end ")

            currentValues = singleCmd

          }

          else if (value[counter + 2] != "end")// else if the current value != to end
          {
            //appends the single values to currentValues
            currentValues = currentValues + ";" + singleCmd //check here

          }
          var temp = 0
          if(value[counter + 2].isEmpty() )//check if the current value is empty and if yes temp = 1, so as to skip that value
            temp = 1

          if(value[counter + temp + 2] == "end" || value[counter + 2].isEmpty() )// if current value == end or it is empty
          {
            commingToEnd = true
          }

          if (finalResult.isEmpty() && arrayLength > 5)//if final result and arry length is less than 5 then the output is printed
          {
            var c = counter
            var space = ""
            while (c>1)//adds spacer as need, tab if one cmd has being process, 2 for 2 cmd process, etc
            {
              space = space + "\t"
              c = c -2
            }
            //printing the | following its next command
            System.out.print(space + "       |  \n")
            System.out.print(space + singleCmd + "; " + stdVar + "  \n")
            System.out.print(space + "  |  \n")
          }

          else
          {
            if( value[counter + 2] != "end" && !commingToEnd && arrayLength > 5)//if value counter +2 and arry length greater than 5 and not coming to end prints the cmd
            {
              var c = counter
              var space = ""
              while (c>1)//adds spacer as need, tab if one cmd has being process, 2 for 2 cmd process, etc
              {
                space = space + "\t"
                c = c -2
              }
              //printing the /|\ following its next command
              System.out.print(space + "  / \n")
              System.out.print(space + singleCmd + "; " + stdVar + "\n")
              System.out.print(space + " |     \n")
            }

            else
            {
              //else print current values plus a cmd only
              var c = counter
              var space = ""
              while (c>1)//adds spacer as need, tab if one cmd has being process, 2 for 2 cmd process, etc
              {
                space = space + " \t "
                c = c -2
              }
              //printing the /|\ following its next command
              System.out.print(space + "     / \n")
              commingToEnd = true
              System.out.print(space + singleCmd + "\n")
              System.out.print(space + "    |  \n")
            }

          }

        }
        switch (value[counter])// checks  the current values for vbar | fill | hbar
        {
          case "hbar":
          {
            var tempy = 0
            var tempVal = "; <plot_cmd> "

            if(value[counter + 2].isEmpty() )//check if it is empty and sets temp to 1
              tempy = 1
            if(value[counter + tempy + 2] == "end" || value[counter + 2].isEmpty() )// check if it empty or == end
            {
              tempVal = ""//so as to erase the ;plot_cmd since there is no front values to be evaluated
              commingToEnd = true
            }

            var c = counter
            if(!commingToEnd)//check if the program is near the end
            {

              var space = ""
              while (c > 1)//adds spacer as need, tab if one cmd has being process, 2 for 2 cmd process, etc
              {
                space = space + "\t"
                c = c-2
              }
              //printing the /|\ following its next command
              System.out.print(space + hBar + "; " + stdVar + " \n")//prints the hbar with a plot cmd
              System.out.print(space + "     / \n")

            }

            else
            {
              c = counter
              var space = ""
              while (c > 1)//adds spacer as need, tab if one cmd has being process, 2 for 2 cmd process, etc
              {
                space = space + "\t"
                c = c-2
              }
              //printing the /|\ following its next command
              System.out.print( space + hBar + "\n")//prints the hbar
              System.out.print(space + "     / \n")
            }
            var simpleCounter = 0

            c = counter
            var space = ""
            while (c > 1)//adds spacer as need, tab if one cmd has being process, 2 for 2 cmd process, etc
            {
              space = space + "\t"
              c = c-2
            }
            //printing the /|\ following its next command

            System.out.print( space + "hbar " + value[counter + 1].charAt(simpleCounter) + holdersOfValues[1] + "," + holdersOfValues[0] + tempVal + "\n")
            simpleCounter ++
            System.out.print(space + "       /\n")
            System.out.print(space + "hbar " + value[counter + 1].charAt(simpleCounter - 1) + value[counter + 1].charAt(simpleCounter) + "," + holdersOfValues[0] + tempVal+ "\n")
            simpleCounter ++
            System.out.print(space + "         / \n")
            print(space + "hbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "," + value[counter + 1].charAt(simpleCounter + 1) + tempVal  )
            if ( value[counter + 2] == "end" || commingToEnd)
              finalResult = finalResult + "hbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1 ) + "," + value[counter + 1].charAt(simpleCounter + 1) + " "
            else
              finalResult = finalResult + "hbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1 ) + "," + value[counter + 1].charAt(simpleCounter + 1) + "; "

          }
          break
          case "vbar":
          {
            var tempy = 0
            var tempVal = "; <plot_cmd> "
            var c = counter
            c = counter
            var space = ""
            while (c > 1)//adds spacer as need, tab if one cmd has being process, 2 for 2 cmd process, etc
            {
              space = space  + " \t "
              c = c-2
            }

            if(value[counter+2].isEmpty())//check if it is empty and sets temp to 1
              tempy = 1


            if(value[counter + tempy + 2] == "end")// check if it or == end
            {
              tempVal = ""//so as to erase the ;plot_cmd since there is no front values to be evaluated
              commingToEnd = true
            }

            if(!commingToEnd)
            {
              //printing the /|\ following its next command
              System.out.print(space + vBar + "; " + stdVar + "\n")
              System.out.print(space + "      / \n")
            }
            else {
              //printing the /|\ following its next command
              System.out.print( space + vBar + "\n")
              System.out.print(space + "      / \n")

            }
            var simpleCounter = 0

            //printing the /|\ following its next command
            System.out.print(space +  "vbar " + value[counter + 1].charAt(simpleCounter) + holdersOfValues[1] + "," + holdersOfValues[1] + tempVal)
            simpleCounter ++

            System.out.print("\n" + space +  "      / \n")

            System.out.print(space +  "vbar " + value[counter + 1].charAt(simpleCounter - 1) + value[counter + 1].charAt(simpleCounter) + "," + holdersOfValues[1] + tempVal)
            simpleCounter ++

            System.out.print("\n" + space +   "        / \n")
            System.out.print(space + "vbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "," + value[counter + 1].charAt(simpleCounter + 1) + tempVal + "\n")
            if ( value[counter + 2] == "end" || commingToEnd)
              finalResult = finalResult + "vbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "," + value[counter + 1].charAt(simpleCounter + 1)
            else
              finalResult = finalResult + "vbar " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "," + value[counter + 1].charAt(simpleCounter + 1) + "; "
          }

          break
          case "fill":
          {
            var tempy =0
            var simpleCounter = 0
            var tempVal = "; <plot_cmd> "
            var c = counter


            if(value[counter+2].isEmpty())//check if it is empty and sets temp to 1
              tempy = 1

            if(value[counter + tempy + 2] == "end")// check if it  == end
            {
              tempVal = ""//so as to erase the ;plot_cmd since there is no front values to be evaluated
              commingToEnd = true
            }

            c = counter
            var space = ""
            while (c > 1)//adds spacer as need, tab if one cmd has being process, 2 for 2 cmd process, etc
            {
              space = space + " \t "
              c = c-2
            }
            //printing the /|\ following its next command
            if(!commingToEnd)//checks if programs is not near the end
            {
              System.out.print( space + fill + "; " + stdVar + " \n")//prints a fill with plotcmd
            }
            else
            {
              System.out.print( space + fill + " \n")//print fill cmd onlt
            }

            if(value[counter+2] == "end")// check if it == end
            {
              tempVal = ""//so as to erase the ;plot_cmd since there is no front values to be evaluated
            }
            //printing the /|\ following its next command
            System.out.print( space + "      / \n")

            System.out.print( space +  "fill " + value[counter + 1].charAt(simpleCounter) + holdersOfValues[1] + tempVal)
            simpleCounter ++

            System.out.print("\n" +space + "       /\n")

            System.out.print( space + "fill " + value[counter + 1].charAt(simpleCounter - 1) + value[counter + 1].charAt(simpleCounter) + tempVal + "\n")
            simpleCounter ++
            if ( value[counter + 2] == "end" || commingToEnd)
              finalResult = finalResult + "fill " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1)
            else
              finalResult = finalResult + "fill " + value[counter + 1].charAt(simpleCounter - 2) + value[counter + 1].charAt(simpleCounter - 1) + "; "
          }
          break
          default:
            print("")
        }


        if(value[counter+2].isEmpty())//checks if currentvalues + 2 == ""
        {
          counter++//increments counter
        }

        counter = counter + 2
        if ((counter + 1) == arrayLength || value[counter] == "end")//check if the program is near the end or if it has a next value to evaluate
        {
          reachEnd = true
        }



      }
      //prints the final result
      System.out.print("\n\n to " + finalResult + " end \n\n")

    }
}


//create an instance of recognizer class
var program_recognizer = new recognizer()
program_recognizer.MAIN()


