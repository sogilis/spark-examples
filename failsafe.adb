package body Failsafe with SPARK_Mode,
  Refined_State => (Failsafe_State => Counter)
is
   Counter : Natural range 0 .. Failsafe_Cycles := 0;

   package body Model is
      function Is_Valid return Boolean is
         (Counter = Time_Below_Threshold);
   end Model;

   procedure Update (Battery_Level : in Battery_Level_Type) is
   begin
      if Battery_Level < Battery_Threshold then
         Counter := Natural'Min(Counter + 1, Failsafe_Cycles);
         Time_Line(Current_Time) := True;
      else
         Counter := 0;
         Time_Line(Current_Time) := False;
      end if;

      Current_Time := Current_Time + 1;
   end Update;

   function Is_Raised return Boolean is
     (Counter >= Failsafe_Cycles);

   function Time_Below_Threshold return Natural is (Counter);

end Failsafe;
