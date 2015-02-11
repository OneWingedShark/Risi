Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

Package Risi_Script.Types with Pure is

   Enumeration_Prefix : Constant String:= "RT_";

   ------------------------------------
   -- Main Type Forward Declarration --
   ------------------------------------

   Type Extended_Enumeration;
   Type Indicator;
   Type Subprogram_Type;

   ------------------
   --  MAIN TYPES  --
   ------------------

   Type Subprogram_Type is (RF_Function, RF_As_Procedure, RF_With_Procedure);

   Type Extended_Enumeration is (
            RT_Integer, RT_Array,     RT_Hash,  RT_String,  RT_Real,
            RT_Pointer, RT_Reference, RT_Fixed, RT_Boolean, RT_Func,
            RT_Node
                        );

   SubType Enumeration is Extended_Enumeration Range RT_Integer..RT_Func;


   -- Defines the sigils that prefix variables.
   Type Indicator is ('!', '@', '#', '$', '%',
                      '^', '&', '`', '?', 'ß')
     with Object_Size => 8;

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

   Type Indicator_String is Array(Positive Range <>) of Indicator;
   Function "+"( Right : Indicator_String ) Return String;

   Function "+"( Right : Character ) return Indicator;
   Function "+"( Right : Indicator ) return Character;
   Function "+"( Right : Indicator ) return Enumeration;
   Function "+"( Right : Enumeration ) return Indicator;
   Function "+"( Right : Enumeration ) return Character;


Private

   Function "+"( Right : Indicator_String ) Return String is
     (case Right'Length is
         When 0 => "",
         When 1 => ( 1 => +Right(Right'First) ),
         When others => (+Right(Right'First)) &
                        (+Right(Positive'Succ(Right'First)..Right'Last))
     );

   Function "+"( Right : Enumeration ) return Character is
     ( +(+Right) );
   Function "+"( Right : Indicator ) return Enumeration is
     ( Enumeration'Val(Indicator'Pos( Right )) );
   Function "+"( Right : Enumeration ) return Indicator is
     ( Indicator'Val(Enumeration'Pos( Right )) );
   Function "+"( Right : Indicator ) return Character is
     (case Right is
         When '!' => '!',
         When '@' => '@',
         When '#' => '#',
         When '$' => '$',
         When '%' => '%',
         When '^' => '^',
         When '&' => '^',
         When '`' => '`',
         When '?' => '?',
         When 'ß' => 'ß'
     );
   Function "+"( Right : Character ) return Indicator is
     (case Right is
         When '!' => '!',
         When '@' => '@',
         When '#' => '#',
         When '$' => '$',
         When '%' => '%',
         When '^' => '^',
         When '&' => '^',
         When '`' => '`',
         When '?' => '?',
         When 'ß' => 'ß',
         When others => Raise Parse_Error
           with "Invalid type-sigil: '" & Right & "'."
     );

End Risi_Script.Types;
