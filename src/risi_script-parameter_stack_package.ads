With
Risi_Script.Types,
Ada.Containers.Indefinite_Vectors;

Package Risi_Script.Parameter_Stack_Package is
  new Ada.Containers.Indefinite_Vectors(
      "="          => Risi_Script.Types."=",
      Index_Type   => positive,
      Element_Type => Risi_Script.Types.Representation
  );
