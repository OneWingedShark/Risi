Pragma Ada_2012;

With
Ada.Text_IO.Text_Streams,
Ada.Strings.Less_Case_Insensitive,
Ada.Strings.Equal_Case_Insensitive,
Ada.Strings.Unbounded,
Ada.Containers.Vectors,
Ada.Containers.Indefinite_Ordered_Maps,
Ada.Containers.Indefinite_Vectors;

Package Risi_Script.Script is

   Package Metadata_Package is new Ada.Containers.Indefinite_Ordered_Maps(
      "<"          => Ada.Strings.Less_Case_Insensitive,
      "="          => Ada.Strings.Equal_Case_Insensitive,
      Key_Type     => String,
      Element_Type => String
   );

   Type String_Array;
   Type Script is tagged private;

   Function Init return Script;
   Function Strings( Object : Script ) return String_Array;
   Function Get_Metadata( Object : Script ) return Metadata_Package.Map;
   Function CRC( Object : Script ) return String;
   Function Line_Count( Object : Script ) return Natural;
   --Function Get_Line( Object : Script; Line : Positive ) return String;

   Type String_Array is Array(Positive Range <>) of not null access constant String;


   -- Get_Line returns the scanned line Number when Position is true,
   -- otherwise the first line with a matching line-number.
   Function Get_Line( Input    : Script;
                      Number   : Positive;
                      Position : Boolean:= False ) return String;

   -- Find_Line returns the first line whose number matches the given input.
   Function Find_Line( Input  : Script;
                       Number : Positive;
                       Scope  : String := "Global"
                     ) return Natural;

   -- Reads a file and returns a script-object.
   Function Load( File : Ada.Text_IO.File_Type ) return Script;


   -- Raised when the parser detects a malformed script.
   Format_Error : Exception;
Private
   Use Ada.Containers;


   Function "&"(Left, Right : Metadata_Package.Map) return Metadata_Package.Map;

   -- Number:	This is the line-number associated with the line of code.
   --		NOTE:	Comments always have a Number of 0.
   -- Length:	This is the length of the line as read in.
   -- Scope:	This indicates the module the line associates with.
   Type Line(Number : Natural; Length : Natural; Scope : not null access String) is record
      Data : String(1..Length);
   end record;

   Package Lines is new Ada.Containers.Indefinite_Vectors(
--        "="          => ,
      Index_Type   => Positive,
      Element_Type => Line
   );

   Type Script is new Lines.Vector with record
      Metadata : Metadata_Package.Map;
   end record;

   overriding function To_Vector (Length : Count_Type) return Script;
   overriding function To_Vector (New_Item : Line; Length : Count_Type) return Script;
   overriding function "&" (Left, Right : Script) return Script;
   overriding function "&" (Left : Script; Right : Line) return Script;
   overriding function "&" (Left : Line; Right : script) return Script;
   overriding function "&" (Left, Right : Line) return Script;
   overriding function Copy (Source : Script; Capacity : Count_Type := 0) return Script;

End Risi_Script.Script;
