Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

-- Edward Parse Library.
--
-- ©2015 E. Fish; All Rights Reserved.
Package EPL.Types with Pure is

      Type Bracket is (
                       Parentheses,
                       Brackets,
                       Braces,
                       Chevrons,
                       Angle,
                       Corner
                       );

      Subtype Side is Ada.Strings.Alignment range Ada.Strings.Left..Ada.Strings.Right;
End EPL.Types;
