With
Risi_Script.Types;

Use
Risi_Script.Types;


package body Risi_Script.Internals is
   Default_Hash_Key : Constant String := "0";

   Function "+"( Right : Enumeration ) return Character is
     ( Indicator'Image( Indicator'Val( Enumeration'Pos(Right) ) )(2) );

   -- Indicator and Character are not interchangable or automatticcally convertable.
   Function "+"( Right : Indicator ) return Character is
     (case Right is
      when '!' => '!',
      when '@' => '@',
      when '#' => '#',
      when '$' => '$',
      when '%' => '%',
      when '^' => '^',
      when '&' => '&',
      when '`' => '`',
      when '?' => '?',
      when 'ß' => 'ß'
     );
   Function "+"( Right : Character ) return Indicator is
     (case Right is
      when '!' => '!',
      when '@' => '@',
      when '#' => '#',
      when '$' => '$',
      when '%' => '%',
      when '^' => '^',
      when '&' => '&',
      when '`' => '`',
      when '?' => '?',
      when 'ß' => 'ß',
      when others => raise Constraint_Error with "Invalid Sigil Character."
     );

   -- Found a compiler-bug preventing the use of "+" declared in Risi_Script.Types.
   -- Work-around: Duplicate the functionality.
   Function Convert( Item : Indicator ) Return Enumeration is
     ( Enumeration'Val(Indicator'Pos( Item )) );


   -------------------------
   --  PATTERN TO STRING  --
   -------------------------

   Function "+"( Pattern : Half_Pattern ) return String is
      Subtype Tail is Positive Range Positive'Succ(Pattern'First)..Pattern'Last;
   begin
      if Pattern'Length not in Positive then
         return "";
      else
         Declare
            Head  : Enumeration renames Pattern(Pattern'First);
            Sigil : constant Character := +Head;
         Begin
            return Sigil & String'(+Pattern(Tail));
         End;
      end if;
   end "+";


   -------------------------
   --  STRING TO PATTERN  --
   -------------------------

   Function "+"( Text : String ) return Half_Pattern is
      Subtype Tail is Positive Range Positive'Succ(Text'First)..Text'Last;
   begin
      if Text'Length not in Positive then
         return (2..1 => <>);
      else
         Declare
            Element : constant Enumeration:= Convert(+Text(Text'First));
         Begin
            return Element & (+Text(Tail));
         End;
      end if;
   end "+";

   ----------------------
   --  GENERIC BODIES  --
   ----------------------

   Function To_Array(Value : X) return Risi_Script.Internals.List.Vector is
   Begin
      return Result : Risi_Script.Internals.List.Vector do
         Result.Append( Create(Value) );
      end return;
   End To_Array;

   Function To_Hash( Value : X ) return Hash_Type is
   Begin
      return Result : Hash_Type do
         Result.Include(
                        Key      => Default_Hash_Key,
                        New_Item => Create(Value)
                       );
      end return;
   End To_Hash;


end Risi_Script.Internals;
