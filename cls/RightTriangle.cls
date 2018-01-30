/// Right triangle class, with examples of ObjectScript features
Class ObjectScript.RightTriangle
{

/// Compute area and hypotenuse of a right triangle
ClassMethod Main()
{
    write !, "Compute the area and hypotenuse of a right triangle",
          !, "given the lengths of its two sides."
    read !!, "First, choose a unit of measurement: ",
          !, "1) inches", !, "2) feet", !, "3) miles", !,
             "4) centimeters", !, "5) meters", !, "6) kilometers ", !!, 
             "Option? ", units
    // Translate units to a word
    set units = $case(units, 1:"inches", 
                             2:"feet",
                             3:"miles",  
                             4:"centimeters",
                             5:"meters",
                             6:"kilometers",
                              :"units")
    do { 
        read !!, "Length of side 1: ", side1
        quit:(side1 = "")   // Exit the do loop
    }
    while ..IsNegative(side1)
    quit:(side1 = "")       // Exit the routine
    do {
        read !, "Length of side 2: ", side2
        quit:(side2 = "")   // Exit the do loop
    }
    while ..IsNegative(side2)
    quit:(side2 = "")       // Exit the routine
    do ..Compute(units, side1, side2)
    write !!, "Current date: "
    do ^%D
    write !, "Current time:"
    do ^%T
}

/// Is num negative?
ClassMethod IsNegative(num as %Numeric) 
{ 
    if (num '> 0) {
        write "  Enter a positive number."
        return 1      // Return true
    }
    else {
        write "  Accepted."
        return 0      // Return false
    }    
}

/// Compute and display area and hypotenuse
ClassMethod Compute(units as %String, A as %Numeric, B as %Numeric) [Private]
{
    set area = (A * B) / 2, 
        area = $justify(area, 0, 2),    // Round hypot to 2 places
        squaredSides = (A ** 2) + (B ** 2)  
    set hypot = $zsqr(squaredSides)     // $zsqr function computes square root                
    set hypot = $justify(hypot, 0, 2)   // Round hypot to 2 places
    write !!, "The area of this triangle is ", area, " square ", units, ".",
          !!, "The hypotenuse is ", hypot, " ", units, "."
}
}