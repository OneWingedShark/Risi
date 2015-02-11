Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

With
Ada.Strings.UTF_Encoding.Conversions,
Ada.strings.UTF_Encoding.Wide_Wide_Strings,
EPL.Types;

Use
EPL.Types;

-- Edward Parse Library.
--
-- ©2015 E. Fish; All Rights Reserved.
Package EPL.Brackets is
   Function Bracket( Data : UTF_08; Style : Types.Bracket ) return UTF_08;
   Function Bracket( Data : UTF_16; Style : Types.Bracket ) return UTF_16;
   Function Bracket( Data : UTF_32; Style : Types.Bracket ) return UTF_32;
Private
   Item : constant Array( Types.Bracket, Side ) of Wide_Wide_Character :=
     (
       Types.Parentheses	=> ('(',')'),
       Types.Brackets		=> ('[',']'),
       Types.Braces		=> ('{','}'),
       Types.Chevrons		=> ('⟨','⟩'),
       Types.Angle		=> ('<','>'),
       Types.Corner		=> ('｢','｣')
      );

   Function Left  return Side renames Ada.Strings.Left;
   Function Right return Side renames Ada.Strings.Right;

   Use Ada.Strings.UTF_Encoding.Conversions, Ada.Strings.UTF_Encoding;

   Function Bracket( Data : UTF_08; Style : Types.Bracket ) return UTF_08 is
     ( Convert( Input_Scheme => UTF_8, Item => Bracket(Data,Style)) );

   Function Bracket( Data : UTF_16; Style : Types.Bracket ) return UTF_16 is
     ("");

   Function Bracket( Data : UTF_32; Style : Types.Bracket ) return UTF_32 is
      ( Item(Style, Left) & Data & Item(Style, Right) );


End EPL.Brackets;
