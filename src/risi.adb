Pragma Ada_2012;

----------------------------------
--  Miscellaneous Dependencies  --
----------------------------------

with
GNAT.CRC32,
Ada.Characters.Latin_1,
Ada.Containers.Indefinite_Vectors,
Ada.Strings.Fixed,
Ada.Text_IO;

--------------------------------
--  Risi_Script Dependencies  --
--------------------------------

with
--  Risi_Script.Script,
Risi_Script.Types.Patterns,
Risi_Script.Types.Identifier.Scope,
Risi_Script.Types.Implementation;--,
--  Risi_Script.Interpreter;

------------------
--  Visibility  --
------------------

use
Ada.Characters.Latin_1;

procedure Risi is
begin
--  --     REPL:
--  --     loop
--  --        declare
--  --           use Ada.Strings.Fixed, Ada.Strings, Ada.Text_IO;
--  --           Input : String:= Trim(Get_Line, Side => Both);
--  --        begin
--  --           Put_Line( '[' & Input & ']' );
--  --        end;
--  --     end loop REPL;
--
--  --     declare
--  --        package ET is new Ada.Text_IO.Enumeration_IO( Risi_Script.Types.Enumeration );
--  --        package IT is new Ada.Text_IO.Enumeration_IO( Risi_Script.Types.Indicator   );
--  --        Use ET, IT, Ada.Text_IO;
--  --        Use Type Risi_Script.Types.Enumeration, Risi_Script.Types.Indicator;
--  --     begin
--  --        for Item in Risi_Script.Types.Enumeration loop
--  --           Put( +Item  );
--  --           Put( ASCII.HT );
--  --           Put( Item );
--  --           New_Line;
--  --        end loop;
--  --     end;


--     declare
--        Use Risi_Script.Script;
--        File_Name : Constant String:= "Test_2.ris";
--
--        Function Get_File(Name : String:= File_Name) return Ada.Text_IO.File_Type is
--        begin
--           Return Result : Ada.Text_IO.File_Type do
--              Ada.Text_IO.Open( File => Result,
--                                Mode => Ada.Text_IO.In_File,
--                                Name => Name
--                              );
--           end return;
--        end Get_File;
--
--
--        Data_File     : Ada.Text_IO.File_Type:= Get_File( File_Name );
--        Script_Object : Script:= Load( Data_File );
--        X : String_Array renames Script_Object.Strings;
--        V : Risi_Script.Interpreter.VM:= Risi_Script.Interpreter.Init;
--     begin
--        Ada.Text_IO.Put_Line( '['& "Count:"&Natural'Image(X'Length) &']' );
--        for Datum of X loop
--           Ada.Text_IO.Put_Line( Datum.All );
--        end loop;
--
--        Ada.Text_IO.Put_Line( "Checksum:["& Script_Object.CRC &"]" );
--
--     end;

   For Sigil in Risi_Script.Types.Enumeration loop
      declare
         Use Risi_Script.Types, Ada.Text_IO;
         Type_Name : Constant String := Enumeration'Image( Sigil );
         Sigil_Img : Constant Character:= +(+Sigil);
      begin
         Put_Line( Type_Name & ' ' & Sigil_Img );

      end;
   end loop;

   declare
      Package ID renames Risi_Script.Types.Identifier;
      Use ID.Scope, Ada.Text_IO;
      Temp : Scope;
      Ident : constant ID.Identifier:= "a_a";
   begin
      pragma Warnings(Off);
      Temp.Append( "Temporary" );
      Temp.Append( "Scope"     );
      Temp.Append( "Test"      );
      pragma Warnings(On);
      Put_Line( "Qualified Path: [" & Image(Temp) & ']' );
   end;

   declare
      Package Patterns renames Risi_Script.Types.Patterns;
      Use Patterns, Ada.Text_IO, Risi_Script.Types,
          Risi_Script.Types.Implementation;

      A : Representation:= Create( RT_Fixed   );
      B : Representation:= Create( RT_Boolean );
      C : Representation:= Create( RT_String  );

      Temp_1 : Patterns.Half_Pattern:= Create((A,B,C));
      Temp_2 : Indicator_String:= "`?$$";
   begin
      Put_Line( "Pattern: [" & (+Temp_1) & ']' );
      Put_Line( "Sigils:  [" & (+Temp_2) & ']' );
      Put_Line( "Match: " & Match(Temp_1, Temp_2)'Img );
   end;

      Ada.Text_IO.Put_Line( Ada.Characters.Latin_1.LC_German_Sharp_S & "" );
end Risi;
