Class ObjectScript.Lookup1
{

/// main loop section, dispatch to different methods based on user input
ClassMethod Main()
{
  while ..GetInput(.type, .search) {  
    if (type = "help")    { do ..Help() }
    elseif (type = "dob") { do ..DOB(search) }
  }
}

/// prompt user for a lookup string, return search type and search string
ClassMethod GetInput(Output type As %String, Output search As %String) As %Boolean
{
  read !, "Lookup: ", lookup
  return:(lookup = "") 0  // user entered nothing so return FALSE
  if (lookup = "?") {
    set type = "help", search = ""
  }
  elseif (##class(ObjectScript.DataEntry4).ValidDOB(lookup, .convdate)) {
    set type = "dob", search = convdate
  }
  else {
    set (type, search) = ""
  }
  return 1
}

/// display lookup options
ClassMethod Help()
{
  write !, "You can enter:",
	      !?10, "* date of birth", !
}

/// exact date of birth lookup
ClassMethod DOB(intdob As %Date)
{
  // is the date of birth in the index?
  if '$data(^PersonI("DOB", intdob) ) {
    write "...no matches"
    quit
  }

  write "...finding birthday matches"
  // loop through IDs, and number them
  set id = ""
  for count = 1:1 {
    set id = $order(^PersonI("DOB", intdob, id))
    quit:(id = "")
    write !, count, ") "
    do ..DisplayLine(id)
  }
  write !
}

/// given an ID, retrieve data and write it on a line
ClassMethod DisplayLine(id As %Integer)
{
  set $listbuild(name, phone, intdob) = ^PersonD(id)
	/* the line above is equivalent to
  set answers = ^PersonD(id),
  name = $list(answers, 1),
  phone = $list(answers, 2),
  intdob = $list(answers, 3) */
  write name, ?20, phone, ?35, $zdate(intdob, 2)
}

}
