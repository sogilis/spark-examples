package Failsafe with SPARK_Mode,
  Abstract_State => Failsafe_State,
  Initializes => Failsafe_State
is
   pragma Unevaluated_Use_Of_Old(Allow);

   type Battery_Level_Type is new Float;
   Battery_Threshold : constant Battery_Level_Type := 0.20;
   Failsafe_Cycles : constant Positive := 50;

   package Model with Ghost is

      type Time_Slot is mod Failsafe_Cycles;
      subtype Time_Slot_Length is Natural range 0 .. Failsafe_Cycles;
      type Time_Array is array (Time_Slot) of Boolean;

      Time_Line : Time_Array := (others => False);
      Current_Time : Time_Slot := Time_Slot'First;

      function Is_Valid return Boolean;

   end Model;

   use Model;

   procedure Update (Battery_Level : in Battery_Level_Type) with
   --     Global => (In_Out => Failsafe_State),
     Pre => Is_Valid,
     Post => Time_Line(Current_Time'Old) = (Battery_Level < Battery_Threshold)
     and Current_Time = Current_Time'Old + 1
     and Is_Valid;

--     Post => (if Time_Below_Threshold >= Failsafe_Cycles then Is_Raised);
--     Post => Time_Below_Threshold = (if Battery_Level < Battery_Threshold
--              then (if Time_Below_Threshold'Old < Failsafe_Cycles
--                    then Time_Below_Threshold'Old + 1
--                    else Time_Below_Threshold'Old)
--              else 0);

   function Is_Raised return Boolean with
     Post => Is_Raised'Result = (Time_Below_Threshold > Failsafe_Cycles);

   function Time_Below_Threshold return Natural with
     Ghost,
     Post =>
       -- Battery_Level was low for Time_Below_Threshold'Result slots...
       (for all S in Current_Time - Time_Slot(Time_Below_Threshold'Result - 1) .. Current_Time
          => Time_Line(S) = True)
       -- and not longer than that.
       and (Time_Below_Threshold'Result = Time_Line'Length
          or else Time_Line(Current_Time - Time_Slot(Time_Below_Threshold'Result)) = False);

end Failsafe;
