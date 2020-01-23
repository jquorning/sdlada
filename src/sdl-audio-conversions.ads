--------------------------------------------------------------------------------------------------------------------
--  Copyright (c) 2020 Jesper Quorning
--
--  This software is provided 'as-is', without any express or implied
--  warranty. In no event will the authors be held liable for any damages
--  arising from the use of this software.
--
--  Permission is granted to anyone to use this software for any purpose,
--  including commercial applications, and to alter it and redistribute it
--  freely, subject to the following restrictions:
--
--     1. The origin of this software must not be misrepresented; you must not
--     claim that you wrote the original software. If you use this software
--     in a product, an acknowledgment in the product documentation would be
--     appreciated but is not required.
--
--     2. Altered source versions must be plainly marked as such, and must not be
--     misrepresented as being the original software.
--
--     3. This notice may not be removed or altered from any source
--     distribution.
--------------------------------------------------------------------------------------------------------------------
--  SDL.Audio.Conversions
--------------------------------------------------------------------------------------------------------------------

package SDL.Audio.Conversions is

   -----------------
   --  Audio_CVT  --
   -----------------

   type Audio_CVT;
   type Audio_CVT_Access is access Audio_CVT;
   type Audio_Filter_Access is
     access procedure (CVT    : in Audio_CVT_Access;
                       Format : in Audio_Format);
   type Filter_Array is array (1 .. 10) of Audio_Filter_Access;

   --
   --  Audio_CVT
   --  This is a packed data structure.
   --
   pragma Warnings (Off, "pragma Pack*");
   type Audio_CVT is
      record                             -- 64 Sum 32 Sum
         Needed          : Integer;      --  8   8  4  4
         Source_Format   : Audio_Format; --  2  10  2  6
         Dest_Format     : Audio_Format; --  2  12  2  8
         Rate_Increment  : Long_Float;   --  8  20  8 16
         Audio_Buf       : Buffer_Base;  --  8  28  4 20
         Audio_Len       : Byte_Count;   --  4  32  4 24
         Length_CVT      : Byte_Count;   --  4  36  4 28
         Length_Multiply : Integer;      --  8  44  4 32
         Length_Ratio    : Long_Float;   --  8  52  8 40
         Filters         : Filter_Array; -- 80 132 40 80
         Filter_Index    : Integer;      --  8 140  4 84
      end record with Pack, Size => 8 * (if True then 128 else 84);
   pragma Warnings (On, "pragma Pack*");

   ------------------
   --  Conversion  --
   ------------------

   procedure Build_CVT (CVT             : in out Audio_CVT;
                        Source_Format   : in     Audio_Format;
                        Source_Channels : in     Channel_Count;
                        Source_Rate     : in     Sample_Rate;
                        Dest_Format     : in     Audio_Format;
                        Dest_Channels   : in     Channel_Count;
                        Dest_Rate       : in     Sample_Rate;
                        Need_Conversion :    out Boolean);

   procedure Convert (CVT : in Audio_CVT);

   ---------------
   --  Helpers  --
   ---------------

   procedure Set_Buffer (CVT    : in out SDL.Audio.Conversions.Audio_CVT;
                         Buffer : in     Buffer_Type);

end SDL.Audio.Conversions;
