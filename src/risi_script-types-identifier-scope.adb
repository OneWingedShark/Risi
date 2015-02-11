With
Ada.Strings.Fixed;

Package Body Risi_Script.Types.Identifier.Scope is

   Function Image( Input : Scope ) return String is
      Function Img( Input : in out Scope ) return String is
      begin
         case Input.Length is
         when 0 => return "";
         when 1 => return Input.First_Element;
         When others =>
            declare
               Result : constant String:= '.' & Input.Last_Element;
            begin
               Input.Delete_Last;
               return Img(Input) & Result;
            end;
         end case;
      end Img;
      Working : Scope:= Input;
   begin
      Return Img(Working);
   end Image;

   Function Value( Input : String ) return Scope is
      Use Ada.Strings.Fixed, Ada.Strings;
      Start,
      Stop      : Natural:= 0;
   begin
      Return Result : Scope := Global do
         Start:= Input'First;
         loop
            Stop:=
              Index(Source  => Input,
                    Pattern => ".",
                    From   => Start
                   );
            Stop := (if Stop not in Positive then Input'Last
                     else Positive'Pred(Stop));

            Result.Append( Input(Start..Stop) );
            Start:= Positive'Succ( Positive'Succ( Stop ) );

            Exit when Start not in Input'Range;
         end loop;
      end return;
   end Value;


End Risi_Script.Types.Identifier.Scope;
