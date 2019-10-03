/// examples for ObjectScript Tutorial
Class ObjectScript.Examples
{

/// demo of public and private methods, along with a public variable
ClassMethod PrivatePublic()
{
  do ..Private()   // call a private method
  do ..Public(9)	// call a public method
}

/// a private method with public variable a
ClassMethod Private() [ Private, PublicList = a ]
{
  write !, "setting a"  set a = 1
  write !, "setting b"  set b = 2
  write !, "setting c"  set c = 3
  write !, "setting d"  set d = 4
}

/// a public method with an argument and a return value
ClassMethod Public(num As %Numeric) As %String
{
  write !, "my favorite number is ", num
  return "This is my return value!!!"
}

/// demo of passing arguments by value and reference
ClassMethod PassingArguments(num As %Numeric)
{
  // pass by value    read !, "Enter a number: ", num
  set dblnum = ..DoubleByVal(num)
  write !, "By Value: ", num, " doubled is: ", dblnum

  // num passed IN and OUT by reference
  write !, "By Reference 1: ", num
  do ..DoubleByRef1(.num)
  write " doubled is: ", num

  // num passed IN by value, result passed OUT by reference
  do ..DoubleByRef2(num, .result)
  write !, "By Reference 2: ", num, " doubled again is: ", result
}

ClassMethod DoubleByVal(anynumber As %Numeric) As %Numeric
{
  return anynumber * 2
}

ClassMethod DoubleByRef1(ByRef anynumber As %Numeric)
{
  set anynumber = anynumber * 2
}

ClassMethod DoubleByRef2(anynumber As %Numeric, Output retnumber As %Numeric)
{
  set retnumber = anynumber * 2
}

/// demo of <UNDEFINED> error
ClassMethod BadMethod()
{
  set a = 1
  set b = 2
  write c
}

/// root for my favorite team
ClassMethod Root()
{
  read "Team: ", t
  if (t = "") { quit }  // stop execution if no team is specified
  if (t = "METS") {
    write !, "Go METS!" }
    else {
      write !, "Boo ", t, "!" }
}

/// demos of many Ifs 
ClassMethod If()
{
  set x = 5, y = 0, z = -5
  if (x = 5) { write !, "x is equal to 5" } else { write !, "false" }
  if (x = 10) { write !, "x is equal to 10" } else { write !, "false" }
  if (x < y) { write !, "x is less than y" } else { write !, "false" }
  if (x > y) { write !, "x is greater than y" } else { write !, "false" }
  write !
  if (##class(%SYSTEM.Util).NumberOfCPUs() > 2) { write !, "there are more than 2 CPUs" } else { write !, "false" }
  if (x > $zsqr(64)) { write !, "x is greater than square root of 64" } else { write !, "false" }
  write !
  if (x && y) { write !, "both x and y are true (non-zero)" } else { write !, "false" }
  if (x && z) { write !, "both x and z are true (non-zero)" } else { write !, "false" }
  if (x && y && z) { write !, "x, y, and z are all true (non-zero)" } else { write !, "false" }
  if (x || y || z) { write !, "at least one of x, y, or z is true (non-zero)" } else { write !, "false" }
  write !
  if ((x > y) || (y < z)) { write !, "either x is greater than y OR y is less than z" } else { write !, "false" }
  if (x > y || y < z) { write !, "without proper parentheses, this expression is false" } else { write !, "false" }
  if ((x > y) && (z < y)) { write !, "x is greater than y AND z is less than y" } else { write !, "false" }
  if (x > y && z < y) { write !, "without proper parentheses, this expression is also false" } else { write !, "false" }
  write !
  if 'x { write !, "x is not true (zero)" } else { write !, "false" }
  if 'y { write !, "y is not true (zero)" } else { write !, "false" }
  if (x '< y) { write !, "x is not less than y" } else { write !, "false" }
  if '(x < y) { write !, "x is not less than y" } else { write !, "false" }
}

ClassMethod Celebrate()
{
  write !, "Yippee! I won!"
}

ClassMethod Complain()
{
  write !, "Oh well, I lost."
}

/// demos of the For construct
ClassMethod For()
{
  for i = 1:1:8 {
    write !, "I ", i, " the sandbox."
  }
  write !!
  for b = "John", "Paul", "George", "Ringo" {
    write !, "Was ", b, " the leader? "
    read yn
  }
  write !!
  for i = 1:1 {
    read !, "Capital of MA? ", a
    if (a = "BOSTON") {
      write "...did it in ", i, " tries"
      quit
    }
  }
  write !!
  for i = 1:1 {
    read !, "Capital of TX? ", a
    continue:(a '= "AUSTIN")
    write "...did it in ", i, " tries"
    quit
  }
  write !!
  for {
    read !, "Know what? ", wh
    quit:(wh = "NO!")
    write "   That's what!"
  }
}

/// generate Fibonacci sequences
ClassMethod Fibonacci()
{
  read !, "Generate Fibonacci sequence up to where? ", upto

  set t1 = 1, t2 = 1, fib = 1
  write !
  do {
    write fib, "  "
    set fib = t1 + t2, t1 = t2, t2 = fib
  }
  while (fib '> upto)

  set t1 = 1, t2 = 1, fib = 1
  write !
  while (fib '> upto) {
    write fib, "  "
    set fib = t1 + t2, t1 = t2, t2 = fib
  }
}

/// examples of system and custom exceptions
ClassMethod Exceptions(x As %Numeric)
{
  // <UNDEFINED> error throws a system exception
  try {
    write "Hello!", !, xyz
  }
  catch err {
    write !, "Error name: ", ?20, err.Name,
		      !, "Error code: ", ?20, err.Code,
		      !, "Error location: ", ?20, err.Location,
		      !, "Additional data: ", ?20, err.Data, !
  }

  // <DIVIDE> error throws a system exception
  try {
    write 1/0
  }
  catch err {
    write !, "Error name: ", ?20, err.Name,
		      !, "Error code: ", ?20, err.Code,
		      !, "Error location: ", ?20, err.Location,
		      !, "Additional data: ", ?20, err.Data, !
  }

  // create a simple custom exception object and throw it
  set ex = ##class(%Exception.General).%New()
  set ex.Name = "Demo Exception",
      ex.Code = 100000,
      ex.Data = "Tutorial Example"
  try {
    write !, "Hello!", !
    if (x >= 5) throw ex  // throw the exception
  }
  catch err {
    write !, "Error name: ", ?20, err.Name,
		      !, "Error code: ", ?20, err.Code,
		      !, "Error location: ", ?20, err.Location,
		      !, "Additional data: ", ?20, err.Data, !
    if (x = 5) return  // terminate method
  }
  write !, "Finished!"
}

/// examples of JSON
ClassMethod JSON()
{
  // create a JSON object
  set jo1 = { "PartNum":"678LM", "Price":"7.99", "Quantity":"100" }
  // create a JSON array, and add it to the object
  set ar1 = ["Small","Large"], jo1.Sizes = ar1
  // change a size in the 0-based JSON array
  set ar1."0" = "Tiny"
  // turn the JSON into a string and display it
  set string1 = jo1.%ToJSON()
  write !, "First JSON object: ", !, string1

  // create a text string in JSON format
  set string2 = "{""PartNum"":""345JK"", ""Price"":5.99, ""Sizes"":[""Small"", ""Medium"", ""Large""], ""Quantity"":50}"
  // create an object from the string
  set jo2 = ##class(%DynamicObject).%FromJSON(string2)
  // display the properties of the object
  write !!, "Second JSON Object:"
  write !, "Part Number: ", jo2.PartNum, " Price: ", jo2.Price, " Quantity: ", jo2.Quantity
  write !, "Sizes"
  // loop through the array using an iterator
  set ar2 = jo2.Sizes
  set iter = ar2.%GetIterator()
  while iter.%GetNext(.key , .value ) {
    write !, ?5, "Key: ", key, ", Size: ", value
  }

  // change some of the properties
  set jo2.Price = "8.99", jo2.Quantity = 75
  // push a new size onto the end of the array
  do ar2.%Push("Extra Large")
  // turn the JSON into a string and display it
  write !!, "Changed Second JSON Object:"
  set newstring = jo2.%ToJSON()
  write !, newstring
}

/// loop through last names of the ^PersonI global, 2 different ways
ClassMethod SimpleLoop()
{
  write !, "Using argumentless For"
  set ln = ""  // initialize to the empty string to make $order return the first last name
  for {        // start looping
    set ln = $order(^PersonI("Name", ln))  // use the current last name to get the next
    quit:(ln = "")                         // stop looping when ln becomes empty again
    write !, ?5, ln
  }

  write !!, "Using While"
  set ln = $order(^PersonI("Name", ""))  // get the first last name
  while (ln '= "") {                     // only loop if there is at least one last name
    write !, ?5, ln
    set ln = $order(^PersonI("Name", ln))  // use the current last name to get the next
  }
}

/// Loop through the name index and display the records
ClassMethod NameLoop()
{
  // loop through last names
  set ln = ""
  for {
    set ln = $order(^PersonI("Name", ln))
    quit:(ln = "")
    // for each last name, loop through first names
    set fn = ""
    for {
      set fn = $order(^PersonI("Name", ln, fn))
      quit:(fn = "")
      // for each last name and first name, loop through id numbers
      set id = ""
      for {
        set id = $order(^PersonI("Name", ln, fn, id))
        quit:(id = "")
        // once you have an id number, get the data and display it
        set rec = ^PersonD(id)
        write !, $list(rec, 1),
                      ?15, $list(rec, 2),
                      ?30, $zdate($list(rec, 3), 2)
      }
    }
  }
}

/// loop through last names that FOLLOW a substring (including the substring)
ClassMethod FocusedLoopStart()
{
  read "Search for: ",substring
  // find the last name just BEFORE the substring and then start looping
  set ln = $order(^PersonI("Name", substring), -1)
  for {
    set ln = $order(^PersonI("Name", ln))
    quit:(ln = "")
    write !, ln
  }
}

/// loop through last names that MATCH substring
ClassMethod FocusedLoopStartEnd()
{
  read "Search for: ",substring
  // find the last name just BEFORE the substring and then start looping
  set ln = $order(^PersonI("Name", substring), -1)
  for {
    set ln = $order(^PersonI("Name", ln))
    // quit if no match or at end
    quit:($extract(ln, 1, $length(substring)) '= substring)
    write !, ln
  }
}

/// examples of conversion methods
ClassMethod Conversions()
{
  write !, "abcde becomes: ", $translate("abcde", "ad", "yz")  // translate a->y, and d->z
  write !, "abcde becomes: ", $translate("abcde", "ad", "zz")  // translate a->z, and d->z
  write !, "abcde becomes: ", $translate("abcde", "ad", "z")   // translate a->z, and d->nothing
  write !, "abcdebcbc becomes: ", $translate("abcdebcbc", "abc", "yz")  // translate a->y, b->z, and c->nothing
  write !, "abcdebcbc becomes: ", $replace("abcdebcbc", "abc", "yz")    // replace abc->yz

  read !, "String to translate: ", x
  set lower = "abcdefghijklmnopqrstuvwxyz"
  set upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  write !, "Using $translate: ", $translate(x, lower,  upper)
  write !, "Using $zconvert: ", $zconvert(x, "U")
  write !, "Using $zconvert for capitalizing words: ", $zconvert(x, "W")
  write !, "Using $zstrip to remove whitespace: ", $zstrip(x, "*W")
}

}
