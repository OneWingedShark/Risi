Pragma Ada_2012;

with
System,
Ada.Strings.Unbounded,
Ada.Characters.Handling;

limited private with
Risi_Script.Internals;

Package Risi_Script.Types is

   Enumeration_Prefix : Constant String:= "RT_";

   ------------------------------------
   -- Main Type Forward Declarration --
   ------------------------------------

   Type Extended_Enumeration is (
            RT_Integer, RT_Array,     RT_Hash,  RT_String,  RT_Real,
            RT_Pointer, RT_Reference, RT_Fixed, RT_Boolean, RT_Func,
            RT_Node
                        );


   SubType Enumeration is Extended_Enumeration Range RT_Integer..RT_Func;


   Type Indicator;
   Type Representation(<>);

   Function Get_Indicator  ( Input : Representation ) return Indicator;
   Function Get_Enumeration( Input : Representation ) return Enumeration;

   Function "+"( Right : Indicator ) return Enumeration;
   Function "+"( Right : Enumeration ) return Indicator;

   ------------------
   --  MAIN TYPES  --
   ------------------

   -- Defines the sigils that prefix variables.
   Type Indicator is ('!', '@', '#', '$', '%',
                      '^', '&', '`', '?', 'ß')
     with Size => 4, Object_Size => 8;

   For Indicator use
     (
      '!' => Enumeration'Pos( RT_Integer   ),
      '@' => Enumeration'Pos( RT_Array     ),
      '#' => Enumeration'Pos( RT_Hash      ),
      '$' => Enumeration'Pos( RT_String    ),
      '%' => Enumeration'Pos( RT_Real      ),
      '^' => Enumeration'Pos( RT_Pointer   ),
      '&' => Enumeration'Pos( RT_Reference ),
      '`' => Enumeration'Pos( RT_Fixed     ),
      '?' => Enumeration'Pos( RT_Boolean   ),
      'ß' => Enumeration'Pos( RT_Func      )
     );

   ----------------------
   --  REPRESENTATION  --
   ----------------------

   Type Representation is private;

   Subtype Identifier is String
   with Dynamic_Predicate => Valid_Identifier( Identifier );


   Function Valid_Identifier( Input: String ) return Boolean;


   Function Create( Data_Type : Enumeration ) return Representation;

   Function As_Array( Item : Representation ) return Representation;
   Function As_Hash ( Item : Representation; Start : Natural := 0 ) return Representation;


   Function Image( Item       : Representation;
                   Sub_Escape : Boolean:= False
                 ) return String;

Private
   Pragma Assert(
      Indicator'Pos(Indicator'Last) =
      Enumeration'Pos(Enumeration'Last),
      "Not all types have indicators."
   );

   Function "+"( Right : Indicator ) return Enumeration is
      ( Enumeration'Val(Indicator'Pos( Right )) );
   Function "+"( Right : Enumeration ) return Indicator is
      ( Indicator'Val(Enumeration'Pos( Right )) );

   Function Valid_Identifier( Input: String ) return Boolean is
     ( Input'Length in Positive and then
       Ada.Characters.Handling.Is_Letter(Input(Input'First)) and then
       (for all Ch of Input => Ch = '_' or Ada.Characters.Handling.Is_Alphanumeric(Ch)) and then
       (for all Index in Input'First..Positive'Pred(Input'Last) =>
          (if Input(Index) = '_' then Input(Index+1) /= '_')
       )
     );


   Type Internal_Representation(<>);
   Type Representation is not null access Internal_Representation;

   Function Internal_Create ( Item : Risi_Script.Internals.Integer_Type	) return Representation;
   Function Internal_Create ( Item : Risi_Script.Internals.Real_Type	) return Representation;
   Function Internal_Create ( Item : Risi_Script.Internals.Pointer_Type	) return Representation;
   Function Internal_Create ( Item : Risi_Script.Internals.Fixed_Type	) return Representation;
   Function Internal_Create ( Item : Risi_Script.Internals.Boolean_Type	) return Representation;
   Function Internal_Create ( Item : Risi_Script.Internals.Func_Type	) return Representation;

--     Function Create ( Item : Risi_Script.Internals.Array_Type	) return Representation;
--     Function Create ( Item : Risi_Script.Internals.Hash_Type	) return Representation;
--     Function Create ( Item : Risi_Script.Internals.String_Type	) return Representation;
--     Function Create ( Item : Risi_Script.Internals.Reference_Type) return Representation;

End Risi_Script.Types;
