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

with SDL.Error;

package body SDL.Audio.Conversions is

   procedure Build_CVT (CVT             : in out Audio_CVT;
                        Source_Format   : in     Audio_Format;
                        Source_Channels : in     Channel_Count;
                        Source_Rate     : in     Sample_Rate;
                        Dest_Format     : in     Audio_Format;
                        Dest_Channels   : in     Channel_Count;
                        Dest_Rate       : in     Sample_Rate;
                        Need_Conversion :    out Boolean)
   is
      function SDL_Build_Audio_CVT
        (CVT             : in out Audio_CVT;
         Source_Format   : in     Audio_Format;
         Source_Channels : in     Natural;
         Source_Rate     : in     Integer;
         Dest_Format     : in     Audio_Format;
         Dest_Channels   : in     Natural;
         Dest_Rate       : in     Integer)
        return C.int with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_BuildAudioCVT";

      Result : constant C.int
        := SDL_Build_Audio_CVT (CVT,
                                Source_Format,
                                Natural (Source_Channels),
                                Integer (Source_Rate),
                                Dest_Format,
                                Natural (Dest_Channels),
                                Integer (Dest_Rate));
   begin
      if Result = -1 then
         raise Audio_Error with SDL.Error.Get;
      end if;
      Need_Conversion := (if Result = 0 then False else True);
   end Build_CVT;

   procedure Convert (CVT : in Audio_CVT)
   is
      function SDL_Convert_Audio (CVT : in Audio_CVT)
                                 return C.int with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_ConvertAudio";

      Result : constant C.int := SDL_Convert_Audio (CVT);
   begin
      if Result /= SDL.Success then
         raise Audio_Error with SDL.Error.Get;
      end if;
   end Convert;


   procedure Set_Buffer (CVT    : in out SDL.Audio.Conversions.Audio_CVT;
                         Buffer : in     Buffer_Type)
   is
   begin
      CVT.Audio_Buf := Buffer.Base;
   end Set_Buffer;

end SDL.Audio.Conversions;
