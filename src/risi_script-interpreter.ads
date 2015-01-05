Pragma Ada_2012;

With
Risi_Script.Script,
Risi_Script.Types,
Risi_Script.Stacks,
Ada.Containers.Vectors,
Ada.Containers.Indefinite_Vectors;


Use
Risi_Script.Types;

Package Risi_Script.Interpreter is

   Type VM(<>);

   -- NOTE: MRE is a delicious Managed Runtime Environment.



   -- Creates a variable in the MRE.
   Procedure Create_Variable( MRE     : in out VM;
                              Value   : Representation;
                              Name    : Identifier:= "Evaluated";
                              Context : Identifier:= "Global"
                            );

   -- Returns the internal representation of the indicated variable.
   Function  Retrieve_Variable( MRE     : in out VM;
                                Name    : Identifier:= "Evaluated";
                                Context : Identifier:= "Global"
                              ) return Representation;

   Procedure Push_Parameter   ( MRE     : in out VM;
                                Value   : Representation
                              );

   Function  Pop_Parameter    ( MRE     : in out VM
                              ) return Representation;

   Function  Peek_Parameter   ( MRE     : in out VM;
                                Location: Positive
                              ) return Representation;

   -- Execute starts the VM running.
   -- Set DEBUG to true to run in debugging mode.
   Procedure Execute         ( MRE      : in out VM;
                               Debugging: Boolean := False
                             );

   -- Load takse the given script and loads it into the VM.
   Procedure Load            ( MRE      : in out VM;
                               Script   : Risi_Script.Script.Script
                             );

   -- Init returns an instance of a VM.
   Function Init               return VM;

   -- EXCEPTIONS:
   --	FEnv_Access_Error:	Raised when a non-declared variable is accessed.
   --	Scope_Violation:	Raised when an invalid implicit GOTO is executed.
   --
   FEnv_Access_Error,
   Scope_Violation	: Exception;


   --------------------------------
   -- VIRTUAL MACHINE DEFINITION --
   --------------------------------

   Use Risi_Script.Types, Risi_Script.Script, Risi_Script.Stacks;

   Package Parameter_Stack_Pkg is new Ada.Containers.Indefinite_Vectors(
      Index_Type   => positive,
      Element_Type => Risi_Script.Types.Representation
   );

   Package Jump_List is new Ada.Containers.Vectors(
      Index_Type   => Positive,
      Element_Type => Positive
   );

   Type VM is record
      Current_Line   : Positive;
      Execution      : Jump_List.Vector;
      Result         : not null access Representation;
      Program        : not null access Script.Script;
      Parameters     : Parameter_Stack;
      Scopes         : Scope_Package.Map;
   end record;


Private



End Risi_Script.Interpreter;
