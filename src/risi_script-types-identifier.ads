Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

with
Ada.Characters.Handling;
--  Ada.Containers.Indefinite_Vectors;

Package Risi_Script.Types.Identifier is

   SubType Identifier is String
   with Dynamic_Predicate => Is_Valid( Identifier )
     or else raise Parse_Error with "Invalid identifier: """ & Identifier & '"';

Private

   Function Is_Valid( Input: String ) return Boolean is
     ( Input'Length in Positive and then
       Ada.Characters.Handling.Is_Letter(Input(Input'First)) and then
       Ada.Characters.Handling.Is_Alphanumeric(Input(Input'Last)) and then
       (for all Ch of Input => Ch = '_' or Ada.Characters.Handling.Is_Alphanumeric(Ch)) and then
       (for all Index in Input'First..Positive'Pred(Input'Last) =>
          (if Input(Index) = '_' then Input(Index+1) /= '_')
       )
     );


--        Type Scope is new Scope_Vector.Vector with null record;

End Risi_Script.Types.Identifier;
