with
System,
Ada.Strings.Unbounded,
Risi_Script.Types.Internals;

Use
Ada.Strings.Unbounded;

Package Body Risi_Script.Types.Implementation is
   Use Risi_Script.Types.Internals;

   Package List		Renames Internal.List;
   Package Hash		Renames Internal.Hash;

   Empty_String : constant Unbounded_String:= To_Unbounded_String("");

   Function Get_Reference( P : Pointer_Type; Ref_Type : Enumeration:= RT_Pointer ) return Reference_Type;
   Null_Address   : constant Pointer_Type:= Pointer_Type(System.Null_Address);

   Type Internal_Representation(Internal_Type : Enumeration) is record
      case Internal_Type is
         when RT_Integer    => Integer_Value   : Integer_Type	:= 0;
         when RT_Array      => Array_Value     : Array_Type	:= List.Empty_Vector;
         when RT_Hash       => Hash_Value      : Hash_Type	:= Hash.Empty_Map;
         when RT_String     => String_Value    : String_Type	:= Empty_String;
         when RT_Real       => Real_Value      : Real_Type	:= 0.0;
         when RT_Pointer    => Pointer_Value   : Pointer_Type   := Null_Address;
         when RT_Reference  => Reference_Value : Reference_Type := Get_Reference(Null_Address);
         when RT_Fixed      => Fixed_Value     : Fixed_Type	:= 0.0;
         when RT_Boolean    => Boolean_value   : Boolean_Type	:= True;
         when RT_Func       => Func_Value      : Func_Type;
