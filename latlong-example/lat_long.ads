with Ada.Numerics, Ada.Numerics.Elementary_Functions;
use Ada.Numerics, Ada.Numerics.Elementary_Functions;

package Lat_Long with SPARK_Mode is
   R : constant Float := 6_367_444.7;
   Conv_Deg_To_Rad : constant Float := Pi / 180.0;

   subtype Latitude is Float range - 90.0 .. 90.0;
   subtype Longitude is Float range Float'Succ(- 180.0) .. 180.0;

   type Coordinates is record
      Lat : Latitude;
      Long : Longitude;
   end record;

   function Distance(Source, Destination : Coordinates) return Float with
     Pre => Cos(Source.Lat) /= 0.0,
     Post => Distance'Result = Sqrt(
               Delta_Lat_In_Meters(Source, Destination) *  Delta_Lat_In_Meters(Source, Destination) +
               Delta_Long_In_Meters(Source, Destination) * Delta_Long_In_Meters(Source, Destination));

   function Delta_Lat_In_Meters(Source, Destination : Coordinates) return Float
   is ((Destination.Lat - Source.Lat) * R * Conv_Deg_To_Rad)
   with Ghost,
     Post => abs(Delta_Lat_In_Meters'Result) <= (Pi * R);

   function Delta_Long_In_Meters(Source, Destination : Coordinates) return Float
   is ((Destination.Long - Source.Long) * R / Cos(Source.Lat))
   with Ghost,
     Post => abs(Delta_Long_In_Meters'Result) <= (2.0 * Pi * R);

end Lat_Long;
