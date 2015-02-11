Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

limited private with
Risi_Script.Types.Internals;

Package Risi_Script.Types.Implementation is

   Type Representation is private;

   Function Create( Data_Type : Enumeration ) return Representation;


   Function Image( Item       : Representation;
                   Sub_Escape : Boolean:= False
                 ) return String;


   Type Variable_List is Array(Positive Range <>) of Representation;

   Function Get_Indicator  ( Input : Representation ) return Indicator;
   Function Get_Enumeration( Input : Representation ) return Enumeration;

Private

   Type Internal_Representation(<>);
   Type Representation is not null access Internal_Representation;

   Package Internal	Renames Risi_Script.Types.Internals;

   Function Internal_Create ( Item : Internal.Integer_Type	) return Representation;
   Function Internal_Create ( Item : Internal.Real_Type		) return Representation;
   Function Internal_Create ( Item : Internal.Pointer_Type	) return Representation;
   Function Internal_Create ( Item : Internal.Fixed_Type	) return Representation;
   Function Internal_Create ( Item : Internal.Boolean_Type	) return Representation;
   Function Internal_Create ( Item : Internal.Func_Type		) return Representation;

End Risi_Script.Types.Implementation;
