--
--
--

package SDL.Audio.Frames is

   ------------------------------
   --  Channel configurations  --
   ------------------------------

   type Config_Mono         is (Common);
   type Config_Stereo       is (Front_Left, Front_Right);
   type Config_Surround_2_1 is (Front_Left, Front_Right, LFE);
   type Config_Quad         is (Front_Left, Front_Right,
                                Back_Left, Back_Right);
   type Config_Quad_Center  is (Front_Left, Front_Right,
                                Front_Center,
                                Back_Left, Back_Right);
   type Config_Surround_5_1 is (Front_Left, Front_Right,
                                Front_Center, LFE,
                                S_Left, S_Right);
   type Config_Surround_6_1 is (Front_Left, Front_Right,
                                Front_Center, LFE,
                                Back_Center,
                                S_Left, S_Right);
   type Config_Surround_7_1 is (Front_Left, Front_Right,
                                Front_Center, LFE,
                                Back_Left, Back_Right,
                                S_Left, S_Right);

   generic
      type Sample_Type  is private;
      type Frame_Config is (<>);  --  See enumerations above (Config_*)
   package Buffer_Overlays is

      subtype Frame_Index is Natural;
      type Frame_Type is array (Frame_Config) of Sample_Type;

      function First_Index (Buffer : Buffer_Type) return Frame_Index;
      function Last_Index  (Buffer : Buffer_Type) return Frame_Index;

      function Value (Buffer  : in Buffer_Type;
                      Frame   : in Frame_Index;
                      Channel : in Frame_Config)
                     return Sample_Type;

      function Value (Buffer : in Buffer_Type;
                      Frame  : in Frame_Index)
                     return Frame_Type;

      procedure Update (Buffer  : in out Buffer_Type;
                        Frame   : in     Frame_Index;
                        Channel : in     Frame_Config;
                        Value   : in     Sample_Type);

      procedure Update (Buffer  : in out Buffer_Type;
                        Frame   : in     Frame_Index;
                        Value   : in     Frame_Type);
   end Buffer_Overlays;

end SDL.Audio.Frames;

