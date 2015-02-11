Package Body Risi_Script.Types.Internals is

   Default_Hash_Key : Constant String := "0";

   ----------------------
   --  GENERIC BODIES  --
   ----------------------

   Function To_Array(Value : X) return Risi_Script.Types.Internals.List.Vector is
      Package List renames Risi_Script.Types.Internals.List;
   Begin
      return Result : List.Vector do
         Internals.List.Append(
                               Container => Result,
                               New_Item  => Create(Value)
                              );
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

End Risi_Script.Types.Internals;
