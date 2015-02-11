With
Risi_Script.Types.Internals;

Private With
Risi_Script.Types.Implementation;

Private Package Risi_Script.Types.Implementation.Creators is
   Package Internal renames Risi_Script.Types.Internals;

   Function Create ( Item : Internal.Integer_Type	) return Representation;
--     Function Create ( Item : Internal.Array_Type	) return Representation;
--     Function Create ( Item : Internal.Hash_Type	) return Representation;
--     Function Create ( Item : Internal.String_Type	) return Representation;
   Function Create ( Item : Internal.Real_Type	) return Representation;
   Function Create ( Item : Internal.Pointer_Type	) return Representation;
--     Function Create ( Item : Internal.Reference_Type) return Representation;
   Function Create ( Item : Internal.Fixed_Type	) return Representation;
   Function Create ( Item : Internal.Boolean_Type	) return Representation;
   Function Create ( Item : Internal.Func_Type	) return Representation;

Private
   Function Create ( Item : Internal.Integer_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Internal.Real_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Internal.Pointer_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Internal.Fixed_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Internal.Boolean_Type	) return Representation
     renames Internal_Create;
   Function Create ( Item : Internal.Func_Type	) return Representation
     renames Internal_Create;
End Risi_Script.Types.Implementation.Creators;
