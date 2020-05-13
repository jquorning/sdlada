--
--
--

with SDL.Audio.Buffers;

package body Toolbox is


   procedure Clear (Buffer : in out Buffer_Type) is
      use Stereo_Buffers;
      subtype Frame_Range is Frame_Index
        range First_Index (Buffer) .. Last_Index (Buffer);
   begin
      for Index in Frame_Range loop
         Update (Buffer, Index, Value => (0, 0));
      end loop;
   end Clear;


   procedure Copy (Target : in out Buffer_Type;
                   Source : in     Buffer_Type)
   is
      use Stereo_Buffers;
      First : constant Frame_Index := Frame_Index'Max (First_Index (Source),
                                                       First_Index (Target));
      Last  : constant Frame_Index := Frame_Index'Min (Last_Index (Source),
                                                       Last_Index (Target));
      Frame : Frame_Type;
   begin
      for Index in First .. Last loop
         Frame := Value (Source, Index);
         Update (Target, Index, Frame);
      end loop;
   end Copy;


   procedure Save_Convert (CVT    : in out Conversions.Audio_CVT;
                           Source : in     Buffer_Type;
                           Target :    out Buffer_Type)
   is
      Working_Length : constant Byte_Count := Conversions.Working_Length (CVT, Source);
      --  Length (Source) * Byte_Count (CVT.Length_Multiply);
      Working        : Buffer_Type         := Buffers.Allocate (Length => Working_Length);
      --  Working buffer Length_Multiplier times longer than source buffer
      --  to convert. Working is cleaned by Allocate.
   begin
      Copy (Target => Working, Source => Source);
      --  Copy Source into start of Working buffer.

      Conversions.Set_Buffer (CVT, Working);
      Conversions.Set_Source_Length (CVT, Length (Source));
      --  Install Working buffer in CVT.

      Conversions.Convert (CVT);
      --  Do the actual conversion in-place in Working buffer.

      Target := Buffers.Allocate (Length => Conversions.Converted_Length (CVT));
      --  Allocate result buffer with the right length. Target must be freed
      --  by client with Helper.Release.

      Copy (Target => Target,
            Source => Conversions.Get_Converted_Buffer (CVT));
--            Source => SDL.Audio.Buffers.To_Buffer (CVT.Audio_Buf,
--                                                   CVT.Length_CVT));
      --  Copy actual converted samples into the result Target.

      Buffers.Release (Working);  --  Free the temporary Working buffer.
   end Save_Convert;


end Toolbox;
