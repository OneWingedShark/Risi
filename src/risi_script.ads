Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

Package Risi_Script with Pure is

   Type_Error,
   Parse_Error,
   Script_Error,
   Parallel_Error  : Exception;

End Risi_Script;
