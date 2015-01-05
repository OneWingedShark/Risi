With
Risi_Script.Internals;

Private With
Risi_Script.Types;

Private Package Risi_Script.Types.Creators is

   Function Create ( Item : Risi_Script.Internals.Integer_Type	) return Representation;
--     Function Create ( Item : Risi_Script.Internals.Array_Type	) return Representation;
--     Function Create ( Item : Risi_Script.Internals.Hash_Type	) return Representation;
--     Function Create ( Item : Risi_Script.Internals.String_Type	) return Representation;
   Function Create ( Item : Risi_Script.Internals.Real_Type	) return Representation;
   Function Create ( Item : Risi_Script.Internals.Pointer_Type	) return Representation;
--     Function Create ( Item : Risi_Script.Internals.Reference_Type) return Representation;
   Function Create ( Item : Risi_Script.Internals.Fixed_Type	) return Representation;
   Function Create ( Item : Risi_Script.Internals.Boolean_Type	) return Representation;
   Function Create ( Item : Risi_Script.Internals.Func_Type	) return Representation;

Private
   Function Create ( Item : Risi_Script.Internals.Integer_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Risi_Script.Internals.Real_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Risi_Script.Internals.Pointer_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Risi_Script.Internals.Fixed_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Risi_Script.Internals.Boolean_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Risi_Script.Internals.Func_Type	) return Representation
     renames Internal_Create;
End Risi_Script.Types.Creators;
