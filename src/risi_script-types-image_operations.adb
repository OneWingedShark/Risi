With
System.Address_Image,
Ada.Strings.Fixed,
Ada.Strings.Unbounded;

Separate(Risi_Script.Types)
Package Body Image_Operations is

   -------------------------
   --  UTILITY FUNCTIONS  --
   -------------------------

   Function Trim( S : String ) return String is
      Use Ada.Strings.Fixed, Ada.Strings;
   begin
      Return Trim(Side => Left, Source => S);
   end Trim;

   Function Trim( S : String ) return Ada.Strings.Unbounded.Unbounded_String is
      Use Ada.Strings.Unbounded;
   begin
      Return To_Unbounded_String(  Trim(S)  );
   end Trim;


   ----------------------------
   -- IMAGE IMPLEMENTATIONS  --
   ----------------------------

   Function Static_Dispatch_Image( Elem : Representation ) return String is
     (case Get_Enumeration(Elem) is
         when RT_Integer    => Image(Elem.Integer_Value),
         when RT_Array      => Image(Elem.Array_Value),
         when RT_Hash       => Image(Elem.Hash_Value),
         when RT_String     => Image(Elem.String_Value),
         when RT_Real       => Image(Elem.Real_Value),
         when RT_Pointer    => Image(Elem.Pointer_Value),
         when RT_Reference  => Image_Operations.Image(Elem.Reference_Value),
         when RT_Fixed      => Image(Elem.Fixed_Value),
         when RT_Boolean    => Image(Elem.Boolean_value),
         when RT_Func       => Image(Elem.Func_Value)
     );



   Function Image(Item : Integer_Type) return String is
     ( Trim( Integer_Type'Image(Item) ) );

   Function Image(Item : Array_Type) return String is
      Use Ada.Strings.Unbounded, List;
      Working : Unbounded_String;
   begin
      for E in Item.Iterate loop
         declare
            Key  : constant Natural := To_Index( E );
            Last : constant Boolean := Key = Item.Last_Index;
            Elem : Representation renames Element(E);
            Item : constant string  := Static_Dispatch_Image( Elem );
         begin
            Append(
                   Source   => Working,
                   New_Item => Item & (if not Last then ", " else "")
                  );
         end;
      end loop;

      return To_String( Working );
   end Image;



   Function Image(Item : Hash_Type) return String is
      Use Ada.Strings.Unbounded, Hash;
      Working : Unbounded_String;
   begin
      for E in Item.Iterate loop
         declare
            Key  : constant String := '"' & Hash.Key( E ) & '"';
            Last : constant Boolean := E = Item.Last;
            Elem : Representation renames Element(E);
            Item : constant string  :=
              (case Get_Enumeration(Elem) is
                  when RT_Integer    => Image(Elem.Integer_Value),
                  when RT_Array      => Image(Elem.Array_Value),
                  when RT_Hash       => Image(Elem.Hash_Value),
                  when RT_String     => Image(Elem.String_Value),
                  when RT_Real       => Image(Elem.Real_Value),
                  when RT_Pointer    => Image(Elem.Pointer_Value),
                  when RT_Reference  => Image_Operations.Image(Elem.Reference_Value),
                  when RT_Fixed      => Image(Elem.Fixed_Value),
                  when RT_Boolean    => Image(Elem.Boolean_value),
                  when RT_Func       => Image(Elem.Func_Value)
              );
         begin
            Append(
                   Source   => Working,
                   New_Item => Key & " => " &
                               Item & (if not Last then ", " else "")
                  );
         end;
      end loop;

      return To_String( Working );
   end Image;

   Function Image(Item : String_Type) return String
     renames Ada.Strings.Unbounded.To_String;
   Function Image(Item : Real_Type) return String is
     ( Trim( Real_Type'Image(Item) ) );
    Function Image(Item : Pointer_Type) return String is
     ( System.Address_Image( System.Address(Item) ) );
   Function Image(Item : Fixed_Type) return String is
      ( Trim( Fixed_Type'Image(Item) ) );
   Function Image(Item : Boolean_Type) return String is
      ( Boolean_Type'Image(Item) );
   Function Image(Item : Func_Type) return String is ("");


   Function Image(Item : Reference_Type ) return String is
     (case Get_Enumeration(Item) is
         when RT_Integer   => Image( Item.Integer_Value ),
         when RT_Array     => Image( Item.Array_Value ),
         when RT_Hash      => Image( Item.Hash_Value ),
         when RT_String    => Image( Item.String_Value ),
         when RT_Real      => Image( Item.Real_Value ),
         when RT_Pointer   => Image( Item.Pointer_Value ),
         when RT_Reference => Types.Image( Item.Reference_Value ),
         when RT_Fixed     => Image( Item.Fixed_Value ),
         when RT_Boolean   => Image( Item.Boolean_Value ),
         when RT_Func      => Image( Item.Func_Value )
     );

End Image_Operations;
