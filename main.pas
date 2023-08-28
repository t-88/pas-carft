program PasCraft;

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
  CSFMLWindow;


function sfVector2f_New(x,y:Integer): sfVector2f;
begin
  result.x := x;
  result.y := y;
end;

var 
    vid_mode : sfVideoMode;
    render_window : PsfRenderWindow;
    event : sfEvent;
    
    rect : PsfRectangleShape;
begin
    vid_mode.width := 800;
    vid_mode.height := 600;

    render_window := nil;
    render_window := sfRenderWindow_Create(vid_mode,PChar('asd'),sfUint32(sfResize) or sfUint32(sfClose),nil); 
    if render_window = nil then
        raise Exception.Create('[Window Err] Could not create window');


    rect := sfRectangleShape_create();
    sfRectangleShape_SetSize(rect,sfVector2f_New(50,50));

    while (sfRenderWindow_IsOpen(render_window) = sfTrue) do 
    begin
        while (sfRenderWindow_PollEvent(render_window,@Event) = sfTrue) do 
        begin

            if Event.type_ = sfEvtClosed then
              sfRenderWindow_Close(render_window)
            else if Event.type_ = sfEvtKeyPressed then
              if sfKeyEvent(Event).code = sfKeyCode.sfKeyEscape then
                sfRenderWindow_Close(render_window);
        end;

        sfRenderWindow_Clear(render_window,sfBlack);

        sfRectangleShape_move(rect,sfVector2f_New(5,0));
        sfRenderWindow_DrawRectangleShape(render_window,rect,nil);

        sfRenderWindow_display(render_window);
    end;

    sfRenderWindow_Destroy(render_window);
end.