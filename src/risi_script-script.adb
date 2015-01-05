With
GNAT.CRC32,
Ada.Text_IO,
Ada.Integer_Text_IO,
Ada.Characters.Latin_1,
Ada.Characters.Handling,
Ada.Strings.Fixed,
Ada.Containers.Indefinite_Holders,
ada.Strings.Maps.Constants,
Risi_Script.Types,
Interfaces;
with Ada.IO_Exceptions, Ada.Exceptions;

Package Body Risi_Script.Script is

   Package Integer_IO is new Ada.Text_IO.Integer_IO( Natural );

   Function Find_Line (Input  : Script;
                       Number : Positive;
                       Scope  : String := "Global"
                       ) return Natural is
   begin
      Return Result : Natural:= 0 do
         SEARCH:
         For Index in 1..Natural(Input.Length) loop
            declare
               Current_Line       : Line renames Line'(Lines.Vector(Input)(Index));
               Current_Line_Scope : String renames Current_Line.Scope.All;
            begin

            if Current_Line_Scope = Scope and then Current_Line.Number = Number then
               Result:= Positive(Index);
               exit Search;
            end if;
            end;
         End Loop SEARCH;
      end return;
   end Find_Line;

   Function Get_Line( Input    : Script;
                      Number   : Positive;
                      Position : Boolean:= False ) return String is
     (if Position then Line'(Lines.Vector(Input)(Number)).Data
      else Line'(Lines.Vector(Input)(Input.Find_Line(Number)) ).Data );



   Function Load( File : Ada.Text_IO.File_Type ) return Script is
      package String_Holder is new Ada.Containers.Indefinite_Holders(
            Element_Type => String
         );
      package Positive_Stack is new Ada.Containers.Vectors(
            "="          => "=",
            Index_Type   => Positive,
            Element_Type => Positive
         );
      package Namespace_Stack is new Ada.Containers.Indefinite_Vectors(
            "="          => "=",
            Index_Type   => Positive,
            Element_Type => String
         );

      Type Line_Number_Vector is new Positive_Stack.Vector with null record;

      Line_Number_Store : Line_Number_Vector;
      Namespace_Store   : Namespace_Stack.Vector;


      Line_Number   : Positive:= 1;

      Comment_Count : Natural:= 0;
      Scope_String  : not null access String:= new String'("Global");
   begin
      Line_Number_Store.Append( 1 );
      Namespace_Store.Append( Risi_Script.Types.Identifier'("Global") );

      Return Result : Script do
         loop
            declare
               Use Ada.Strings.Fixed, Ada.Strings;
               This    : Lines.Vector renames Lines.Vector(Result);

               Text    : constant String:= Ada.Text_IO.Get_Line(File);
               Trimmed : String renames Trim(Text, Side => Both);

               Function Is_Comment( S :String ) return Boolean is
                  Slash : Natural;
                  Use Ada.Strings.Fixed;
               begin
                  Slash:= Index(Source  => S,
                                Pattern => "\",
                                Going   => Forward
                               );
                  if Slash in Positive then
                     declare
                        subtype Subindex is Positive range S'First..Positive'Pred(Slash);
                        Substring : String renames S(Subindex);
                        Use Ada.Characters.Handling, Ada.IO_Exceptions;
                        Number : Integer;
                        Last   : Positive;
                     begin

                           Ada.Integer_Text_IO.Get(
                                                   From => Substring,
                                                   Item => Number,
                                                   Last => Last
                                                  );

                           return false;                   -- When a line containing \ has a line-number.
                        exception
                           when End_Error  => return true; -- When a comment is just \.
                           when Data_Error =>              -- When a comment is prefixed by pipes.
                              if not (for all Ch of Substring =>
                                        (if Is_Graphic(Ch) then Ch = '|')
                                     ) then raise Format_Error with
                                   "Malformed comment detected at line " &
                                   Positive'Image(Positive(this.Length)+1) &
                                   ". -> (" & Trimmed & ')';
                              end if;
                              return True;

                           when E:Others =>
                              Ada.Text_IO.Put_Line("Something happened ["
                                                     & Ada.Exceptions.Exception_Name(E) &
                                                     "]. -> " & '(' & S & ')');
                           raise;

                     end;
                  else
                     return False;
                  end if;
               end Is_Comment;


               Comment : Boolean renames Is_Comment( Trimmed );
               Data    : constant Line:=
                 (Number => (if Comment or Trimmed'Length = 0
                             or (Text'Length in Positive and then
                                 Text(Text'First) = Ada.Characters.Latin_1.Copyright_Sign)
                             then 0
                             else Line_Number
                            ),
                  Length => Text'Length,
                  Data   => Text,
                  Scope  => Scope_String
                 );
            begin
               This.Append( Data );

               -- \Comments are of this form
               -- |\with successive [continuous] lines
               -- ||\having more bars prefixed.
               if Comment then
                  declare
                     Comment_Prefix : String renames
                       Trimmed(Trimmed'First..Trimmed'First+Comment_Count-1);
                  begin
                     if (for some Ch of Comment_Prefix =>  ch /= '|') or
                        (Trimmed(Trimmed'First+Comment_Count) /= '\')
                     then
                        raise Format_Error with
                          "Non-sequential comment detected at line" &
                          This.Length'Img &
                          ". -> (" & Trimmed &')';
                     end if;
                  end;
                  Comment_Count:= Comment_Count + 1;
               elsif Trimmed'Length not in positive then
                  -- Blank lines are allowed; they do not require the
                  -- Incrementation of line-numbers.
                  Comment_Count:= 0;
               elsif Text(Text'First) = Ada.Characters.Latin_1.Copyright_Sign then
                  -- Remove (c) form script.
                  Result.Delete_Last;

                  -- Add (C) to metadata.
                  Result.Metadata.Include(  Ada.Characters.Latin_1.Copyright_Sign&"", Text(Text'First+1..Text'Last) );

                  GET_METADATA:
                  loop
                     declare
                        Use Ada.Strings.Fixed, Ada.Strings;
                        Text  : constant String:= Ada.Text_IO.Get_Line(File);
                        Colon : constant Positive:= Index(Source  => Text, Pattern => ":");
                        subtype Key_range is positive range Text'First..Positive'Pred(Colon);
                        subtype Val_Range is positive range Colon+2..Text'Last;
                     begin
                        Result.Metadata.Include(
                           Key      => Text(Key_range),
                           New_Item => Text(Val_Range)
                        );
                     end;
                  end loop GET_METADATA;
               else
                  Comment_Count:= 0;
                  declare
                     X, Last : Natural;
                  begin
                     Integer_IO.Get(From => This.Last_Element.Data,
                                    Item => X,
                                    Last => Last
                                   );
                     if X /= Line_Number then
                        Raise Format_Error with
                          "Line numbering:"
                          & Natural'Image(X) & " /="
                          & Natural'Image(Line_Number)
                          & '.';
                     end if;
                  end;


                  -- Line_Number:= Positive'Succ(Line_Number);
                  declare
                     New_Number : Positive := Positive'Succ(Line_Number_Store.Last_Element);
                  begin
                     Line_Number_Store.Delete_Last;
                     Line_Number_Store.Append( New_Number );
                  end;

                  declare
                     UP_CASE  : Ada.Strings.Maps.Character_Mapping renames
                                      Ada.Strings.Maps.Constants.Upper_Case_Map;
                     Fn_Loc   : constant Natural:= Index(Source  => Text,
                                                         Pattern => "FUNCTION",
                                                         Going   => Forward,
                                                         Mapping => UP_CASE
                                                     );
                     Eval_Loc : constant Natural := Index(Source  => Text,
                                                          Pattern => "EVALUATES",
                                                          Going   => Forward,
                                                          Mapping => UP_CASE
                                                     );
                     Is_Fn    : constant Boolean := (Fn_Loc   in Positive
                                                 and Eval_Loc > Fn_Loc
                                                    );
                     End_Loc  : constant Natural := Index(Source  => Text,
                                                          Pattern => "END",
                                                          Going   => Forward,
                                                          Mapping => UP_CASE
                                                     );
                     Dot_Loc  : constant Natural := Index(Source  => Text,
                                                          Pattern => ".",
                                                          Going   => Forward,
                                                          Mapping => UP_CASE
                                                     );

                     Scope_Name : String renames Namespace_Store.Last_Element;

                     Function Alphanumeric(Ch : Character) return Boolean
                                      renames Ada.Characters.Handling.Is_Alphanumeric;
                     Function Control(Ch : Character) return Boolean
                                      renames Ada.Characters.Handling.Is_Control;
                     Function Graphic(Ch : Character) return Boolean
                                      renames Ada.Characters.Handling.Is_Graphic;


                     Is_End     : constant Boolean:= (if End_Loc in Positive
                                                and then Dot_Loc > End_Loc
                                                and then (Text(End_Loc+3) in ' '|ASCII.HT|ASCII.VT|ASCII.NUL )
--                                                  and then (for all Ch of Text(Text'First..End_Loc-1) => Ch in ' '|'0'..'9')
                                                    then True else False
                                                     );
                     Scope      : constant String:= (if Is_Fn then
                                                        Trim(Side => Both, Source => Text(Fn_Loc+8..Eval_Loc-1))
                                                     elsif Is_End then
                                                        Trim(Side => Both, Source => Text(End_Loc+3..Dot_Loc-1))
                                                     else
                                                        ""
                                                    );

                  begin
                     if Is_Fn then
                        -- Init the new scope.
                      Namespace_Store.Append( Scope );
                        -- Init the new line-numbering.
                        Line_Number_Store.Append( 1 );
                     elsif Is_End then
                        declare
                           LNS      : Line_Number_Vector renames Line_Number_Store;
                           Fn_Lines : Positive renames LNS.Last_Element;
                        begin
                           -- Return to the lower scope.
                           LNS.Delete_Last;
                           Namespace_Store.Delete_Last;
                           -- Add the intervining lines, correcting for the
                           -- extreanous increment.
                           LNS.Replace_Element(
                              Index    => LNS.Last_Index,
                              New_Item => Fn_Lines + LNS.Last_Element - 1
                            );
                        end;

                     elsif Fn_Loc in Positive xor Eval_Loc in Positive then
                        raise Format_Error with
                          "Malformed function header on" & Line_Number'Img & '.';
                     elsif is_end then
                       --End_Loc in Positive and Dot_Loc not in Positive then
Ada.Text_IO.Put_Line( "----->["& Text(Text'First..End_Loc-1) &']' );
--  Ada.Text_IO.Put_Line( "----->["& Boolean'Image(for some Index in Text'First..End_Loc-1 =>
--                                                   (if Ada.Characters.Handling.Is_Graphic(Text(Index))
--                                                    then Text(Index) not in ' '|'0'..'9'))
--                                                &']'
--                       );
                        declare
                           Use Ada.Characters.Handling;
                        begin
                           if (for some Index in Text'First..End_Loc-1 =>
                                                 (Is_Graphic(Text(Index)) and
                                                  then Text(Index) not in ' '|'0'..'9')) then

                              Ada.Text_IO.Put_Line( "Scope: " & Scope );
                              Ada.Text_IO.Put_Line( "DOT: " & Dot_Loc'Img );
                              Ada.Text_IO.Put_Line( "END: " & End_Loc'Img );

--                                                   (if Is_Graphic(Text(Index))
--                                                    then Text(Index) not in ' '|'0'..'9')) then
                           raise Format_Error with
                             "Malformed function end on" & Line_Number_Store.Last_Element'Img & '.';
                           end if;
                        end;


--                             if (for some Index in Text'First..End_Loc-1 =>
--                                                   (if Is_Graphic(Text(Index))
--                                                    then Text(Index) not in ' '|'0'..'9')) then



                     end if;
                  end;

                  Line_Number:= Line_Number_Store.Last_Element;

               end if;
            end;
         end loop;
      exception
            when Ada.Text_IO.End_Error => Null;
      end return;
   end Load;

   Function Strings( Object : Script ) return String_Array is
      function "="(Left, Right: String) return boolean renames Ada.Strings.Equal_Case_Insensitive;
      Default  : Aliased String:= "";
      Position : Positive:= 1;
      Length : constant Natural := Natural(Object.Length + Object.Metadata.Length);
   begin
      Return Result : String_Array(1..Length):= (others => Default'Unchecked_Access) do
         For Line of Object loop
            declare
               Line_Number,
               Data_Line_No : String(1..4);
            begin
               Integer_IO.Put( Item => Position,    To => Line_Number  );
               Integer_IO.Put( Item => Line.Number, To => Data_Line_No );
               Result(Position):= New String'( '['&Line_Number&':'&Data_Line_No&']' &
                                               ASCII.HT &
                                               Line.Data
                                             );
            end;
            Position:= Position + 1;
         End loop;


         declare
            Procedure Add_Item( C : Metadata_Package.Cursor ) is
               use Metadata_Package;
            begin
               Result(Position):= New String'( "[Meta-Data]" & ASCII.HT &
                                                 Key(C) & ':' &
                                               (if Key(C) = "Checksum" then ' '
                                                  else ASCII.HT) &
                                                 Element(C)
                                              );
               Position:= Position + 1;
            end Add_Item;

         begin
            Object.Metadata.Iterate( Add_Item'Access );
         end;

      end return;
   end;

   Function Get_Metadata( Object : Script ) return Metadata_Package.Map is
     (Object.Metadata);

   Function CRC( Object : Script ) return String is
      use GNAT.CRC32;
      Checksum : CRC32;

      Package CRC_IO is new Ada.Text_IO.Modular_IO( Interfaces.Unsigned_32 );
   begin
      Initialize( Checksum );

      SCRIPT_BODY:
      for Item of Object loop
         Update(Value => Item.Data, C => Checksum);
      end loop SCRIPT_BODY;

      SCRIPT_METADATA:
      Declare
         Metadata : Metadata_Package.Map:= Object.Metadata.Copy;

         use Metadata_Package;
         Function As_String( Item : Cursor ) return String is
           ( Key(Item) & ':' & ASCII.HT & Element(Item) );
         Procedure Display ( Item : Cursor ) is
         begin
            Ada.Text_IO.Put_Line( Key(Item) & " => " & Element(Item) );
         end;

         Procedure Process( Item : Cursor ) is
         begin
            Update(Value => As_String(Item), C => Checksum);
         end;
         Copyright : Character renames
           Ada.Characters.Latin_1.Copyright_Sign;
      Begin
         -- Handle the copyright line.
         Update(C => Checksum, Value => Copyright & Metadata((1 => Copyright)));
         Metadata.Delete( String'(1 => Copyright) );

         -- Remove the checksum.
         Metadata.Delete( "Checksum" );

         --
         Metadata.Iterate( Process'Access );
      exception
         when Constraint_Error =>
            Ada.Text_IO.Put_Line( "Metadata Entries:" & Metadata.Length'img );
            Metadata.Iterate( Display'Access );
      End SCRIPT_METADATA;


      declare
         Image : string(1..12);
      begin
         CRC_IO.Put(Item => Get_Value(Checksum), Base => 16, To => Image);
         declare
            Use Ada.Strings.Fixed, Ada.Strings;
            Start : Positive renames Positive'Succ(Index(Image,"#"));
            Stop  : Positive renames Positive'Pred(Index(Image,"#",Backward));
         begin
            Ada.Text_IO.Put_Line(Image);
            Return Image(Start..Stop);
         end;
      end;

   end CRC;



   -- Joins two metadata sections together; if keys conflict then LEFT is preferred.
   Function "&"(Left, Right : Metadata_Package.Map) return Metadata_Package.Map is

   begin
      Return Result : Metadata_Package.Map:= Left.Copy do
         declare
            Use Metadata_Package;
            Procedure Add_New( Position : Cursor ) is
            begin
               if not Result.Contains( Key(Position) ) then
                  Result.Include(Key      => Key(Position),
                                 New_Item => Element(Position)
                                );
               end if;
            end Add_New;
         begin
            Right.Iterate(Process => Add_New'Access);
         end;
      end return;
   end "&";

   Function Line_Count( Object : Script ) return Natural is
      ( Natural(Object.Length) );

   Function Get_Line( Object : Script; Line : Positive ) return String is
      ( Lines.Vector(Object)(Line).Data );

   Function Init return Script is
     ( Lines.Empty_Vector with Metadata => Metadata_Package.Empty_Map );

   ---------------
   -- OVERRIDES --
   ---------------

   overriding function To_Vector (Length : Count_Type) return Script is
      ( Lines.To_Vector(Length) with Metadata => Metadata_Package.Empty_Map );

   overriding function To_Vector (New_Item : Line; Length : Count_Type) return Script is
      ( Lines.To_Vector(New_Item,Length) with Metadata => Metadata_Package.Empty_Map );

   overriding function "&" (Left, Right : Script) return Script is
      ( Lines."&"(Lines.Vector(Left), Lines.Vector(Right)) with Metadata => Left.Metadata & Right.Metadata );

   overriding function "&" (Left : Script; Right : Line) return Script is
      ( Lines."&"(Lines.Vector(Left), Right) with Metadata => Left.Metadata );

   overriding function "&" (Left : Line; Right : Script) return Script is
      ( Lines."&"(Left, Lines.Vector(Right)) with Metadata => Right.Metadata );

   overriding function "&" (Left, Right : Line) return Script is
      ( Lines."&"(Left, Right) with Metadata => Metadata_Package.Empty_Map );

   overriding function Copy (Source : Script; Capacity : Count_Type := 0) return Script is
      ( Lines.Copy(Lines.Vector(Source), Capacity) with Metadata => Metadata_Package.Empty_Map );


End Risi_Script.Script;
