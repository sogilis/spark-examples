package body Failsafe with SPARK_Mode,
  Refined_State => (Failsafe_State => Counter)
is
   Counter : Natural range 0 .. Failsafe_Cycles := 0;

   procedure Update_Time_Below_Threshold (Battery_Level : in Battery_Level_Type) is
   begin
      if Battery_Level < Battery_Threshold then
         Counter := Natural'Min(Counter + 1, Failsafe_Cycles);
      else
         Counter := 0;
      end if;
   end Update_Time_Below_Threshold;

   function Is_Raised return Boolean is
     (Counter >= Failsafe_Cycles);

   function Time_Below_Threshold return Natural is (Counter);

end Failsafe;
