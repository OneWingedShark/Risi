Package Body Risi_Script.Stacks is

   Function  Pop ( Stack : in out Parameter_Stack ) return Representation is
   begin
      Return Result : Representation:= Stack(1) do
         Stack.Delete_First;
      end return;
   end Pop;

   Procedure Push( Stack : in out Parameter_Stack;
                   Item  : Representation
                 ) is
   begin
      Stack.Prepend( Item );
   end Push;

   Function  Peek( Stack : Parameter_Stack;
                   Item  : Positive
                  ) return Representation is
   begin
      Return Stack(Item);
   end Peek;

End Risi_Script.Stacks;