--           when RT_Node       => NULL; --Node_Value      : Node'Class;
      end case;
   end record;

   Function Get_Indicator( Input : Representation ) return Indicator is
      ( +Input.Internal_Type );
   Function Get_Enumeration( Input : Representation ) return Enumeration is
      ( Input.Internal_Type );


   Function Stub( X,Y : Integer ) return Integer is (3);

   -- The Internal Creation methods declared in the spec.
   Function Internal_Create ( Item : Internal.Integer_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_Integer, Integer_Value => Item) );
   Function Internal_Create ( Item : Internal.Real_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_Real, Real_Value => Item) );
   Function Internal_Create ( Item : Internal.Pointer_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_Pointer, Pointer_Value => Item) );
   Function Internal_Create ( Item : Internal.Fixed_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_Fixed, Fixed_Value => Item) );
   Function Internal_Create ( Item : Internal.Boolean_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_Boolean, Boolean_Value => Item) );
   Function Internal_Create ( Item : Internal.Func_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_Func, Func_Value => Item) );

   -- The Internal Create methods operating on subtype-renames.
   Function Internal_Create ( Item : Internal.Array_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_Array, Array_Value => Item) );
   Function Internal_Create ( Item : Internal.Hash_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_Hash, Hash_Value => Item) );
   Function Internal_Create ( Item : Internal.String_Type	) return Representation is
     ( new Internal_Representation'(Internal_Type => RT_String, String_Value => Item) );


   -- Creates an Internal_Representation of the given type, with the default value.
   Function Create( Data_Type : Enumeration ) return Internal_Representation is
   begin
      return Internal_Representation' --(Internal_Type => RT_Integer,   others => <>);
     (case Data_Type is
         when RT_Integer    => (Internal_Type => RT_Integer,   others => <> ),
         when RT_Array      => (Internal_Type => RT_Array,     others => <> ),
         when RT_Hash       => (Internal_Type => RT_Hash,      others => <> ),
         when RT_String     => (Internal_Type => RT_String,    others => <> ),
         when RT_Real       => (Internal_Type => RT_Real,      others => <> ),
         when RT_Pointer    => (Internal_Type => RT_Pointer,   others => <> ),
         when RT_Reference  => (Internal_Type => RT_Reference, others => <> ),
         when RT_Fixed      => (Internal_Type => RT_Fixed,     others => <> ),
         when RT_Boolean    => (Internal_Type => RT_Boolean,   others => <> ),
         when RT_Func       => (Internal_Type => RT_Func,      others => Func_Type'(Stub'Access))
     );
   end Create;

   Function Get_Reference ( P : Pointer_Type; Ref_Type : Enumeration:= RT_Pointer ) return Reference_Type is
      Data : Representation(Ref_Type)
        with Import, Convention => Ada, Address => System.Address( P );
   begin
      return new Internal_Representation'(Data.all);
   end Get_Reference;


  Function Create( Data_Type : Enumeration ) return Representation is
     ( new Internal_Representation'(Create(Data_Type)) );

   Function As_Array( Item : Representation ) return Representation is
      Use List;
   begin
      return Result : Representation := Create(RT_Array) do
         if Get_Enumeration(Item) = RT_Array then
            for E of Item.Array_Value loop
               Result.Array_Value.Append(E);
            end loop;
         else
            Result.Array_Value.Append( Item );
         end if;
      end return;
   End As_Array;

   Function As_Hash ( Item : Representation; Start : Natural := 0 ) return Representation is
      Image : string renames Natural'Image( Start );
      Key   : constant String := Image( 1+Image'First..Image'Last );
   begin
      return Result : Representation := Create(RT_Hash) do
         Result.Hash_Value.Include( New_Item => Item, Key => Key );
      end return;
   end As_Hash;


--------------------------------------------------------------------------------
----  IMAGE FUNCTIONS                                                       ----
--------------------------------------------------------------------------------
   package Image_Operations is
   -------------------------
   --  UTILITY FUNCTIONS  --
   -------------------------

   Function Trim( S : String ) return String;
   Function Trim( S : String ) return Ada.Strings.Unbounded.Unbounded_String;

   -----------------------
   --  IMAGE FUNCTIONS  --
   -----------------------

   Function Image(Item : Integer_Type   ) return String;
   Function Image(Item : Array_Type     ) return String;
   Function Image(Item : Hash_Type      ) return String;
   Function Image(Item : String_Type    ) return String;
   Function Image(Item : Real_Type      ) return String;
   Function Image(Item : Pointer_Type   ) return String;
   Function Image(Item : Reference_Type ) return String;
   Function Image(Item : Fixed_Type     ) return String;
   Function Image(Item : Boolean_Type   ) return String;
   Function Image(Item : Func_Type      ) return String;

   end Image_Operations;


   Package Body Image_Operations is Separate;



--------------------------------------------------------------------------------
----  CONVERSION FUNCTIONS                                                  ----
--------------------------------------------------------------------------------
   Package Conversions is

   -- Integer Conversions
   Function Convert(Value : Integer_Type ) return Integer_Type is (Value);
   Function Convert(Value : Integer_Type ) return Array_Type;
   Function Convert(Value : Integer_Type ) return Hash_Type;
   Function Convert(Value : Integer_Type ) return String_Type;
   Function Convert(Value : Integer_Type ) return Real_Type;
   Function Convert(Value : Integer_Type ) return Pointer_Type                  IS(CREATE(RT_Pointer).all.Pointer_Value);
   Function Convert(Value : Integer_Type ) return Reference_Type                IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : Integer_Type ) return Fixed_Type;
   Function Convert(Value : Integer_Type ) return Boolean_Type;
   Function Convert(Value : Integer_Type ) return Func_Type                     IS(CREATE(RT_Func).all.Func_Value);

   -- Array Conversions
   Function Convert(Value : Array_Type ) return Integer_Type;
   Function Convert(Value : Array_Type ) return Array_Type is (Value);
   Function Convert(Value : Array_Type ) return Hash_Type;
   Function Convert(Value : Array_Type ) return String_Type;
   Function Convert(Value : Array_Type ) return Real_Type;
   Function Convert(Value : Array_Type ) return Pointer_Type                    IS(CREATE(RT_Pointer).all.Pointer_Value);
   Function Convert(Value : Array_Type ) return Reference_Type                  IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : Array_Type ) return Fixed_Type;
   Function Convert(Value : Array_Type ) return Boolean_Type;
   Function Convert(Value : Array_Type ) return Func_Type                       IS(CREATE(RT_Func).all.Func_Value);

   -- Hash Conversions
   Function Convert(Value : Hash_Type ) return Integer_Type;
   Function Convert(Value : Hash_Type ) return Array_Type;
   Function Convert(Value : Hash_Type ) return Hash_Type is (Value);
   Function Convert(Value : Hash_Type ) return String_Type;
   Function Convert(Value : Hash_Type ) return Real_Type;
   Function Convert(Value : Hash_Type ) return Pointer_Type                     IS(CREATE(RT_Pointer).all.Pointer_Value);
   Function Convert(Value : Hash_Type ) return Reference_Type                   IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : Hash_Type ) return Fixed_Type;
   Function Convert(Value : Hash_Type ) return Boolean_Type;
   Function Convert(Value : Hash_Type ) return Func_Type                        IS(CREATE(RT_Func).all.Func_Value);

   -- String Conversions
   Function Convert(Value : String_Type ) return Integer_Type;
   Function Convert(Value : String_Type ) return Array_Type                     IS(CREATE(RT_Array).all.Array_Value);
   Function Convert(Value : String_Type ) return Hash_Type                      IS(CREATE(RT_Hash).all.Hash_Value);
   Function Convert(Value : String_Type ) return String_Type is (Value);
   Function Convert(Value : String_Type ) return Real_Type;
   Function Convert(Value : String_Type ) return Pointer_Type                   IS(CREATE(RT_Pointer).all.Pointer_Value);
   Function Convert(Value : String_Type ) return Reference_Type                 IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : String_Type ) return Fixed_Type;
   Function Convert(Value : String_Type ) return Boolean_Type;
   Function Convert(Value : String_Type ) return Func_Type                      IS(CREATE(RT_Func).all.Func_Value);

   -- Real Conversions
   Function Convert(Value : Real_Type ) return Integer_Type;
   Function Convert(Value : Real_Type ) return Array_Type;
   Function Convert(Value : Real_Type ) return Hash_Type;
   Function Convert(Value : Real_Type ) return String_Type;
   Function Convert(Value : Real_Type ) return Real_Type is (Value);
   Function Convert(Value : Real_Type ) return Pointer_Type                     IS(CREATE(RT_Pointer).all.Pointer_Value);
   Function Convert(Value : Real_Type ) return Reference_Type                   IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : Real_Type ) return Fixed_Type;
   Function Convert(Value : Real_Type ) return Boolean_Type;
   Function Convert(Value : Real_Type ) return Func_Type                        IS(CREATE(RT_Func).all.Func_Value);

