/// examples for ObjectScript Tutorial
Class ObjectScript.Examples
{

/// demo of public and private methods, along with a public variable
ClassMethod PrivatePublic()
{
  Do ..Private()   // call a private method
  Do ..Public(9)	// call a public method
}

/// a private method with public variable a
ClassMethod Private() [ Private, PublicList = a ]
{
  Write !, "setting a"  set a = 1
  Write !, "setting b"  set b = 2
  Write !, "setting c"  set c = 3
  Write !, "setting d"  set d = 4
}

/// a public method with an argument and a return value
ClassMethod Public(num As %Numeric) As %String
{
  Write !, "my favorite number is ", num
  Return "This is my return value!!!"
}

/// demo of passing arguments by value and reference
ClassMethod PassingArguments(num As %Numeric)
{
  // pass by value    read !, "Enter a number: ", num
  Set dblnum = ..DoubleByVal(num)
  Write !, "By Value: ", num, " doubled is: ", dblnum

  // num passed IN and OUT by reference
  Write !, "By Reference 1: ", num
  Do ..DoubleByRef1(.num)
  Write " doubled is: ", num

  // num passed IN by value, result passed OUT by reference
  Do ..DoubleByRef2(num, .result)
  Write !, "By Reference 2: ", num, " doubled again is: ", result
}

ClassMethod DoubleByVal(anynumber As %Numeric) As %Numeric
{
  Return anynumber * 2
}

ClassMethod DoubleByRef1(ByRef anynumber As %Numeric)
{
  Set anynumber = anynumber * 2
}

ClassMethod DoubleByRef2(anynumber As %Numeric, Output retnumber As %Numeric)
{
  Set retnumber = anynumber * 2
}

/// demo of <UNDEFINED> error
ClassMethod BadMethod()
{
  Set a = 1
  Set b = 2
  Write c
}

/// root for my favorite team
ClassMethod Root()
{
  Read "Team: ", t
  If (t = "") { quit }  // stop execution if no team is specified
  If (t = "METS") {
    Write !, "Go METS!" }
    Else {
      Write !, "Boo ", t, "!" }
}

/// demos of many Ifs 
ClassMethod If()
{
  Set x = 5, y = 0, z = -5
  If (x = 5) { Write !, "x is equal to 5" } Else { Write !, "false" }
  If (x = 10) { Write !, "x is equal to 10" } Else { Write !, "false" }
  If (x < y) { Write !, "x is less than y" } Else { Write !, "false" }
  If (x > y) { Write !, "x is greater than y" } Else { Write !, "false" }
  Write !
  If (##class(%SYSTEM.Util).NumberOfCPUs() > 2) { Write !, "there are more than 2 CPUs" } Else { Write !, "false" }
  If (x > $ZSqr(64)) { Write !, "x is greater than square root of 64" } Else { Write !, "false" }
  Write !
  If (x && y) { Write !, "both x and y are true (non-zero)" } Else { Write !, "false" }
  If (x && z) { Write !, "both x and z are true (non-zero)" } Else { Write !, "false" }
  If (x && y && z) { Write !, "x, y, and z are all true (non-zero)" } Else { Write !, "false" }
  If (x || y || z) { Write !, "at least one of x, y, or z is true (non-zero)" } Else { Write !, "false" }
  Write !
  If ((x > y) || (y < z)) { Write !, "either x is greater than y OR y is less than z" } Else { Write !, "false" }
  If (x > y || y < z) { Write !, "without proper parentheses, this expression is false" } Else { Write !, "false" }
  If ((x > y) && (z < y)) { Write !, "x is greater than y AND z is less than y" } Else { Write !, "false" }
  If (x > y && z < y) { Write !, "without proper parentheses, this expression is also false" } Else { Write !, "false" }
  Write !
  If 'x { Write !, "x is not true (zero)" } Else { Write !, "false" }
  If 'y { Write !, "y is not true (zero)" } Else { Write !, "false" }
  If (x '< y) { Write !, "x is not less than y" } Else { Write !, "false" }
  If '(x < y) { Write !, "x is not less than y" } Else { Write !, "false" }
}

ClassMethod Celebrate()
{
  Write !, "Yippee! I won!"
}

ClassMethod Complain()
{
  Write !, "Oh well, I lost."
}

/// demos of the For construct
ClassMethod For()
{
  For i = 1:1:8 {
    Write !, "I ", i, " the sandbox."
  }
  Write !!
  For b = "John", "Paul", "George", "Ringo" {
    Write !, "Was ", b, " the leader? "
    Read yn
  }
  Write !!
  For i = 1:1 {
    Read !, "Capital of MA? ", a
    If (a = "BOSTON") {
      Write "...did it in ", i, " tries"
      Quit
    }
  }
  Write !!
  For i = 1:1 {
    Read !, "Capital of TX? ", a
    Continue:(a '= "AUSTIN")
    Write "...did it in ", i, " tries"
    Quit
  }
  Write !!
  For {
    Read !, "Know what? ", wh
    Quit:(wh = "NO!")
    Write "   That's what!"
  }
}

/// generate Fibonacci sequences
ClassMethod Fibonacci()
{
  Read !, "Generate Fibonacci sequence up to where? ", upto

  Set t1 = 1, t2 = 1, fib = 1
  Write !
  Do {
    Write fib, "  "
    Set fib = t1 + t2, t1 = t2, t2 = fib
  }
  While (fib '> upto)

  Set t1 = 1, t2 = 1, fib = 1
  Write !
  While (fib '> upto) {
    Write fib, "  "
    Set fib = t1 + t2, t1 = t2, t2 = fib
  }
}

/// examples of system and custom exceptions
ClassMethod Exceptions(x As %Numeric)
{
  // <UNDEFINED> error throws a system exception
  Try {
    Write "Hello!", !, xyz
  }
  Catch err {
    Write !, "Error name: ", ?20, err.Name,
		      !, "Error code: ", ?20, err.Code,
		      !, "Error location: ", ?20, err.Location,
		      !, "Additional data: ", ?20, err.Data, !
  }

  // <DIVIDE> error throws a system exception
  Try {
    Write 1/0
  }
  Catch err {
    Write !, "Error name: ", ?20, err.Name,
		      !, "Error code: ", ?20, err.Code,
		      !, "Error location: ", ?20, err.Location,
		      !, "Additional data: ", ?20, err.Data, !
  }

  // create a simple custom exception object and throw it
  Set ex = ##class(%Exception.General).%New()
  Set ex.Name = "Demo Exception",
  ex.Code = 100000,
  ex.Data = "Tutorial Example"
  Try {
    Write !, "Hello!", !
    If (x >= 5) throw ex  // throw the exception
  }
  Catch err {
    Write !, "Error name: ", ?20, err.Name,
		      !, "Error code: ", ?20, err.Code,
		      !, "Error location: ", ?20, err.Location,
		      !, "Additional data: ", ?20, err.Data, !
    If (x = 5) return  // terminate method
  }
  Write !, "Finished!"
}

/// examples of JSON
ClassMethod JSON()
{
  // create a JSON object
  Set jo1 = {"PartNum":"678LM", "Price":"7.99", "Quantity":"100" }
  // create a JSON array, and add it to the object
  Set ar1 = ["Small","Large"], jo1.Sizes = ar1
  // change a size in the 0-based JSON array
  Set ar1."0" = "Tiny"
  // turn the JSON into a string and display it
  Set string1 = jo1.%ToJSON()
  Write !, "First JSON object: ", !, string1

  // create a text string in JSON format
  Set string2 = "{""PartNum"":""345JK"", ""Price"":5.99, ""Sizes"":[""Small"", ""Medium"", ""Large""], ""Quantity"":50}"
  // create an object from the string
  Set jo2 = ##class(%DynamicObject).%FromJSON(string2)
  // display the properties of the object
  Write !!, "Second JSON Object:"
  Write !, "Part Number: ", jo2.PartNum, " Price: ", jo2.Price, " Quantity: ", jo2.Quantity
  Write !, "Sizes"
  // loop through the array using an iterator
  Set ar2 = jo2.Sizes
  Set iter = ar2.%GetIterator()
  While iter.%GetNext(.key , .value ) {
    Write !, ?5, "Key: ", key, ", Size: ", value
  }

  // change some of the properties
  Set jo2.Price = "8.99", jo2.Quantity = 75
  // push a new size onto the end of the array
  Do ar2.%Push("Extra Large")
  // turn the JSON into a string and display it
  Write !!, "Changed Second JSON Object:"
  Set newstring = jo2.%ToJSON()
  Write !, newstring
}

/// loop through last names of the ^PersonI global, 2 different ways
ClassMethod SimpleLoop()
{
  Write !, "Using argumentless For"
  Set ln = ""  // initialize to the empty string to make $Order return the first last name
  For {        // start looping
    Set ln = $Order(^PersonI("Name", ln))  // use the current last name to get the next
    Quit:(ln = "")                         // stop looping when ln becomes empty again
    Write !, ?5, ln
  }

  Write !!, "Using While"
  Set ln = $Order(^PersonI("Name", ""))  // get the first last name
  While (ln '= "") {                     // only loop if there is at least one last name
    Write !, ?5, ln
    Set ln = $Order(^PersonI("Name", ln))  // use the current last name to get the next
  }
}

/// Loop through the name index and display the records
ClassMethod NameLoop()
{
  // loop through last names
  Set ln = ""
  For {
    Set ln = $Order(^PersonI("Name", ln))
    Quit:(ln = "")
    // for each last name, loop through first names
    Set fn = ""
    For {
      Set fn = $Order(^PersonI("Name", ln, fn))
      Quit:(fn = "")
      // for each last name and first name, loop through id numbers
      Set id = ""
      For {
        Set id = $Order(^PersonI("Name", ln, fn, id))
        Quit:(id = "")
        // once you have an id number, get the data and display it
        Set rec = ^PersonD(id)
        Write !, $List(rec, 1),
                      ?15, $List(rec, 2),
                      ?30, $ZDate($List(rec, 3), 2)
      }
    }
  }
}

/// loop through last names that FOLLOW a substring (including the substring)
ClassMethod FocusedLoopStart()
{
  Read "Search for: ",substring
  // find the last name just BEFORE the substring and then start looping
  Set ln = $Order(^PersonI("Name", substring), -1)
  For {
    Set ln = $Order(^PersonI("Name", ln))
    Quit:(ln = "")
    Write !, ln
  }
}

/// loop through last names that MATCH substring
ClassMethod FocusedLoopStartEnd()
{
  Read "Search for: ",substring
  // find the last name just BEFORE the substring and then start looping
  Set ln = $Order(^PersonI("Name", substring), -1)
  For {
    Set ln = $Order(^PersonI("Name", ln))
    // quit if no match or at end
    Quit:($Extract(ln, 1, $Length(substring)) '= substring)
    Write !, ln
  }
}

/// examples of conversion methods
ClassMethod Conversions()
{
  Write !, "abcde becomes: ", $Translate("abcde", "ad", "yz")  // translate a->y, and d->z
  Write !, "abcde becomes: ", $Translate("abcde", "ad", "zz")  // translate a->z, and d->z
  Write !, "abcde becomes: ", $Translate("abcde", "ad", "z")   // translate a->z, and d->nothing
  Write !, "abcdebcbc becomes: ", $Translate("abcdebcbc", "abc", "yz")  // translate a->y, b->z, and c->nothing
  Write !, "abcdebcbc becomes: ", $Replace("abcdebcbc", "abc", "yz")    // replace abc->yz

  Read !, "String to translate: ", x
  Set lower = "abcdefghijklmnopqrstuvwxyz"
  Set upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  Write !, "Using $Translate: ", $Translate(x, lower,  upper)
  Write !, "Using $ZConvert: ", $ZConvert(x, "U")
  Write !, "Using $ZConvert for capitalizing words: ", $ZConvert(x, "W")
  Write !, "Using $ZStrip to remove whitespace: ", $ZStrip(x, "*W")
}

}
