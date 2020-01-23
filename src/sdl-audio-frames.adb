--
--
--

package body SDL.Audio.Frames is

   package body Buffer_Overlays is

      function First_Index (Buffer : Buffer_Type) return Frame_Index
      is (1);

      function Last_Index  (Buffer : Buffer_Type) return Frame_Index
      is (Natural (8 * Buffer.Length / Sample_Type'Size) / Frame_Type'Length);

      function Value (Buffer  : in Buffer_Type;
                      Frame   : in Frame_Index;
                      Channel : in Frame_Config)
                     return Sample_Type
      is (Value (Buffer, Frame) (Channel));

      function Value (Buffer  : in Buffer_Type;
                      Frame   : in Frame_Index)
                     return Frame_Type
      is
         subtype Array_Range is Frame_Index
           range First_Index (Buffer) .. Last_Index  (Buffer);
         type Array_Type is array (Array_Range) of Frame_Type;
         Buf : Array_Type with Address => System.Address (Buffer.Base);
      begin
         return Buf (Frame);
      end Value;

      procedure Update (Buffer  : in out Buffer_Type;
                        Frame   : in     Frame_Index;
                        Channel : in     Frame_Config;
                        Value   : in     Sample_Type)
      is
         subtype Array_Range is Frame_Index
           range First_Index (Buffer) .. Last_Index  (Buffer);
         type Array_Type is array (Array_Range) of Frame_Type;
         Buf : Array_Type with Address => System.Address (Buffer.Base);
      begin
         Buf (Frame) (Channel) := Value;
      end Update;

      procedure Update (Buffer  : in out Buffer_Type;
                        Frame   : in     Frame_Index;
                        Value   : in     Frame_Type)
      is
         subtype Array_Range is Frame_Index
           range First_Index (Buffer) ..  Last_Index  (Buffer);
         type Array_Type is array (Array_Range) of Frame_Type;
         Buf : Array_Type with Address => System.Address (Buffer.Base);
      begin
         Buf (Frame) := Value;
      end Update;

   end Buffer_Overlays;

end SDL.Audio.Frames;