--     -- Pointer Conversions
   Function Convert(Value : Pointer_Type ) return Integer_Type                  IS(CREATE(RT_Integer).all.Integer_Value);
   Function Convert(Value : Pointer_Type ) return Array_Type                    IS(CREATE(RT_Array).all.Array_Value);
   Function Convert(Value : Pointer_Type ) return Hash_Type                     IS(CREATE(RT_Hash).all.Hash_Value);
   Function Convert(Value : Pointer_Type ) return String_Type                   IS(CREATE(RT_String).all.String_Value);
   Function Convert(Value : Pointer_Type ) return Real_Type                     IS(CREATE(RT_Real).all.real_Value);
   Function Convert(Value : Pointer_Type ) return Pointer_Type is (Value);
   Function Convert(Value : Pointer_Type ) return Reference_Type                IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : Pointer_Type ) return Fixed_Type                    IS(CREATE(RT_Fixed).all.Fixed_Value);
   Function Convert(Value : Pointer_Type ) return Boolean_Type                  IS(CREATE(RT_Boolean).all.Boolean_value);
   Function Convert(Value : Pointer_Type ) return Func_Type                     IS(CREATE(RT_Func).all.Func_Value);

   -- Reference Conversions
   Function Convert(Value : Reference_Type ) return Integer_Type;
   Function Convert(Value : Reference_Type ) return Array_Type                  IS(CREATE(RT_Array).all.Array_Value);
   Function Convert(Value : Reference_Type ) return Hash_Type                   IS(CREATE(RT_Hash).all.Hash_Value);
   Function Convert(Value : Reference_Type ) return String_Type                 IS(CREATE(RT_String).all.String_Value);
   Function Convert(Value : Reference_Type ) return Real_Type                   IS(CREATE(RT_Real).all.real_Value);
   Function Convert(Value : Reference_Type ) return Pointer_Type                IS(CREATE(RT_Pointer).all.Pointer_Value);
   Function Convert(Value : Reference_Type ) return Reference_Type is (Value);
   Function Convert(Value : Reference_Type ) return Fixed_Type                  IS(CREATE(RT_Fixed).all.Fixed_Value);
   Function Convert(Value : Reference_Type ) return Boolean_Type                IS(CREATE(RT_Boolean).all.Boolean_value);
   Function Convert(Value : Reference_Type ) return Func_Type                   IS(CREATE(RT_Func).all.Func_Value);

   -- Fixed Conversions
   Function Convert(Value : Fixed_Type ) return Integer_Type;
   Function Convert(Value : Fixed_Type ) return Array_Type;
   Function Convert(Value : Fixed_Type ) return Hash_Type;
   Function Convert(Value : Fixed_Type ) return String_Type;
   Function Convert(Value : Fixed_Type ) return Real_Type;
   Function Convert(Value : Fixed_Type ) return Pointer_Type                    IS(CREATE(RT_Pointer).all.Pointer_Value);
   Function Convert(Value : Fixed_Type ) return Reference_Type                  IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : Fixed_Type ) return Fixed_Type is (Value);
   Function Convert(Value : Fixed_Type ) return Boolean_Type;
   Function Convert(Value : Fixed_Type ) return Func_Type                       IS(CREATE(RT_Func).all.Func_Value);

   -- Boolean conversions
   Function Convert(Value : Boolean_Type ) return Integer_Type;
   Function Convert(Value : Boolean_Type ) return Array_Type;
   Function Convert(Value : Boolean_Type ) return Hash_Type;
   Function Convert(Value : Boolean_Type ) return String_Type;
   Function Convert(Value : Boolean_Type ) return Real_Type;
   Function Convert(Value : Boolean_Type ) return Pointer_Type;
   Function Convert(Value : Boolean_Type ) return Reference_Type                IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : Boolean_Type ) return Fixed_Type;
   Function Convert(Value : Boolean_Type ) return Boolean_Type is (Value);
   Function Convert(Value : Boolean_Type ) return Func_Type                     IS(CREATE(RT_Func).all.Func_Value);

   -- Function Conversions
   Function Convert(Value : Func_Type ) return Integer_Type                     IS(CREATE(RT_Integer).all.Integer_Value);
   Function Convert(Value : Func_Type ) return Array_Type                       IS(CREATE(RT_Array).all.Array_Value);
   Function Convert(Value : Func_Type ) return Hash_Type                        IS(CREATE(RT_Hash).all.Hash_Value);
   Function Convert(Value : Func_Type ) return String_Type                      IS(CREATE(RT_String).all.String_Value);
   Function Convert(Value : Func_Type ) return Real_Type                        IS(CREATE(RT_Real).all.real_Value);
   Function Convert(Value : Func_Type ) return Pointer_Type                     IS(CREATE(RT_Pointer).all.Pointer_Value);
   Function Convert(Value : Func_Type ) return Reference_Type                   IS(CREATE(RT_Reference).all.Reference_Value);
   Function Convert(Value : Func_Type ) return Fixed_Type                       IS(CREATE(RT_Fixed).all.Fixed_Value);
   Function Convert(Value : Func_Type ) return Boolean_Type                     IS(CREATE(RT_Boolean).all.Boolean_value);
   Function Convert(Value : Func_Type ) return Func_Type is (Value);

   End Conversions;


   Package Body Conversions is Separate;

   Function Convert( Item : Representation; To : Enumeration ) return Representation is
      Separate;


