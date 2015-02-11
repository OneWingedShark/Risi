Package Body Risi_Script.Types.Patterns is

   -- Found a compiler-bug preventing the use of "+" declared in Risi_Script.Types.
   -- Work-around: Duplicate the functionality.
--     Function Convert( Item : Indicator ) Return Enumeration is
--       ( Enumeration'Val(Indicator'Pos( Item )) );

   Function To_Indocators( Working: Half_Pattern ) return Indicator_String is
     (case working'Length is
         when 0 => (2..1 => <>),
         when 1 => (1 => +Working(Working'First)),
         when others => (1 => +Working(Working'First)) &
        To_Indocators(Working(1+Working'First..Working'Last))
     );


   Package Body Conversions is separate;


--     -------------------------
--     --  PATTERN TO STRING  --
--     -------------------------
--
--
--     -------------------------
--     --  STRING TO PATTERN  --
--     -------------------------
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


   ----------------
   --  MATCHING  --
   ----------------
   Generic
      Type Pattern_Type is private;
      Type String_Type  is private;
      with Function "+"( Right : String_Type ) return Pattern_Type is <>;
      with Function Index( String, Substring : Pattern_Type ) return Natural;
   Function Generic_Match( Pattern : Pattern_Type; Indicators : String_Type ) return Boolean;

   Function Generic_Match( Pattern : Pattern_Type; Indicators : String_Type ) return Boolean is
     (Index(String => Pattern, Substring => +Indicators) = 1);

   Function Match( Pattern : Half_Pattern; Indicators : Indicator_String ) return Boolean is
      Working : Indicator_String renames To_Indocators(Pattern);
   begin
      --        return Result : constant Boolean := Working = Indicators;
      return Result : Boolean := Working'Length <= Indicators'Length do
         if Result then
            Result:= Working = Indicators(Working'Range);
         end if;
      end return;
   end Match;


   --------------
   --  CREATE  --
   --------------

   Function Create( Input : Variable_List ) return Half_Pattern is
      Use Risi_Script.Types;
   begin
      Return Result : Half_Pattern( Input'Range ) do
         for Index in Input'Range loop
            Result(Index):= Get_Enumeration(Input(Index));
         end loop;
      end return;
   end Create;

End Risi_Script.Types.Patterns;
