with
GNAT.CRC32,
Ada.Containers.Indefinite_Vectors,
Risi_Script.Script,
Risi_Script.Types,
Ada.Strings.Fixed,
Ada.Text_IO;

with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Risi_Script.Interpreter;

procedure Risi is
begin
--     REPL:
--     loop
--        declare
--           use Ada.Strings.Fixed, Ada.Strings, Ada.Text_IO;
--           Input : String:= Trim(Get_Line, Side => Both);
--        begin
--           Put_Line( '[' & Input & ']' );
--        end;
--     end loop REPL;

--     declare
--        package ET is new Ada.Text_IO.Enumeration_IO( Risi_Script.Types.Enumeration );
--        package IT is new Ada.Text_IO.Enumeration_IO( Risi_Script.Types.Indicator   );
--        Use ET, IT, Ada.Text_IO;
--        Use Type Risi_Script.Types.Enumeration, Risi_Script.Types.Indicator;
--     begin
--        for Item in Risi_Script.Types.Enumeration loop
--           Put( +Item  );
--           Put( ASCII.HT );
--           Put( Item );
--           New_Line;
--        end loop;
--     end;


   declare
      Use Risi_Script.Script;
      File_Name : Constant String:= "Test_2.ris";

      Function Get_File(Name : String:= File_Name) return Ada.Text_IO.File_Type is
      begin
         Return Result : Ada.Text_IO.File_Type do
            Ada.Text_IO.Open( File => Result,
                              Mode => Ada.Text_IO.In_File,
                              Name => Name
                            );
         end return;
      end Get_File;


      Data_File     : Ada.Text_IO.File_Type:= Get_File( File_Name );
      Script_Object : Script:= Load( Data_File );
      X : String_Array renames Script_Object.Strings;
      V : Risi_Script.Interpreter.VM:= Risi_Script.Interpreter.Init;
   begin
      Ada.Text_IO.Put_Line( '['& "Count:"&Natural'Image(X'Length) &']' );
      for Datum of X loop
         Ada.Text_IO.Put_Line( Datum.All );
      end loop;

      Ada.Text_IO.Put_Line( "Checksum:["& Script_Object.CRC &"]" );

   end;



      Ada.Text_IO.Put_Line( Ada.Characters.Latin_1.LC_German_Sharp_S & "" );
end Risi;
