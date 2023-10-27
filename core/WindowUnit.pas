unit WindowUnit;
    
interface

{$mode objfpc}{$H+}
uses
  SysUtils,
{$ifdef LINUX}
  Math,
{$endif}
  ctypes,
  CSFMLConfig,
  CSFMLAudio,
  CSFMLGraphics,
  CSFMLNetwork,
  CSFMLSystem,
  Vector2Unit,
  CSFMLWindow;

    type Window_obj  = object 
        temp_ints : array [0..10] of integer; 
        width , height : integer;
        title : string;

        window_sf : psfRenderWindow;
        event_sf  : sfEvent;
        video_mode : sfVideoMode;



        constructor init(title_ : string = 'sfml-window'; width_  : integer = 800; height_ : integer = 600);
        destructor  done();

        function isOpen() : boolean;
        function pollEvents() : boolean;
        procedure display();
        procedure clear(color : sfColor);
    end;
            
implementation
        




    constructor Window_obj.init(title_ : string = 'sfml-window'; width_  : integer = 800; height_ : integer = 600);
    begin
        height:= height_;     
        width := width_;     
        title := title_;


        video_mode.width := width_;
        video_mode.height := height_;

        window_sf := sfRenderWindow_Create(video_mode,PChar(title_),
                                           sfUint32(sfClose) or sfUint32(sfTitlebar),
                                           nil)
                                           ;

        if window_sf = nil then
            raise Exception.Create('[window_sf Err] Could not create window');

        sfRenderWindow_setView(window_sf,sfView_createFromRect(sfFRect_New(0,0,width_,height_)));
    end;
    destructor Window_obj.done();
    begin
        sfRenderWindow_Destroy(window_sf);
    end;
    function Window_obj.isOpen() : boolean;
    begin
        result :=  sfRenderWindow_IsOpen(window_sf) = sfTrue ;
    end;
    function Window_obj.pollEvents() : boolean;
    begin


        result := sfRenderWindow_PollEvent(window_sf,@event_sf) = sfTrue;
        if result then
        begin
            if event_sf.type_ = sfEvtClosed then
            sfRenderWindow_Close(window_sf)
            else if event_sf.type_ = sfEvtKeyPressed then
            begin
            if sfKeyEvent(event_sf).code = sfKeyCode.sfKeyEscape then
                sfRenderWindow_Close(window_sf);
            end
            else if event_sf.type_ = sfEvtResized then
            begin
            temp_ints[0] := event_sf.size.width; 
            if(temp_ints[0] < WIDTH) then
                temp_ints[0]  := WIDTH;
            temp_ints[1] := event_sf.size.height; 
            if(temp_ints[1] < HEIGHT) then
                temp_ints[1]  := HEIGHT;
            sfRenderWindow_setView(window_sf,sfView_createFromRect(sfFRect_New(0,0,temp_ints[0],temp_ints[1])));
            end;        
        end;
    end;
    procedure Window_obj.display();
    begin
        sfRenderWindow_display(window_sf);
    end;
    procedure Window_obj.clear(color : sfColor);
    begin
        sfRenderWindow_clear(window_sf,color);
    end;

end.
