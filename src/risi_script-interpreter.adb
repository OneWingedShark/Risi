with
Risi_Script.Types,
Ada.Text_IO;


Package Body Risi_Script.Interpreter is

   Procedure Create_Variable( MRE     : in out VM;
                              Value   : Representation;
                              Name    : Identifier:= "Evaluated";
                              Context : Identifier:= "Global"
                            ) is
   begin
      MRE.Scopes(Context)(Name):= Value;
   end;

   Function  Retrieve_Variable( MRE     : in out VM;
                                Name    : Identifier:= "Evaluated";
                                Context : Identifier:= "Global"
                               ) return Representation is
   begin
      Return MRE.Scopes(Context)(Name);
   end Retrieve_Variable;

   Procedure Push_Parameter   ( MRE     : in out VM;
                                Value   : Representation
                              ) is
   begin
      Push( MRE.Parameters, Value );
   End Push_Parameter;

  Function  Pop_Parameter     ( MRE     : in out VM
                              ) return Representation is
   begin
      Return Pop( MRE.Parameters );
   End Pop_Parameter;

   Function  Peek_Parameter   ( MRE     : in out VM;
                                Location: Positive
                              ) return Representation is
   begin
      Return Peek( MRE.Parameters, Location );
   End Peek_Parameter;

   Procedure Execute         ( MRE      : in out VM;
                               Debugging: Boolean := False
                             ) is
      Use Risi_Script.Script;
   begin
      Ada.Text_IO.Put_Line( Get_Line(MRE.Program.All, MRE.Current_Line) );



      MRE.Current_Line:= Positive'Succ( MRE.Current_Line );
      if Debugging then
         null;
      end if;
   end Execute;

   Procedure Load            ( MRE      : in out VM;
                               Script   : Risi_Script.Script.Script
                             ) is
   begin
      MRE.Program.all:= Script;
   end Load;

   Function Init               return VM is
     ( Program => new Risi_Script.Script.Script'(Risi_Script.Script.Init),
       Result  => new Risi_Script.Types.Representation'( Risi_Script.Types.Create(RT_Integer) ),
--         Result  => new Risi_Script.Types.Representation'( Risi_Script.Types.Create(RT_Integer) ),
       others  => <>
     );



End Risi_Script.Interpreter;
