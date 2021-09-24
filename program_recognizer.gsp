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

  //change to validate input cmd
  function MAIN(value : String) : boolean {

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

      //loop for 2 in a single loop - passes <plot_cmd> with <cmd> <cmd> to check if there is to be expect a next <plot_cmd>
      while (count < plot_Cmd.length - 1) {
        //checks that next value exists in array plot_cmd
        if (count + 1 <= plot_Cmd.length) {
          var current = {plot_Cmd[count], plot_Cmd[count + 1]}
          var plotcmd = current.toTypedArray()
          //validates single command
          var res = validates_cmd(plotcmd)
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
        print("Unrecognized value: " + firstVal + " " + holder)
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
      if (counter > 1 && counter < 3) {
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
        } else {
          prevHasSemiColon = false
          return false
        }
      }
      //check if cmd is fill
      else if (firstVal.toLowerCase() == "fill") {
        //check if cmd values has semicolon
        var hasSemiColon = (holder.charAt(holder.length() - 1)) == ';'
        if (hasSemiColon) {
          return true
        } else {
          prevHasSemiColon = false
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
    print("NEVER REACH HERE")
    return false
  }

  function print(value : String[]) : void {
    print("Printing Derevation ")
    var val = value
    //removing the length -1 and removeing the count of to & end
    var counter = 1
    var arrayLength = value.length
    var len = value.length - 1
    var reachEnd = false
    var stdVar = "<plot_cmd>"
    var singleCmd = "<cmd>"
    var currentValues = ""
    var currentCmd = " "
    var currentCmdValues = ""
    var holdersOfValues = {"<x>","<y>"}

    var vBar = "vbar <x><y>,<y>"
    var hBar = "hbar <x><y>,<x>"
    var fill = "fill <x><y>"
    var finalResult = ""
    var commingToEnd = false

    while (counter < arrayLength && !reachEnd ) {

      if(!reachEnd)
      {
        if (currentValues.isEmpty() )
        {
          System.out.print("to " + finalResult + stdVar + " end \n")

          currentValues = singleCmd
          currentCmdValues = singleCmd

        }

        else if (value[counter + 2] != "end")
        {
          currentValues = currentValues + ";" + singleCmd //check here

          currentCmdValues = currentCmdValues + ";" + singleCmd
        }
        var temp = 0
        if(value[counter + 2].isEmpty() )
          temp = 1
        if(value[counter + temp + 2] == "end" || value[counter + 2].isEmpty() )
        {
          commingToEnd = true
        }

        if (finalResult.isEmpty() && arrayLength > 5)
        {
          System.out.print("to " + finalResult + singleCmd + "; " + stdVar + " end \n")
        }

        else
        {
          if( value[counter + 2] != "end" && !commingToEnd && arrayLength > 5)
          {
            System.out.print("to " + finalResult + singleCmd + "; " + stdVar + " end \n")
          }

          else
          {
            commingToEnd = true
            System.out.print("to " + finalResult + singleCmd + " end \n")
          }

        }


      }
      switch (value[counter])
      {
        case "hbar":
        {
          var tempy = 0
          var tempVal = "; <plot_cmd> "

          if(value[counter + 2].isEmpty() )
            tempy = 1
          if(value[counter + tempy + 2] == "end" || value[counter + 2].isEmpty() )
          {
            tempVal = ""
            commingToEnd = true
          }

          currentCmd = currentCmd + hBar + "; "
          if(!commingToEnd)
            print("to " + finalResult + hBar + "; " + stdVar + " end")
          else
            print("to " + finalResult + hBar + " end")
          var simpleCounter = 0

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

          if(value[counter+2].isEmpty())
            tempy = 1


          if(value[counter + tempy + 2] == "end")
          {
            tempVal = ""
            commingToEnd = true
          }

          currentCmd = currentCmd + vBar + "; "

          if(!commingToEnd)
            print("to " + finalResult + vBar + "; " + stdVar + " end")
          else
            print("to " + finalResult + vBar + " end")
          var simpleCounter = 0

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

          if(value[counter+2].isEmpty())
            tempy = 1

          if(value[counter + tempy + 2] == "end")
          {
            tempVal = ""
            commingToEnd = true
          }

          currentCmd = currentCmd + fill + "; "

          if(!commingToEnd)
            print("to " + finalResult + fill + "; " + stdVar + " end")
          else
            print("to " + finalResult + fill + " end")

          if(value[counter+2] == "end")
          {
            tempVal = ""
          }

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

      if(value[counter+2].isEmpty())
      {
        counter++
      }

      counter = counter + 2
      if ((counter + 1) == arrayLength || value[counter] == "end")
      {
        reachEnd = true
      }

    }

    System.out.print("\n\n")

  }


    function parse_tree(value : String[]) : void {
      print("Printing Derevation ")
      //removing the length -1 and removeing the count of to & end
      var counter = 1
      var arrayLength = value.length
      var len = value.length - 1
      var reachEnd = false
      var stdVar = "<plot_cmd>"
      var singleCmd = "<cmd>"
      var currentValues = ""
      var currentCmd = " "
      var currentCmdValues = ""
      var holdersOfValues = {"<x>","<y>"}

      var vBar = "vbar <x><y>,<y>"
      var hBar = "hbar <x><y>,<x>"
      var fill = "fill <x><y>"
      var finalResult = ""
      var commingToEnd = false

      while (counter < arrayLength && !reachEnd ) {

        if(!reachEnd)
        {
          if (currentValues.isEmpty() )
          {
            System.out.print("  <program>      \n")
            System.out.print("  /     |    \\ \n")
            System.out.print("to " + finalResult + stdVar + " end \n")

            currentValues = singleCmd
            currentCmdValues = singleCmd

          }

          else if (value[counter + 2] != "end")
          {
            currentValues = currentValues + ";" + singleCmd //check here

            currentCmdValues = currentCmdValues + ";" + singleCmd
          }
          var temp = 0
          if(value[counter + 2].isEmpty() )
            temp = 1
          if(value[counter + temp + 2] == "end" || value[counter + 2].isEmpty() )
          {
            commingToEnd = true
          }

          if (finalResult.isEmpty() && arrayLength > 5)
          {
            System.out.print("  /     /   \  \\ \n")
            System.out.print("to " + finalResult + singleCmd + "; " + stdVar + " end \n")
          }

          else
          {
            if( value[counter + 2] != "end" && !commingToEnd && arrayLength > 5)
            {
              System.out.print("  /     /   \  \\ \n")
              System.out.print("to " + finalResult + singleCmd + "; " + stdVar + " end \n")
            }

            else
            {
              System.out.print("  /     |  \\ \n")
              commingToEnd = true
              System.out.print("to " + finalResult + singleCmd + " end \n")
            }

          }


        }
        switch (value[counter])
        {
          case "hbar":
          {
            var tempy = 0
            var tempVal = "; <plot_cmd> "

            if(value[counter + 2].isEmpty() )
              tempy = 1
            if(value[counter + tempy + 2] == "end" || value[counter + 2].isEmpty() )
            {
              tempVal = ""
              commingToEnd = true
            }

            currentCmd = currentCmd + hBar + "; "
            if(!commingToEnd)
              print("to " + finalResult + hBar + "; " + stdVar + " end")
            else
              print("to " + finalResult + hBar + " end")
            var simpleCounter = 0

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

            if(value[counter+2].isEmpty())
              tempy = 1


            if(value[counter + tempy + 2] == "end")
            {
              tempVal = ""
              commingToEnd = true
            }

            currentCmd = currentCmd + vBar + "; "

            if(!commingToEnd)
              print("to " + finalResult + vBar + "; " + stdVar + " end")
            else
              print("to " + finalResult + vBar + " end")
            var simpleCounter = 0

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

            if(value[counter+2].isEmpty())
              tempy = 1

            if(value[counter + tempy + 2] == "end")
            {
              tempVal = ""
              commingToEnd = true
            }

            currentCmd = currentCmd + fill + "; "

            if(!commingToEnd)
              print("to " + finalResult + fill + "; " + stdVar + " end")
            else
              print("to " + finalResult + fill + " end")

            if(value[counter+2] == "end")
            {
              tempVal = ""
            }

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

        if(value[counter+2].isEmpty())
        {
          counter++
        }

        counter = counter + 2
        if ((counter + 1) == arrayLength || value[counter] == "end")
        {
          reachEnd = true
        }

      }

      System.out.print("\n\n")

    }
}




//prints commands
print(program)
print(plot_cmd)
print(cmd)
print(x)
print(y)
print(good_exm)
print(bad_exm)

print("Your Turn Now: \n")

//scan for input
var sc = new Scanner( new InputStreamReader( System.in ) )
var str= sc.nextLine();              //reads string
var isWhiteSpace = str.split(" ")

//create an instance of recognizer class
var f = new recognizer()

//call MAIN function
//create a while loop ...
var result = false
if(str !=  "STOP" )
{
  result = f.MAIN(str)
  if(result)
  {
    f.print(str.split("\\s"))
    f.parse_tree(str.split("\\s"))
  }
}


while (str !=  "STOP" )
{
  if (isWhiteSpace.length < 4)
  {
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
  str= sc.nextLine();              //reads string
  isWhiteSpace = str.split(" ")
  if (str !=  "STOP" || isWhiteSpace.length != 0) {
    result = f.MAIN(str)
    print("\n\n")
    if(result)
    {
      f.print(str.split("\\s"))
      f.parse_tree(str.split("\\s"))
    }

  }

}

