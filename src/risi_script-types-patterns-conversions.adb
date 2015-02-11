With
EPL.Types,
EPL.Bracket,
Ada.Strings.Fixed;

Separate (Risi_Script.Types.Patterns)
Package Body Conversions is


   Function Trimmed_Image( Input : Integer ) return String is
      Use Ada.Strings.Fixed, Ada.Strings;
   Begin
      return Trim(Side => Left, Source => Integer'Image(Input));
   End Trimmed_Image;


   -------------------------
   --  PATTERN TO STRING  --
   -------------------------

   Function Convert( Pattern : Half_Pattern		 ) return String is
   Begin
      Return Result : String(Pattern'Range) do
         for Index in Result'Range loop
            Result(Index):= +Pattern(Index);
         end loop;
      End Return;
   End Convert;

   Function Convert( Pattern : Three_Quarter_Pattern	 ) return String is
      Function Internal_Convert( Pattern : Three_Quarter_Pattern	 ) return String is
         Subtype Tail is Positive Range Positive'Succ(Pattern'First)..Pattern'Last;
      Begin
         if Pattern'Length not in Positive then
            return "";
         else
            Declare
               Head   : Enumeration_Length renames Pattern(Pattern'First).All;
               Sigil  : constant Character := +Head.Enum;
               Length : constant String :=
                 (if Head.Enum not in RT_String | RT_Array | RT_Hash then ""
                  else '(' & Trimmed_Image(Head.Length) & ')');
            Begin
               return Sigil & Length & String'(+Pattern(Tail));
            End;
         end if;
      End Internal_Convert;

      Result : constant String := Internal_Convert( Pattern );
      Parens : constant Boolean := Ada.Strings.Fixed.Index(Result, "(") in Positive;
   Begin
      Return "";
--       Return (if Parens then Result else  )
   End Convert;


   Function Convert( Pattern : Full_Pattern		 ) return String is ("");
   Function Convert( Pattern : Extended_Pattern		 ) return String is ("");
   Function Convert( Pattern : Square_Pattern		 ) return String is ("");
   Function Convert( Pattern : Cubic_Pattern		 ) return String is ("");
   Function Convert( Pattern : Power_Pattern		 ) return String is ("");

   -------------------------
   --  STRING TO PATTERN  --
   -------------------------

   --        Function Convert( Text : String ) return Half_Pattern is ("");
   --        Function Convert( Text : String ) return Three_Quarter_Pattern is ("");
   --        Function Convert( Text : String ) return Full_Pattern is ("");
   --        Function Convert( Text : String ) return Extended_Pattern is ("");
   --        Function Convert( Text : String ) return Square_Pattern is ("");
   --        Function Convert( Text : String ) return Cubic_Pattern is ("");
   --        Function Convert( Text : String ) return Power_Pattern is ("");

   --
   --     Function "+"( Pattern : Half_Pattern ) return String is
   --        Subtype Tail is Positive Range Positive'Succ(Pattern'First)..Pattern'Last;
   --     begin
   --        if Pattern'Length not in Positive then
   --           return "";
   --        else
   --           Declare
   --              Head  : Enumeration renames Pattern(Pattern'First);
   --              Sigil : constant Character := +(+Head);
   --           Begin
   --              return Sigil & String'(+Pattern(Tail));
   --           End;
   --        end if;
   --     end "+";
   --
   --



   --     Function "+"( Text : String ) return Half_Pattern is
   --        Subtype Tail is Positive Range Positive'Succ(Text'First)..Text'Last;
   --     begin
   --        if Text'Length not in Positive then
   --           return (2..1 => <>);
   --        else
   --           Declare
   --              Element : constant Enumeration:= +(+Text(Text'First));
   --           Begin
   --              return Element & (+Text(Tail));
   --           End;
   --        end if;
   --     end "+";
End Conversions;
