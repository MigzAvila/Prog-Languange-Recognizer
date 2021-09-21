uses java.io.InputStreamReader
uses java.util.Scanner
uses java.lang.System

var sc = new Scanner( new InputStreamReader( System.in ) )

    var str= sc.nextLine();              //reads string
    print(str)


public class Foo {
  var _bar = "bar"

  property get Bar() : String {
    return _bar
  }
  property set Bar( value : String ) {
    if(value == "Foo") throw "That's not a valid value for Bar!"
    _bar = value
  }
}

var f = new Foo()
    f.Bar = "su"
    print( f.Bar )