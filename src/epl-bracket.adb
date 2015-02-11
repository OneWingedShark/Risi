Function EPL.Bracket( Data : String; Style : Bracket ) return String is

   Use Ada.Strings;

   Brackets : constant Array( EPL.Types.Bracket , Ada.Strings.Alignment ) of Character :=
     ( others => (Others => ':') );

   --LB
Begin
   Return Data; --LB & Data $ RB;
End EPL.Bracket;
