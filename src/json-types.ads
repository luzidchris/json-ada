--  Copyright (c) 2016 onox <denkpadje@gmail.com>
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.

with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Hash;
with Ada.Strings.Unbounded;

package JSON.Types is
   pragma Preelaborate;

   package SU renames Ada.Strings.Unbounded;

   type JSON_Value is interface;

   type JSON_String_Value is new JSON_Value with private;

   function Value (Object : JSON_String_Value) return String
     with Inline;

   type JSON_Integer_Value is new JSON_Value with private;

   function Value (Object : JSON_Integer_Value) return Long_Integer
     with Inline;

   type JSON_Float_Value is new JSON_Value with private;

   function Value (Object : JSON_Float_Value) return Long_Float
     with Inline;

   type JSON_Boolean_Value is new JSON_Value with private;

   function Value (Object : JSON_Boolean_Value) return Boolean
     with Inline;

   type JSON_Null_Value is new JSON_Value with private;

   -----------------------------------------------------------------------------
   --                               JSON Array                                --
   -----------------------------------------------------------------------------

   package JSON_Vectors is new Ada.Containers.Indefinite_Vectors (Positive, JSON_Value'Class);

   type JSON_Array_Value is new JSON_Value with private
     with Default_Iterator  => Iterate,
          Iterator_Element  => JSON_Value'Class,
          Constant_Indexing => Constant_Reference;

   procedure Append (Object : in out JSON_Array_Value; Value : JSON_Value'Class);

   function Length (Object : JSON_Array_Value) return Natural;

   function Get (Object : JSON_Array_Value; Index : Positive) return JSON_String_Value'Class;
   function Get (Object : JSON_Array_Value; Index : Positive) return JSON_Integer_Value'Class;
   function Get (Object : JSON_Array_Value; Index : Positive) return JSON_Float_Value'Class;
   function Get (Object : JSON_Array_Value; Index : Positive) return JSON_Boolean_Value'Class;
   function Get (Object : JSON_Array_Value; Index : Positive) return JSON_Null_Value'Class;
   function Get (Object : JSON_Array_Value; Index : Positive) return JSON_Array_Value'Class;

   function Constant_Reference (Object : JSON_Array_Value; Position : JSON_Vectors.Cursor)
     return JSON_Vectors.Constant_Reference_Type;

   function Iterate (Object : JSON_Array_Value)
     return JSON_Vectors.Vector_Iterator_Interfaces.Reversible_Iterator'Class;

   -----------------------------------------------------------------------------
   --                               JSON Object                               --
   -----------------------------------------------------------------------------

   type JSON_Object_Value is new JSON_Value with private;

   procedure Insert (Object : in out JSON_Object_Value;
                     Key    : JSON_String_Value'Class;
                     Value  : JSON_Value'Class);

   function Length (Object : JSON_Object_Value) return Natural;

   function Get (Object : JSON_Object_Value; Key : String) return JSON_String_Value'Class;
   function Get (Object : JSON_Object_Value; Key : String) return JSON_Integer_Value'Class;
   function Get (Object : JSON_Object_Value; Key : String) return JSON_Float_Value'Class;
   function Get (Object : JSON_Object_Value; Key : String) return JSON_Boolean_Value'Class;
   function Get (Object : JSON_Object_Value; Key : String) return JSON_Null_Value'Class;
   function Get (Object : JSON_Object_Value; Key : String) return JSON_Array_Value'Class;
   function Get (Object : JSON_Object_Value; Key : String) return JSON_Object_Value'Class;

   function Get (Object : JSON_Array_Value; Index : Positive) return JSON_Object_Value'Class;

   -----------------------------------------------------------------------------
   --                              Constructors                               --
   -----------------------------------------------------------------------------

   function Create_String (Value : SU.Unbounded_String) return JSON_String_Value'Class;

   function Create_Integer (Value : Long_Integer) return JSON_Integer_Value'Class;

   function Create_Float (Value : Long_Float) return JSON_Float_Value'Class;

   function Create_Boolean (Value : Boolean) return JSON_Boolean_Value'Class;

   function Create_Null return JSON_Null_Value'Class;

   function Create_Array return JSON_Array_Value;

   function Create_Object return JSON_Object_Value;

private

   package JSON_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => JSON_Value'Class,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   type JSON_String_Value is new JSON_Value with record
      String_Value : SU.Unbounded_String;
   end record;

   type JSON_Integer_Value is new JSON_Value with record
      Integer_Value : Long_Integer;
   end record;

   type JSON_Float_Value is new JSON_Value with record
      Float_Value : Long_Float;
   end record;

   type JSON_Boolean_Value is new JSON_Value with record
      Boolean_Value : Boolean;
   end record;

   type JSON_Null_Value is new JSON_Value with null record;

   type JSON_Array_Value is new JSON_Value with record
      Vector : JSON_Vectors.Vector;
   end record;

   type JSON_Object_Value is new JSON_Value with record
      Map : JSON_Maps.Map;
   end record;

end JSON.Types;
