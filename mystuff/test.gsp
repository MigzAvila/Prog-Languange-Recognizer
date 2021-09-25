function print(value : String[]) : void {

  var val = value
  //removing the length -1 and removeing the count of to & end
  var counter = 1
  var arrayLength = value.length
  //print("to <plot_cmd> end : " + value[0] + "  "  + arrayLength)
  var len = value.length - 1
  //var send = {val[1].toString(), val[2].toString()}
  //validates_cmd check for hbar vbar and fill
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
  var commingToEnd = false// while the counter is less than the arraylength and it hasnd reachend the loop will continue

  while (counter < arrayLength && !reachEnd ) {

    if(!reachEnd)//if not reachend
    {
      if (currentValues.isEmpty() ) // if the current value is empty is continues the loop
      {
        System.out.print("to " + finalResult + stdVar + " end \n") // print finalresult and stdvar

        currentValues = singleCmd//makes singlecmd = the currentvalue and currentCmdValues too
        currentCmdValues = singleCmd

      }

      else if (value[counter + 2] != "end")// els if the value is not = to end it will coninue with this condition
      {
        currentValues = currentValues + ";" + singleCmd //

        currentCmdValues = currentCmdValues + ";" + singleCmd//
      }
      var temp = 0
      if(value[counter + 2].isEmpty() )//check if it is empty and if yes temp = 1
        temp = 1
      if(value[counter + temp + 2] == "end" || value[counter + 2].isEmpty() ) // if it = to enc or it is empty
      {
        commingToEnd = true //coming to the end will be set to true
      }

      if (finalResult.isEmpty() && arrayLength > 5)//if final result and arry length is less than 5 then the output is printed
      {
        System.out.print("to " + finalResult + singleCmd + "; " + stdVar + " end \n")
      }

      else
      {
        if( value[counter + 2] != "end" && !commingToEnd && arrayLength > 5)//if value counter +2 and arry length greater than 5 and not coming to end prints the cmd
        {
          System.out.print("to " + finalResult + singleCmd + "; " + stdVar + " end \n")
        }

        else
        {
          commingToEnd = true//else prints the cmd below
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

        if(value[counter + 2].isEmpty() )//chekck if it is empty and sets temp to 1
          tempy = 1
        if(value[counter + tempy + 2] == "end" || value[counter + 2].isEmpty() )// check if it empty or = to end
        {
          tempVal = ""
          commingToEnd = true
        }

        currentCmd = currentCmd + hBar + "; "
        if(!commingToEnd)// if not coming to the end
          print("to " + finalResult + hBar + "; " + stdVar + " end")
        else
          print("to " + finalResult + hBar + " end")
        var simpleCounter = 0


// print the cmd chart

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
          tempVal = ""
          commingToEnd = true
        }

        currentCmd = currentCmd + vBar + "; "

        if(!commingToEnd)// check if not coming to end
          print("to " + finalResult + vBar + "; " + stdVar + " end")
        else
          print("to " + finalResult + vBar + " end")
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
          tempVal = ""
          commingToEnd = true
        }

        currentCmd = currentCmd + fill + "; "

        if(!commingToEnd)//check if it is empty
          print("to " + finalResult + fill + "; " + stdVar + " end")
        else
          print("to " + finalResult + fill + " end")

        if(value[counter+2] == "end")// check for end
        {
          tempVal = ""
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

    if(value[counter+2].isEmpty())//check if it is empty
    {
      counter++
    }

    counter = counter + 2
    if ((counter + 1) == arrayLength || value[counter] == "end")// check for end
    {
      reachEnd = true
    }

  }

  System.out.print("to " + finalResult + " end \n\n\n")

}