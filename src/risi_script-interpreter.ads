Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

with
Risi_Script.Types.Patterns,
Risi_Script.Types.Identifier,
Risi_Script.Types.Identifier.Scope,
Risi_Script.Types.Implementation,
Risi_Script.Interfaces;

Package Risi_Script.Interpreter is
   Use Risi_Script.Interfaces;

   Type Virtual_Machine is tagged  -- new VM and Stack_Interface with
      null record;

End Risi_Script.Interpreter;
