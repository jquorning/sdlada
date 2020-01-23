--
--
--

package body SDL.Audio.Buffers is

   function To_Buffer (Audio_Buf : in Buffer_Base;
                       Audio_Len : in Byte_Count)
                      return Buffer_Type is
   begin
      return Buffer_Type'(Base   => Audio_Buf,
                          Length => Audio_Len);
   end To_Buffer;


   function Allocate (Length : in Byte_Count)
                     return SDL.Audio.Buffer_Type
   is
      function C_Calloc (Count : in Byte_Count;
                         Size  : in Byte_Count) return Buffer_Base;
      pragma Import (C, C_Calloc, "calloc");

      Base : constant Buffer_Base := C_Calloc (Count => Length, Size => 1);
   begin
      return To_Buffer (Audio_Buf => Base,
                        Audio_Len => Length);
   end Allocate;


   procedure Release (Buffer : in out SDL.Audio.Buffer_Type)
   is
      procedure C_Free (Buffer : in Buffer_Base);
      pragma Import (C, C_Free, "free");
   begin
      C_Free (SDL.Audio.Base (Buffer));
   end Release;


end SDL.Audio.Buffers;
