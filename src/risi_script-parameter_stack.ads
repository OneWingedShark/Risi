With
Risi_Script.Interfaces,
Ada.Containers.Indefinite_Vectors;

Package Risi_Script.Parameter_Stack is

   Package Interfaces renames Risi_Script.Types.Interfaces;

   Package Implementation is new Ada.Containers.Indefinite_Vectors(
      "="          => Risi_Script.Types."=",
      Index_Type   => positive,
      Element_Type => Risi_Script.Types.Representation
   );


   Type Vector is new Implementation.Vector and Interfaces.Stack_Interface
   with null record;

End Risi_Script.Parameter_Stack;
