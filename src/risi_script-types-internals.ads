Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

With
System,
System.Address_Image,
Ada.Strings.Unbounded,
Ada.Strings.Less_Case_Insensitive,
Ada.Containers.Indefinite_Ordered_Maps,
Ada.Containers.Indefinite_Vectors,
Risi_Script.Types.Implementation;


Private Package Risi_Script.Types.Internals with Elaborate_Body is

   ------------------------
   -- AUXILARY PACKAGES  --
   ------------------------

   Package Hash is new Ada.Containers.Indefinite_Ordered_Maps(
       "="          => Risi_Script.Types.Implementation."=",
       "<"          => Ada.Strings.Less_Case_Insensitive,
       Key_Type     => String,
       Element_Type => Risi_Script.Types.Implementation.Representation
   );

   Package List is new Ada.Containers.Indefinite_Vectors(
       "="          => Risi_Script.Types.Implementation."=",
       Index_Type   => Positive,
       Element_Type => Risi_Script.Types.Implementation.Representation
   );

   ---------------------
   -- AUXILARY TYPES  --
   ---------------------

      Type Integer_Type   is new Long_Long_Integer;
   SubType Array_Type     is     List.Vector;
   SubType Hash_Type      is     Hash.Map;
   SubType String_Type    is     Ada.Strings.Unbounded.Unbounded_String;
      Type Real_Type      is new Long_Long_Float;
      Type Pointer_Type   is new System.Address;
   SubType Reference_Type is     Risi_Script.Types.Implementation.Representation;
      Type Fixed_Type     is delta 10.0**(-4) digits 18 with Size => 64;
      Type Boolean_Type   is new Boolean;
      Type Func_Type      is not null access function(X, Y : Integer) return Integer;


   ------------------------
   -- AUXILARY GENERICS  --
   ------------------------

   Generic
      Type X;
      with Function Create( Element : X ) return Risi_Script.Types.Implementation.Representation is <>;
   Function To_Array(Value : X ) return Array_Type;

   Generic
      Type X;
      with Function Create( Element : X ) return Risi_Script.Types.Implementation.Representation is <>;
   Function To_Hash(Value : X ) return Hash_Type;


End Risi_Script.Types.Internals;