--------------------------------------------------------------------------------
----  OPERATORS                                                             ----
--------------------------------------------------------------------------------


   Package Operators is

         Function "<" ( Left : INTEGER_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : ARRAY_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : HASH_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : STRING_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : REAL_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : POINTER_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : REFERENCE_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : FIXED_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : BOOLEAN_TYPE; Right: Representation) return Boolean	IS (True);
         Function "<" ( Left : FUNC_TYPE; Right: Representation) return Boolean	IS (True);


         Function "=" ( Left : INTEGER_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : ARRAY_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : HASH_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : STRING_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : REAL_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : POINTER_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : REFERENCE_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : FIXED_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : BOOLEAN_TYPE; Right: Representation) return Boolean	IS (True);
         Function "=" ( Left : FUNC_TYPE; Right: Representation) return Boolean	IS (True);


         Function ">" ( Left : INTEGER_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : ARRAY_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : HASH_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : STRING_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : REAL_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : POINTER_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : REFERENCE_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : FIXED_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : BOOLEAN_TYPE; Right: Representation) return Boolean	IS (True);
         Function ">" ( Left : FUNC_TYPE; Right: Representation) return Boolean	IS (True);


         Function "+" ( Left : INTEGER_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : ARRAY_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : HASH_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : STRING_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : REAL_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : POINTER_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : REFERENCE_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : FIXED_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : BOOLEAN_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "+" ( Left : FUNC_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));


         Function "-" ( Left : INTEGER_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : ARRAY_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : HASH_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : STRING_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : REAL_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : POINTER_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : REFERENCE_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : FIXED_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : BOOLEAN_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "-" ( Left : FUNC_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));


         Function "*" ( Left : INTEGER_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : ARRAY_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : HASH_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : STRING_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : REAL_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : POINTER_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : REFERENCE_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : FIXED_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : BOOLEAN_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "*" ( Left : FUNC_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));


         Function "/" ( Left : INTEGER_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : ARRAY_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : HASH_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : STRING_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : REAL_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : POINTER_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : REFERENCE_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : FIXED_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : BOOLEAN_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));
         Function "/" ( Left : FUNC_TYPE; Right: Representation) return Representation	IS (Create(RT_Integer));


      End Operators;


   --Package Body Operators is Separate;


   Function Image (Item : Representation; Sub_Escape : Boolean:= False) return String is
      Use Image_Operations;
   begin
      case Item.Internal_Type is
         when RT_Integer    => return Image(Item.Integer_Value);
         when RT_Array      => return Image(Item.Array_Value);
         when RT_Hash       => return Image(Item.Hash_Value);
         when RT_String     => return Image(Item.String_Value);
         when RT_Real       => return Image(Item.Real_Value);
         when RT_Pointer    => return Image(Item.Pointer_Value);
         when RT_Reference  => return Image_Operations.Image(Item.Reference_Value);
         when RT_Fixed      => return Image(Item.Fixed_Value);
         when RT_Boolean    => return Image(Item.Boolean_value);
         when RT_Func       => return Image(Item.Func_Value);
      end case;
   end Image;

End Risi_Script.Types.Implementation;
