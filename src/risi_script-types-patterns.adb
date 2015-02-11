Package Body Risi_Script.Types.Patterns is

   Function To_Indicators( Working: Half_Pattern ) return Indicator_String is
   begin
      Return Result : Indicator_String(Working'Range) do
         for Index in Result'Range loop
            Result(Index) := +Working(Index);
         end loop;
      End return;
   end To_Indicators;


   Package Body Conversions is separate;

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
      Working : Indicator_String renames To_Indicators(Pattern);
   begin
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
