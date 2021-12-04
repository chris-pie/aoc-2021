with Ada.Strings;           use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Vectors;
with Ada.Integer_text_IO;

procedure Main is

   package Vector_Pkg is new Vectors(Index_Type   => Natural,
                                     Element_Type => Unbounded_String);
   package Vectors_Sorting is new Vector_Pkg.Generic_Sorting;

   use     Vector_Pkg;
   use     Vectors_Sorting;

   InputVector, OxygenVector, CO2Vector : Vector;
   F         : File_Type;
   File_Name : constant String := "Day 3.txt";
   String_Length: Natural;
   Gamma : Natural := 0;
   Epsilon : Natural := 0;
   Midway_Char : String := " ";
   j : Natural := 0;
   OxyRating : Natural;
   CO2Rating : Natural;

begin
   Open(F, In_File, File_Name);
   while not End_Of_File(F) loop
      InputVector.Append(New_Item => To_Unbounded_String(Get_Line(F)));
   end loop;
   Close(F);
   Vectors_Sorting.Sort(Container => InputVector);
   String_Length := Length(InputVector.Element(Index => 0));
   declare
      Counter_Array : array (1 ..  String_Length) of Integer := (others => 0);

   begin
      for E of InputVector loop
         for i in 1 .. String_Length loop
            Counter_Array(i) := Counter_Array(i) + Integer'Value(To_String(E)(i..i));
         end loop;
      end loop;
      for i in 1 .. String_Length loop
         if Counter_Array(i) > Natural(InputVector.Length)/2 then
            Gamma := Gamma + 2**(String_Length-i);
         else
            Epsilon := Epsilon + 2**(String_Length-i);
         end if;
      end loop;
      Put_Line(Natural'Image(Gamma * Epsilon));
      OxygenVector := InputVector.Copy;
      CO2Vector := InputVector.Copy;
      OxyLoop:
      for i in 1 .. String_Length loop
         Midway_Char := To_String(OxygenVector.Element(Natural((OxygenVector.Length) / 2)))(i..i);
         j := 0;
         while j < Natural(OxygenVector.Length) loop
            if Midway_Char = To_String(OxygenVector.Element(j))(i..i) then
               j := j + 1;
            else
               OxygenVector.Delete(Index => j);
            end if;
         end loop;
         if Natural(OxygenVector.Length) = 1 then
            OxyRating := Natural'Value("2#" & To_String(OxygenVector.First_Element) & '#');
            exit OxyLoop;
         end if;
      end loop OxyLoop;

      CO2Loop:
      for i in 1 .. String_Length loop
         Midway_Char := To_String(CO2Vector.Element(Natural((CO2Vector.Length) / 2)))(i..i);
         j := 0;
         while j < Natural(CO2Vector.Length) loop
            if Midway_Char /= To_String(CO2Vector.Element(j))(i..i) then
               j := j + 1;
            else
               CO2Vector.Delete(Index => j);
            end if;
         end loop;
         if Natural(CO2Vector.Length) = 1 then
            CO2Rating := Natural'Value("2#" & To_String(CO2Vector.First_Element) & '#');
            exit CO2Loop;
         end if;
      end loop CO2Loop;
      Put_Line(Natural'Image(OxyRating * CO2Rating));
   end;
end Main;
