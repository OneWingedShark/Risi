Pragma Ada_2012;

With
System,
System.Address_Image,
Ada.Strings.Unbounded,
Ada.Strings.Less_Case_Insensitive,
Ada.Containers.Indefinite_Ordered_Maps,
Ada.Containers.Indefinite_Vectors,
Risi_Script.Types;

Private Package Risi_Script.Internals is

   ------------------------
   -- AUXILARY PACKAGES  --
   ------------------------

   Package Hash is new Ada.Containers.Indefinite_Ordered_Maps(
       "="          => Risi_Script.Types."=",
       "<"          => Ada.Strings.Less_Case_Insensitive,
       Key_Type     => String,
       Element_Type => Risi_Script.Types.Representation
   );

   Package List is new Ada.Containers.Indefinite_Vectors(
       "="          => Risi_Script.Types."=",
       Index_Type   => Positive,
       Element_Type => Risi_Script.Types.Representation
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
   SubType Reference_Type is     Risi_Script.Types.Representation;
      Type Fixed_Type     is delta 10.0**(-4) digits 18 with Size => 64;
      Type Boolean_Type   is new Boolean;
      Type Func_Type      is not null access function(X, Y : Integer) return Integer;


   ------------------------
   -- AUXILARY GENERICS  --
   ------------------------

   Generic
      Type X;
      with Function Create( Element : X ) return Risi_Script.Types.Representation is <>;
   Function To_Array(Value : X ) return Array_Type;

   Generic
      Type X;
      with Function Create( Element : X ) return Risi_Script.Types.Representation is <>;
   Function To_Hash(Value : X ) return Hash_Type;

   ----------------------------------
   --  ELEMENTS FOR PATTERN TYPES  --
   ----------------------------------
   Use Risi_Script.Types;

   Type Enumeration_Length(Enum : Enumeration) is record
      case Enum is
         when RT_String | RT_Array | RT_Hash => Length : Natural;
         when others => Null;
      end case;
   end record;

   Type Pattern_Element is ( Half, Three_Quarter, Full );
   Subtype Extended_Pattern_Element is Pattern_Element Range Half..Full;

   type Varying_Element( Element : Extended_Pattern_Element ) is record
      case Element is
         when Half          => Half_Value : Enumeration;
         when Three_Quarter => TQ_Value   : not null access Enumeration_Length;
         when Full          => Full_Value : Representation;
      end case;
   end record;

   ---------------------
   --  PATTERN TYPES  --
   ---------------------

   --#TODO:	Implement the pattern-types; they should have to- and from-
   --#		string conversion functions.

   Type Half_Pattern          is array (Positive range <>) of Enumeration;
   Type Three_Quarter_Pattern is array (Positive range <>) of not null access Enumeration_Length;
   Type Full_Pattern          is array (Positive range <>) of Representation;
   Type Extended_Pattern      is array (Positive range <>) of not null access Varying_Element;

   Type Square_Pattern is null record;
   Type Cubic_Pattern  is null record;
   Type Power_Pattern  is null record;

   -- Pattern to String conversion.
   Function "+"( Pattern : Half_Pattern ) return String;

   -- String to Pattern conversion.
   Function "+"( Text : String ) return Half_Pattern;

End Risi_Script.Internals;
