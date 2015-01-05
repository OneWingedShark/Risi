Pragma Ada_2012;

With
Risi_Script.Types;

Package Risi_Script.Protocols is

   Type ASCII_Transmission is task interface;

   Function Martial  ( Process   : ASCII_Transmission;
                       Variables : Risi_Script.Types.Array_Package.Vector )
                       return String is abstract;
   Function Unmartial( Process   : ASCII_Transmission;
                       Text      : String )
                       return Risi_Script.Types.Array_Package.Vector is abstract;


End Risi_Script.Protocols;
