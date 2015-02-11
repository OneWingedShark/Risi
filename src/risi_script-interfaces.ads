Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

with
Risi_Script.Types.Patterns,
Risi_Script.Types.Identifier,
Risi_Script.Types.Identifier.Scope,
Risi_Script.Types.Implementation;

Package Risi_Script.Interfaces is
   Use Risi_Script.Types.Patterns;


   Type Stack_Interface is Interface;

   Function Match(Object  : Stack_Interface;
                  Pattern : Three_Quarter_Pattern
                 ) return Boolean is (True);


   Function Match(Object  : Stack_Interface;
                  Pattern : Half_Pattern
                 ) return Boolean is (True);



   Package ID    Renames Risi_Script.Types.Identifier;
   Package IM    Renames Risi_Script.Types.Implementation;
   Package Scope Renames ID.Scope;

   -- The VM type declares the interface for a virtual=machine's
   -- implementation.
   --
   -- NOTE: MRE is a delicious Managed Runtime Environment.
   Type VM is synchronized interface;


   -- Creates a variable in the MRE.
   Procedure Create_Variable( MRE     : in out VM;
                              Value   : IM.Representation;
                              Name    : ID.Identifier:= "Evaluated";
                              Context : Scope.Scope:= Scope.Global
                            ) is abstract;

   -- Returns the internal representation of the indicated variable.
   Function  Retrieve_Variable( MRE     : in out VM;
                                Name    : ID.Identifier:= "Evaluated";
                                Context : Scope.Scope:= Scope.Global
                              ) return IM.Representation is abstract;

   Procedure Push_Parameter   ( MRE     : in out VM;
                                Value   : IM.Representation
                              ) is abstract;

   Function  Pop_Parameter    ( MRE     : in out VM
                              ) return IM.Representation is abstract;

   Function  Peek_Parameter   ( MRE     : in out VM;
                                Location: Positive
                              ) return IM.Representation is abstract;


End Risi_Script.Interfaces;
