--
--
--

package SDL.Audio.Streams is

   ---------------
   --  Streams  --
   ---------------

   type Audio_Stream is private;

   function New_Stream (Source_Format   : in Audio_Format;
                        Source_Channels : in Channel_Count;
                        Source_Rate     : in Sample_Rate;
                        Dest_Format     : in Audio_Format;
                        Dest_Channels   : in Channel_Count;
                        Dest_Rate       : in Sample_Rate)
                       return Audio_Stream;

   procedure Stream_Put (Stream : in Audio_Stream;
                         Buffer : in Buffer_Type);

   procedure Stream_Get (Stream : in     Audio_Stream;
                         Buffer : in     Buffer_Type;
                         Read   :    out Byte_Count);

   function Stream_Available (Stream : in Audio_Stream)
                             return Byte_Count;

   procedure Stream_Flush (Stream : in Audio_Stream);

   procedure Stream_Clear (Stream : in Audio_Stream);

   procedure Free_Stream (Stream : in out Audio_Stream);

private

   type Audio_Stream_Record is null record;
   type Audio_Stream is access all Audio_Stream_Record;

end SDL.Audio.Streams;

