--
--  SDL.Audio toolbox
--

with SDL.Audio.Frames;
with SDL.Audio.Conversions;

package Toolbox is
   use SDL.Audio;

   type Sample_Type is range -2**15 .. 2**15 - 1;

   package Stereo_Buffers is
      new SDL.Audio.Frames.Buffer_Overlays (Sample_Type  => Sample_Type,
                                            Frame_Config => Frames.Config_Stereo);

   procedure Clear (Buffer : in out Buffer_Type);
   --  Clear Buffer.

   procedure Copy (Target : in out Buffer_Type;
                   Source : in     Buffer_Type);
   --  Copy Source from start to Target.

   procedure Save_Convert (CVT    : in out Conversions.Audio_CVT;
                           Source : in     Buffer_Type;
                           Target :    out Buffer_Type);
   --  Free Target buffer with Helper.Release after use.

end Toolbox;
