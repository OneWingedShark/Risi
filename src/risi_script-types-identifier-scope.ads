Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

with
Risi_Script.Types.Identifier.Scope_Package;

Package Risi_Script.Types.Identifier.Scope is
   use Risi_Script.Types.Identifier.Scope_Package;

   Type Scope is new Vector with null record;

   Function "+"( Right : Scope ) Return Vector;
   Function "+"( Right : Vector ) Return Scope;


   Function Image( Input : Scope  ) return String;
   Function Value( Input : String ) return Scope
   with Pre => Input(Input'First) /= '.' and Input(Input'Last) /= '.';

   -----------------
   --  Constants  --
   -----------------

   Global : Constant Scope;

Private

   Function "+"( Right : Scope ) Return Vector is
     ( Vector(Right) );
   Function "+"( Right : Vector ) Return Scope is
     ( Right with null record );

   Global : Constant Scope:= +Empty_Vector;

End Risi_Script.Types.Identifier.Scope;
