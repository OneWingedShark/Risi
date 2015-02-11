Pragma Ada_2012;
Pragma Wide_Character_Encoding( UTF8 );

with
Ada.Containers.Indefinite_Vectors;

Package Risi_Script.Types.Identifier.Scope_Package is
  new Ada.Containers.Indefinite_Vectors(
        Index_Type   => Positive,
        Element_Type => Identifier,
        "="          => "="
    );
