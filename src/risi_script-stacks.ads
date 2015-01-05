With
Ada.Strings.Less_Case_Insensitive,
Ada.Containers.Indefinite_Ordered_Maps,
Risi_Script.Types,
Risi_Script.Parameter_Stack_Package;

Use
Ada.Containers,
Risi_Script.Types;

Package Risi_Script.Stacks is

   Subtype Parameter_Stack is Risi_Script.Parameter_Stack_Package.Vector;

   Procedure Push( Stack : in out Parameter_Stack;
                   Item  : Representation
                 ) with Inline;
   Function  Pop ( Stack : in out Parameter_Stack ) return Representation
   with Inline;
   Function  Peek( Stack : Parameter_Stack;
                   Item  : Positive
                 ) return Representation
   with Inline;

   -- Variables_Package maps names to variables.
   Package Variables_Package is new Ada.Containers.Indefinite_Ordered_Maps(
      "<"          => Ada.Strings.Less_Case_Insensitive,
      Key_Type     => Identifier,
      Element_Type => Representation
   );

   -- Scope_Package maps names to a scope (Variable_Package).
   Package Scope_Package is new Ada.Containers.Indefinite_Ordered_Maps(
      "<"          => Ada.Strings.Less_Case_Insensitive,
      "="          => Variables_Package."=",
      Key_Type     => Identifier,
      Element_Type => Variables_Package.Map
   );

End Risi_Script.Stacks;
