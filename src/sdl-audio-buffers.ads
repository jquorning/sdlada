--
--
--

with SDL.Audio.Conversions;

package SDL.Audio.Buffers is

   function To_Buffer (Audio_Buf : in Buffer_Base;
                       Audio_Len : in Byte_Count)
                      return Buffer_Type;

   function Allocate (Length : in Byte_Count) return Buffer_Type;
   procedure Release (Buffer : in out Buffer_Type);

end SDL.Audio.Buffers;
