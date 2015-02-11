Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

with
Risi_Script.Types.Implementation,
Ada.Characters.Handling;

Package Risi_Script.Types.Patterns is
   Use  Risi_Script.Types.Implementation;

   ---------------------
   --  PATTERN TYPES  --
   ---------------------

   --#TODO:	Implement the pattern-types; they should have to- and from-
   --#		string conversion functions.

   Type Half_Pattern(<>)          is private;
   Type Three_Quarter_Pattern(<>) is private;
   Type Full_Pattern(<>)          is private;
   Type Extended_Pattern(<>)      is private;

   Type Square_Pattern(<>) is private;
   Type Cubic_Pattern(<>)  is private;
   Type Power_Pattern(<>)  is private;

   -- Pattern to String conversion.
   Function "+"( Pattern : Half_Pattern		 ) return String;
   Function "+"( Pattern : Three_Quarter_Pattern ) return String;
   Function "+"( Pattern : Full_Pattern		 ) return String;
   Function "+"( Pattern : Extended_Pattern	 ) return String;
   Function "+"( Pattern : Square_Pattern	 ) return String;
   Function "+"( Pattern : Cubic_Pattern	 ) return String;
   Function "+"( Pattern : Power_Pattern	 ) return String;

   -- String to Pattern conversion.
--     Function "+"( Text : String ) return Half_Pattern;
--     Function "+"( Text : String ) return Three_Quarter_Pattern;
--     Function "+"( Text : String ) return Full_Pattern;
--     Function "+"( Text : String ) return Extended_Pattern;
--     Function "+"( Text : String ) return Square_Pattern;
--     Function "+"( Text : String ) return Cubic_Pattern;
--     Function "+"( Text : String ) return Power_Pattern;


   Function Match( Pattern : Half_Pattern; Indicators : Indicator_String ) return Boolean;


   Function Create( Input : Variable_List ) return Half_Pattern;

   ------------------
   --  ATP Packet  --
   ------------------

--     Type ATP_Packet is private;
--     function Create( Input : Variable_List ) return ATP_Packet;

Private

   ----------------------------------
   --  ELEMENTS FOR PATTERN TYPES  --
   ----------------------------------
   Use Risi_Script.Types, Risi_Script.Types.Implementation;

   Type Enumeration_Length(Enum : Enumeration) is record
      case Enum is
         when RT_String | RT_Array | RT_Hash => Length : Natural;
         when others => Null;
      end case;
   end record;

   Type Pattern_Element is ( Half, Three_Quarter, Full );
   Subtype Extended_Pattern_Element is Pattern_Element Range Half..Full;

   type Varying_Element( Element : Extended_Pattern_Element ) is record
      case Element is
         when Half          => Half_Value : Enumeration;
         when Three_Quarter => TQ_Value   : not null access Enumeration_Length;
         when Full          => Full_Value : Representation;
      end case;
   end record;




   Type Half_Pattern          is array (Positive range <>) of Enumeration;
   Type Three_Quarter_Pattern is array (Positive range <>) of not null access Enumeration_Length;
   Type Full_Pattern          is array (Positive range <>) of Representation;
   Type Extended_Pattern      is array (Positive range <>) of not null access Varying_Element;

   Type Square_Pattern is null record;
   Type Cubic_Pattern  is null record;
   Type Power_Pattern  is null record;


--     Type ATP_Packet is record
--        null;
--     end record;
--     function Create( Input : Variable_List ) return ATP_Packet is (null record);

   Package Conversions is
      -- Pattern to String conversion.
      Function Convert( Pattern : Half_Pattern		 ) return String;
      Function Convert( Pattern : Three_Quarter_Pattern	 ) return String;
      Function Convert( Pattern : Full_Pattern		 ) return String;
      Function Convert( Pattern : Extended_Pattern	 ) return String;
      Function Convert( Pattern : Square_Pattern	 ) return String;
      Function Convert( Pattern : Cubic_Pattern		 ) return String;
      Function Convert( Pattern : Power_Pattern		 ) return String;

      -- String to Pattern conversion.
--        Function Convert( Text : String ) return Half_Pattern;
--        Function Convert( Text : String ) return Three_Quarter_Pattern;
--        Function Convert( Text : String ) return Full_Pattern;
--        Function Convert( Text : String ) return Extended_Pattern;
--        Function Convert( Text : String ) return Square_Pattern;
--        Function Convert( Text : String ) return Cubic_Pattern;
--        Function Convert( Text : String ) return Power_Pattern;
   end Conversions;

   Use Conversions;
   -- Pattern to String conversion.
   Function "+"( Pattern : Half_Pattern		 ) return String renames Convert;
   Function "+"( Pattern : Three_Quarter_Pattern ) return String renames Convert;
   Function "+"( Pattern : Full_Pattern		 ) return String renames Convert;
   Function "+"( Pattern : Extended_Pattern	 ) return String renames Convert;
   Function "+"( Pattern : Square_Pattern	 ) return String renames Convert;
   Function "+"( Pattern : Cubic_Pattern	 ) return String renames Convert;
   Function "+"( Pattern : Power_Pattern	 ) return String renames Convert;

   -- String to Pattern conversion.
--     Function "+"( Text : String ) return Half_Pattern renames Convert;
--     Function "+"( Text : String ) return Three_Quarter_Pattern renames Convert;
--     Function "+"( Text : String ) return Full_Pattern renames Convert;
--     Function "+"( Text : String ) return Extended_Pattern renames Convert;
--     Function "+"( Text : String ) return Square_Pattern renames Convert;
--     Function "+"( Text : String ) return Cubic_Pattern renames Convert;
--     Function "+"( Text : String ) return Power_Pattern renames Convert;

End Risi_Script.Types.Patterns;
