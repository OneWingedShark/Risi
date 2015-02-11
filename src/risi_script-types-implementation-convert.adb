with
Risi_Script.Types.Internals;

Separate(Risi_Script.Types.Implementation)

Function Convert( Item : Representation; To : Enumeration ) return Representation is
   use Risi_Script.Types.Internals, Risi_Script.Types.Implementation.Conversions;
   Source : Enumeration renames Get_Enumeration(Item);

   Generic
      Type To_Type is private;
      with Function Convert( Input : Integer_Type   ) return To_Type is <>;
      with Function Convert( Input : Array_Type     ) return To_Type is <>;
      with Function Convert( Input : Hash_Type      ) return To_Type is <>;
      with Function Convert( Input : String_Type    ) return To_Type is <>;
      with Function Convert( Input : Real_Type      ) return To_Type is <>;
      with Function Convert( Input : Pointer_Type   ) return To_Type is <>;
      with Function Convert( Input : Reference_Type ) return To_Type is <>;
      with Function Convert( Input : Fixed_Type     ) return To_Type is <>;
      with Function Convert( Input : Boolean_Type   ) return To_Type is <>;
      with Function Convert( Input : Func_Type      ) return To_Type is <>;
      From_Type : in Enumeration:= Source;
   Function Generic_Conversion return To_Type;

   Function Generic_Conversion return To_Type is
     (case From_Type is
         when RT_Integer   => Convert( Item.Integer_Value   ),
         when RT_Array     => Convert( Item.Array_Value     ),
         when RT_Hash      => Convert( Item.hash_Value      ),
         when RT_String    => Convert( Item.String_Value    ),
         when RT_Real      => Convert( Item.Real_Value      ),
         when RT_Pointer   => Convert( Item.Pointer_Value   ),
         when RT_Reference => Convert( Item.Reference_Value ),
         when RT_Fixed     => Convert( Item.Fixed_Value     ),
         when RT_Boolean   => Convert( Item.Boolean_Value   ),
         when RT_Func      => Convert( Item.Func_Value      )
     );

   Function Conversion is new Generic_Conversion( Integer_Type   );
   Function Conversion is new Generic_Conversion( Array_Type     );
   Function Conversion is new Generic_Conversion( Hash_Type      );
   Function Conversion is new Generic_Conversion( String_Type    );
   Function Conversion is new Generic_Conversion( Real_Type      );
   Function Conversion is new Generic_Conversion( Pointer_Type   );
   Function Conversion is new Generic_Conversion( Reference_Type );
   Function Conversion is new Generic_Conversion( Fixed_Type     );
   Function Conversion is new Generic_Conversion( Boolean_Type   );
   Function Conversion is new Generic_Conversion( Func_Type      );

begin
   -- Manual static dispatching, YAY!
   -- Generics reduced the total length of this function from 170 lines to less than 70.
   return Result : Representation:= new Internal_Representation'
     (case To is
         when RT_Integer   => (Internal_Type => RT_Integer,   Integer_Value   => Conversion),
         when RT_Array     => (Internal_Type => RT_Array,     Array_Value     => Conversion),
         when RT_Hash      => (Internal_Type => RT_Hash,      Hash_Value      => Conversion),
         when RT_String    => (Internal_Type => RT_String,    String_Value    => Conversion),
         when RT_Real      => (Internal_Type => RT_Real,      Real_Value      => Conversion),
         when RT_Pointer   => (Internal_Type => RT_Pointer,   Pointer_Value   => Conversion),
         when RT_Reference => (Internal_Type => RT_Reference, Reference_Value => Conversion),
         when RT_Fixed     => (Internal_Type => RT_Fixed,     Fixed_Value     => Conversion),
         when RT_Boolean   => (Internal_Type => RT_Boolean,   Boolean_Value   => Conversion),
         when RT_Func      => (Internal_Type => RT_Func,      Func_Value      => Conversion)
     );
End Convert;
