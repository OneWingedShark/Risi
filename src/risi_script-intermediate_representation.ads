Pragma Ada_2012;

With
Ada.Strings.Unbounded,
Ada.Containers.Indefinite_Vectors,
Risi_Script.Parameter_Stack_Package,
Risi_Script.Script,
Risi_Script.Internals,
Risi_Script.Types;

Use
Risi_Script.Internals,
Risi_Script.Types;

Private Package Risi_Script.Intermediate_Representation with Elaborate_Body is

   -- Important note: Instructions is actions and Nodeses is data!


   -- An enumeration of the instruction-mnemonics for the IR.
   Type Instruction is (
        -----------------------
        -- ARITY 0 MNEMONICS --
        -----------------------

                        -- No operation.
                        NOP,
                        -- Terminate VM.
                        TVM,
                        -- Clear the parameter stack.
                        PSC,
                        -- Delete [POP] value from the parameter stack.
                        PSD,

        -----------------------
        -- ARITY 1 MNEMONICS --
        -----------------------

                        -- Add [PUSH] value onto the parameter stack.
                        --  1: Value
                        PSA,
                        -- Peek at the Top of the parameter stack.
                        PST,
                        -- Declare Variable [using Default].
                        --  1: Variable-Node
                        DVD,

        -----------------------
        -- ARITY 2 MNEMONICS --
        -----------------------

                        -- Add two nodes.
                        ADD,
                        -- Subtract two nodes.
                        SUB,
                        -- Multiply two nodes.
                        MUL,
                        -- Divide two nodes.
                        DIV,

                        -- Move Value to Variable.
                        --  1: Value-Node
                        --  2: Variable-Node
                        MVV,
                        -- Declare Variable [with Value].
                        --  1: Value-Node
                        --  2: Variable-Node
                        DVV,
                        -- Peek at [a value on the] parameter stack.
                        --  1: Positive-Integer Valu (indicating position)
                        --  2:
                        PSP,

        -----------------------
        -- ARITY 3 MNEMONICS --
        -----------------------

                        -- Conditional jump.
                        CDJ
     );

   Subtype Arity_0 is Instruction range NOP..Instruction'Pred(PSA);
   Subtype Arity_1 is Instruction range Instruction'Succ(Arity_0'Last)..Instruction'Pred(ADD);
   Subtype Arity_2 is Instruction range Instruction'Succ(Arity_1'Last)..Instruction'Pred(CDJ);
   Subtype Arity_3 is Instruction range Instruction'Succ(Arity_2'Last)..Instruction'Last;

--     Subtype Arity_n is Instruction range NOP..NOP;

   Type Node is tagged;


   Type Node is abstract tagged null record;

   Package Node_List_Pkg is new Ada.Containers.Indefinite_Vectors(
         "="          => "=",
         Index_Type   => Positive,
         Element_Type => Node'Class
      );


   Type Variable is new Node with record
      -- Note that a scope name of "GLOBAL" is not permitted;
      -- Consequently, no subprogram can be named "GLOBAL".
     Name,
     Scope : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   Type Type_Indicator(Value_Type : Risi_Script.Types.Enumeration) is new Node
   with null record;

   Function Get_Type( Node : Type_Indicator'Class ) Return Risi_Script.Types.Enumeration is
     (Node.Value_Type);

   Type Value(Value_Type : Risi_Script.Types.Enumeration) is new Type_Indicator(Value_Type) with record
     --(Value_Type : Risi_Script.Types.Enumeration) is new Node with record
      case Value_Type is
         when RT_Integer    => Integer_Value   : Integer_Type	:= 0;
         when RT_Array      => Array_Value     : Array_Type	:= List.Empty_Vector;
         when RT_Hash       => Hash_Value      : Hash_Type	:= Hash.Empty_Map;
         when RT_String     => String_Value    : String_Type;
         when RT_Real       => Real_Value      : Real_Type	:= 0.0;
         when RT_Pointer    => Pointer_Value   : Pointer_Type;
         when RT_Reference  => Reference_Value : Reference_Type;
         when RT_Fixed      => Fixed_Value     : Fixed_Type	:= 0.0;
         when RT_Boolean    => Boolean_value   : Boolean_Type	:= True;
         when RT_Func       => Func_Value      : Func_Type;
      end case;
   end record;

   Type Expression( Operation : Instruction ) is new Node with private;


Private
   Use Type Ada.Containers.Count_Type;

   Type Expression( Operation : Instruction ) is new Node with Record
         Operands : Node_List_Pkg.Vector;
   end record
   with Type_Invariant =>
      (case Expression.Operation is
          when Arity_0 => Expression.Operands.Length = 0,
          when Arity_1 => Expression.Operands.Length = 1,
          when Arity_2 => Expression.Operands.Length = 2,
          when Arity_3 => Expression.Operands.Length = 3
      )
       and then
         (TRUE) -- Validate Operands.
   ;

End Risi_Script.Intermediate_Representation;
