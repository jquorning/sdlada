--
--
--

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
