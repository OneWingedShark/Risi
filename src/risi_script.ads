Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

Package Risi_Script with Pure is

   -- TYPE_ERROR
   --
   -- [Description]
   Type_Error		: Exception;

   -- PARSE_ERROR
   --
   -- Raised when an error occours in parsing.
   Parse_Error		: Exception;

   -- SCRIPT_ERROR
   --
   -- Raised whe an attempt to load an invalid script is made.
   Script_Error		: Exception;

   -- PARALLEL_ERROR
   --
   -- Raised when an when exceptions or failures arise during
   -- parallel communication.
   Parallel_Error	: Exception;

End Risi_Script;
