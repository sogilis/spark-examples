package Failsafe with SPARK_Mode,
  Abstract_State => Failsafe_State,
  Initializes => Failsafe_State
is
   pragma Unevaluated_Use_Of_Old(Allow);

   type Battery_Level_Type is new Float;
   Battery_Threshold : constant Battery_Level_Type := 0.20;
   Failsafe_Cycles : constant Positive := 50;

   procedure Update_Time_Below_Threshold (Battery_Level : in Battery_Level_Type)
     with Post => Time_Below_Threshold = (if Battery_Level < Battery_Threshold
                  then (if Time_Below_Threshold'Old < Failsafe_Cycles
                        then Time_Below_Threshold'Old + 1
                        else Time_Below_Threshold'Old)
                  else 0);

   function Is_Raised return Boolean with
     Post => Is_Raised'Result = (Time_Below_Threshold >= Failsafe_Cycles);

   function Time_Below_Threshold return Natural with Ghost;

end Failsafe;
