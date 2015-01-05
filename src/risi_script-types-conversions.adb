With
System.Storage_Elements,
Risi_Script.Types.Creators,
Risi_Script.Internals,
Ada.Containers,
Ada.Strings.Unbounded,
Ada.Strings.Fixed;

Separate(Risi_Script.Types)

Package Body Conversions is
   Use Risi_Script.Types.Creators;
   Use Type Ada.Containers.Count_Type;

   Package SE renames System.Storage_Elements;

   Type Braket_Style is ( Round, Square, Curly );

   ---------------------
   -- UTIL FUNCTIONS  --
   ---------------------

   Function "+"( S : String ) return Ada.Strings.Unbounded.Unbounded_String
     renames Ada.Strings.Unbounded.To_Unbounded_String;

   Function "+"( S : Ada.Strings.Unbounded.Unbounded_String ) return String
     renames Ada.Strings.Unbounded.To_String;


   Function Trim( S : String ) return Ada.Strings.Unbounded.Unbounded_String is
      Use Ada.Strings.Unbounded, Ada.Strings.Fixed, Ada.Strings;
   begin
      Return + Trim(Side => Left, Source => S);
   end Trim;

   Function To_Address( X : SE.integer_Address ) return System.Address
     renames SE.To_Address;

   Generic
      Type X is private;
      Default : X;
      with Function Value( S : String ) return X;
   Function Parse_String( S : String_Type ) return X;

   Function Parse_String( S : String_Type ) return X is
   begin
      return Result : X := Default do
         Result:= Value( +S );
      exception
         when others => null;
      end return;
   end Parse_String;

   Function Bracket( S : String; Style : Braket_Style ) return String is
     (case Style is
         when Round  => '(' & S & ')',
         when Square => '[' & S & ']',
         when Curly  => '{' & S & '}'
     );

   Function Bracket( S : Unbounded_String; Style : Braket_Style ) return Unbounded_String is
     (case Style is
         when Round  => '(' & S & ')',
         when Square => '[' & S & ']',
         when Curly  => '{' & S & '}'
     );


   ----------------------
   --  INSTANTIATIONS  --
   ----------------------

   Function As_Array is new To_Array(Integer_Type);
   Function As_Array is new To_Array(Real_Type);
   Function As_Array is new To_Array(Pointer_Type);
   Function As_Array is new To_Array(Fixed_Type);
   Function As_Array is new To_Array(Boolean_Type);
   Function As_Array is new To_Array(Func_Type);

   Function As_Hash is new To_Hash(Integer_Type);
   Function As_Hash is new To_Hash(Real_Type);
   Function As_Hash is new To_Hash(Pointer_Type);
   Function As_Hash is new To_Hash(Fixed_Type);
   Function As_Hash is new To_Hash(Boolean_Type);
   Function As_Hash is new To_Hash(Func_Type);

   Function Parse is new Parse_String( Integer_Type, 0, Integer_Type'Value );
   Function Parse is new Parse_String( Real_Type, 0.0, Real_Type'Value );
   Function Parse is new Parse_String( Fixed_Type, 0.0, Fixed_Type'Value );
   Function Parse is new Parse_String( Boolean_Type, True, Boolean_Type'Value );

   ----------------------
   --  IMPLEMENTATION  --
   ----------------------

   Function Convert(Value : Integer_Type ) return Array_Type
     renames As_Array;

   Function Convert(Value : Integer_Type ) return Hash_Type
     renames As_Hash;

   Function Convert(Value : Integer_Type ) return String_Type is
     ( Trim( Integer_Type'Image(Value) ) );

   Function Convert(Value : Integer_Type ) return Real_Type is
     ( Real_Type(Value) );

--     Function Convert(Value : Integer_Type ) return Pointer_Type;
--     Function Convert(Value : Integer_Type ) return Reference_Type;
   Function Convert(Value : Integer_Type ) return Fixed_Type is
     (if abs Value in 0..99_999_999_999_999 then Fixed_Type(Value)
      elsif Value > 0 then Fixed_Type'Last
      else  Fixed_Type'First
     );
   Function Convert(Value : Integer_Type ) return Boolean_Type is
     ( Boolean_Type(Value in 0..Integer_Type'Last) );
--     Function Convert(Value : Integer_Type ) return Func_Type;
--
   Function Convert(Value : Array_Type ) return Integer_Type is
     ( Integer_Type( Value.Length ) );

   Function Convert(Value : Array_Type ) return Hash_Type is
      Function Internal_Convert(Value : Array_Type; Offset : Integer) return Hash_Type is
      begin
         Return Result : Hash_Type do
            for C in Value.Iterate loop
               declare
                  Use Hash, List;
                  K : constant String := Natural'Image(To_Index(C) + Offset);
                  V : Representation renames Value(C);
               begin
                  if Get_Enumeration(V) /= RT_Array then
                     Result.Include( K, V );
                  else
                     Result.Include( K, Internal_Create( Internal_Convert(V.Array_Value, Offset+1) ) );
                  end if;
               end;
            end loop;
         end return;
      end Internal_Convert;
   begin
      Return Internal_Convert( Value, -1 );
   end Convert;

   Function Convert(Value : Array_Type ) return String_Type is
      Use Ada.Strings.Unbounded;
      Working : Unbounded_String;
   begin
      for Item in value.iterate loop
         declare
            Key    : Positive renames List.To_Index(Item);
            Last   : constant Boolean := Key = Value.Last_Index;
            Value  : constant String  := Image( List.Element( Item ) );
         begin
            Append(
                   Source   => Working,
                   New_Item => Value & (if not Last then ", " else "")
                  );
         end;
      end loop;

      Return Bracket( Working, Square );
   end Convert;

   Function Convert(Value : Array_Type ) return Real_Type is
     ( Real_Type(Value.Length) );

--     Function Convert(Value : Array_Type ) return Pointer_Type;
--     Function Convert(Value : Array_Type ) return Reference_Type;
   Function Convert(Value : Array_Type ) return Fixed_Type is
     ( Fixed_Type(Value.Length) );

   Function Convert(Value : Array_Type ) return Boolean_Type is
     ( Boolean_Type(Value.Length > 0) );

--     Function Convert(Value : Array_Type ) return Func_Type;
--
   Function Convert(Value : Hash_Type ) return Integer_Type is
     ( Integer_Type(Value.Length) );

   Function Convert(Value : Hash_Type ) return Array_Type is
   begin
      Return Result : Array_Type do
         for Item of Value loop
            Result.Append( Item );
         end loop;
      end return;
   end Convert;

   Function Convert(Value : Hash_Type ) return String_Type is
      use Ada.Strings.Unbounded, Hash;
      Working : Unbounded_String;
   begin
      for E in Value.Iterate loop
         Append(
            Source   => Working,
            New_Item => '"' & Key(E) & '"' &
                        " => " & Image(Element(E)) &
                        (if E /= Value.Last then ", " else "")
          );
      end loop;

      return Working;
   end Convert;

   Function Convert(Value : Hash_Type ) return Real_Type is
     ( Real_Type(Value.Length) );

--     Function Convert(Value : Hash_Type ) return Pointer_Type;
--     Function Convert(Value : Hash_Type ) return Reference_Type;
   Function Convert(Value : Hash_Type ) return Fixed_Type is
     ( Fixed_Type(Value.Length) );

   Function Convert(Value : Hash_Type ) return Boolean_Type is
     ( Boolean_Type(Value.Length > 0) );

--     Function Convert(Value : Hash_Type ) return Func_Type;
--
   Function Convert(Value : String_Type ) return Integer_Type
     renames Parse;
--     Function Convert(Value : String_Type ) return Array_Type;
--     Function Convert(Value : String_Type ) return Hash_Type;
   Function Convert(Value : String_Type ) return Real_Type
     renames Parse;
--     Function Convert(Value : String_Type ) return Pointer_Type;
--     Function Convert(Value : String_Type ) return Reference_Type;
   Function Convert(Value : String_Type ) return Fixed_Type
     renames Parse;
   Function Convert(Value : String_Type ) return Boolean_Type
     renames Parse;
--     Function Convert(Value : String_Type ) return Func_Type;
--

   Function Convert(Value : Real_Type ) return Integer_Type is
      First : Constant Real_Type:= Real_Type(Integer_Type'First);
      Last  : Constant Real_Type:= Real_Type(Integer_Type'Last);
      Subtype Int_Range is Real_Type range First..Last;
   begin
      return (if Value in Int_Range then Integer_Type(Value)
              elsif Value > Last then Integer_Type'Last
              else Integer_Type'First
             );
   end convert;

   Function Convert(Value : Real_Type ) return Array_Type
     renames As_Array;

   Function Convert(Value : Real_Type ) return Hash_Type
     renames As_Hash;

   Function Convert(Value : Real_Type ) return String_Type is
     ( Trim( Real_Type'Image(Value) ) );
--     Function Convert(Value : Real_Type ) return Pointer_Type;
--     Function Convert(Value : Real_Type ) return Reference_Type;
   Function Convert(Value : Real_Type ) return Fixed_Type is
      First : Constant Real_Type:= Real_Type(Fixed_Type'First);
      Last  : constant Real_Type:= Real_Type(Fixed_Type'Last);
      subtype Fixed_Range is Real_Type range First..Last;
   begin
      return (if Value in Fixed_Range then Fixed_Type( Value )
              elsif Value > Last then Fixed_Type'Last
              else  Fixed_Type'First
             );
   end Convert;

   Function Convert(Value : Real_Type ) return Boolean_Type is
     ( Boolean_Type(Value in 0.0..Real_Type'Last) );
--     Function Convert(Value : Real_Type ) return Func_Type;
--
--     Function Convert(Value : Pointer_Type ) return Integer_Type;
--     Function Convert(Value : Pointer_Type ) return Array_Type;
--     Function Convert(Value : Pointer_Type ) return Hash_Type;
--     Function Convert(Value : Pointer_Type ) return String_Type;
--     Function Convert(Value : Pointer_Type ) return Real_Type;
--     Function Convert(Value : Pointer_Type ) return Pointer_Type;
--     Function Convert(Value : Pointer_Type ) return Reference_Type;
--     Function Convert(Value : Pointer_Type ) return Fixed_Type;
--     Function Convert(Value : Pointer_Type ) return Boolean_Type;
--     Function Convert(Value : Pointer_Type ) return Func_Type;
--
   Function Convert(Value : Reference_Type ) return Integer_Type is
     (case Get_Enumeration(Value) is
         when RT_Integer    => Convert(Value),
         when RT_Array      => Convert(Value),
         when RT_Hash       => Convert(Value),
         when RT_String     => Convert(Value),
         when RT_Real       => Convert(Value),
         when RT_Pointer    => Convert(Value),
         when RT_Reference  => Convert(Value),
         when RT_Fixed      => Convert(Value),
         when RT_Boolean    => Convert(Value),
         when RT_Func       => Convert(Value)
      );
--     Function Convert(Value : Reference_Type ) return Array_Type;
--     Function Convert(Value : Reference_Type ) return Hash_Type;
--     Function Convert(Value : Reference_Type ) return String_Type;
--     Function Convert(Value : Reference_Type ) return Real_Type;
--     Function Convert(Value : Reference_Type ) return Pointer_Type;
--     Function Convert(Value : Reference_Type ) return Fixed_Type;
--     Function Convert(Value : Reference_Type ) return Boolean_Type;
--     Function Convert(Value : Reference_Type ) return Func_Type;

   Function Convert(Value : Fixed_Type ) return Integer_Type is
     ( Integer_Type(Value) );

   Function Convert(Value : Fixed_Type ) return Array_Type
     renames As_Array;

   Function Convert(Value : Fixed_Type ) return Hash_Type
     renames As_Hash;

   Function Convert(Value : Fixed_Type ) return String_Type is
     ( Trim( Fixed_Type'Image(Value) ) );

   Function Convert(Value : Fixed_Type ) return Real_Type is
     ( Real_Type(Value) );

--     Function Convert(Value : Fixed_Type ) return Pointer_Type;
--     Function Convert(Value : Fixed_Type ) return Reference_Type;
   Function Convert(Value : Fixed_Type ) return Boolean_Type is
     ( Boolean_Type(Value in 0.0..Fixed_Type'Last) );

--     Function Convert(Value : Fixed_Type ) return Func_Type;

   Function Convert(Value : Boolean_Type ) return Integer_Type is
     (If Value = True then 1 else -1);

   Function Convert(Value : Boolean_Type ) return Array_Type
     renames As_Array;

   Function Convert(Value : Boolean_Type ) return Hash_Type
     renames As_Hash;

   Function Convert(Value : Boolean_Type ) return String_Type is
     (+(if Value = True then "TRUE" else "FALSE"));

   Function Convert(Value : Boolean_Type ) return Real_Type is
     (if Value = True then 1.0 else -1.0);

   Function Convert(Value : Boolean_Type ) return Pointer_Type is
     (if Value = True then Pointer_Type(System.Null_Address)
      else Pointer_Type( To_Address(SE.Integer_Address'Last) )
     );

--     Function Convert(Value : Boolean_Type ) return Reference_Type;
   Function Convert(Value : Boolean_Type ) return Fixed_Type is
     (If Value = True then 1.0 else -1.0);

--     Function Convert(Value : Boolean_Type ) return Func_Type;


--     Function Convert(Value : Func_Type ) return Integer_Type;
--     Function Convert(Value : Func_Type ) return Array_Type;
--     Function Convert(Value : Func_Type ) return Hash_Type;
--     Function Convert(Value : Func_Type ) return String_Type;
--     Function Convert(Value : Func_Type ) return Real_Type;
--     Function Convert(Value : Func_Type ) return Pointer_Type;
--     Function Convert(Value : Func_Type ) return Reference_Type;
--     Function Convert(Value : Func_Type ) return Fixed_Type;
--     Function Convert(Value : Func_Type ) return Boolean_Type;
--
End Conversions;
