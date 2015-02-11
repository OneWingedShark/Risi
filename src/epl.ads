Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

With
Ada.Strings.UTF_Encoding.Wide_Wide_Strings,
Ada.Strings.UTF_Encoding.Wide_Strings,
Ada.Strings.UTF_Encoding.Strings,
Ada.IO_Exceptions;
with Ada.Strings.UTF_Encoding;

-- Edward Parse Library.
--
-- ©2015 E. Fish; All Rights Reserved.
Package EPL with Pure is

   -- Subtype Renaming of string-types.
   subtype UTF_08 is Ada.Strings.UTF_Encoding.UTF_8_String;
   subtype UTF_16 is Ada.Strings.UTF_Encoding.UTF_16_Wide_String;
   subtype UTF_32 is Wide_Wide_String;

   Format_Error  : Exception renames Ada.IO_Exceptions.Data_Error;
   Parse_Error   : Exception;

End EPL;
