--
--
--

with Ada.Text_IO;
with Ada.Command_Line;

with SDL.Audio;
with SDL.Audio.Conversions;
with SDL.Audio.Buffers;

with Toolbox;
with Audio_IO;

procedure Conversion is
   use Ada.Text_IO;
   use SDL.Audio;

   Desired : constant Audio_Spec :=
     (Frequency => 48_000,
      Format    => Audio_S16,
      Channels  => 2,
      Samples   => 512,
      Silence   => 0,
      Size      => 0,
      Callback  => null,
      Userdata  => 0,
      Padding   => 0);

   Obtained     : Audio_Spec;
   Obtained_WAV : Audio_Spec;
   Buffer_WAV   : Buffer_Type := Null_Buffer;
   CVT          : Conversions.Audio_CVT;
   Need_Convert : Boolean;
   Buffer_Conv  : Buffer_Type := Null_Buffer;
begin
   if Ada.Command_Line.Argument_Count /= 1 then
      Put_Line ("Usage: conversation file.wav");
      return;
   end if;

   --
   --  Initialise SDL and open audio device and start playing silence
   --
   if SDL.Initialise then
      null;
   end if;
   Open (Desired, Obtained);
   Pause (False);

   Load_WAV (Ada.Command_Line.Argument (1),
             Obtained_WAV,
             Buffer_WAV);

   --
   --  Prepare CVT structure
   --
   Put_Line ("Convert loaded WAV to driver sample rate:");
   Conversions.Build_CVT
     (CVT,
      Source_Format   => Obtained_WAV.Format,
      Source_Channels => Obtained_WAV.Channels,
      Source_Rate     => Obtained_WAV.Frequency,
      Dest_Format     => Obtained.Format,
      Dest_Channels   => Obtained.Channels,
      Dest_Rate       => Obtained.Frequency,
      Need_Conversion => Need_Convert);
   pragma Assert (Need_Convert);

   Put_Line ("CVT:");
   Audio_IO.Dump (CVT, Compact => True);
   New_Line;

   --
   --  Convert sample rate of Buffer_Conv
   --
   Toolbox.Save_Convert (CVT, Source => Buffer_WAV, Target => Buffer_Conv);

   Put_Line ("CVT after convert:");
   Audio_IO.Dump (CVT, Compact => True);
   New_Line;

   --
   --  Play Buffer_Conv four times
   --
   Put_Line ("Sound is played four times.");
   Queue (1, Buffer_Conv);
   Queue (1, Buffer_Conv);
   Queue (1, Buffer_Conv);
   Queue (1, Buffer_Conv);

   while not (Queued_Size (1) = 0) loop
      delay 0.100;
   end loop;

   Free_WAV (Buffer_WAV);
   Buffers.Release (Buffer_Conv);
   Close;
   Quit;
end Conversion;
