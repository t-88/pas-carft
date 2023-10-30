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
  CSFMLWindow,

  GlobalsUnit,
  UtilsUnit,
  Vector2Unit,
  DebugUnit,
  EngineUnit,
  RectUnit,
  PolygonUnit,
  CollisionUnit,
  SpriteUnit;



var 
    rect : Rect_obj;

    tile : Sprite_obj;
    selected_tile : Sprite_obj;

    mouse_down , mouse_down_keep_frame : boolean;

    cur_hovered_tile : Vector2;
    cur_hovered_tilerect : PsfConvexShape;


procedure event(event_sf : sfEvent);
begin   
    if (event_sf.type_ = sfEvtMouseMoved) or (event_sf.type_ = sfEvtMouseButtonReleased) then
    begin
        mouse_position.x := event_sf.mouseMove.x;
        mouse_position.y := event_sf.mouseMove.y;
    end
    else if event_sf.type_ = sfEvtMouseButtonPressed then
    begin
        mouse_down := true;
        mouse_down_keep_frame := true;
    end
end;

procedure update();
var 
    cur_tile : Vector2;
begin
    if(mouse_down_keep_frame) then
       mouse_down_keep_frame := false
    else 
        mouse_down := false;

    
    
    mouse_rect.setPosition(
                            floor(floor(mouse_position.x / mouse_rect.width ) * mouse_rect.width),
                            floor(floor(mouse_position.y / mouse_rect.height) * mouse_rect.height)
                        );

    if(not isomatric_collided_with_center(cur_tile)) then begin
        cur_tile := get_selected_block_index();
    end;


    cur_hovered_tile.new(cur_tile.x,cur_tile.y);
    cur_tile.new(cur_tile.x * 32 - cur_tile.y * 32,cur_tile.x * 16 + cur_tile.y * 16 );

    sfConvexShape_setPoint(cur_hovered_tilerect,0,sfVector2f_New(start_x + cur_tile.x + mouse_rect.width / 2,start_y                                 + cur_tile.y));
    sfConvexShape_setPoint(cur_hovered_tilerect,1,sfVector2f_New(start_x + cur_tile.x                               ,start_y + mouse_rect.height / 2 + cur_tile.y));
    sfConvexShape_setPoint(cur_hovered_tilerect,2,sfVector2f_New(start_x + cur_tile.x + mouse_rect.width / 2,start_y + mouse_rect.height     + cur_tile.y));
    sfConvexShape_setPoint(cur_hovered_tilerect,3,sfVector2f_New(start_x + cur_tile.x + mouse_rect.width    ,start_y + mouse_rect.height / 2 + cur_tile.y));

    if(mouse_down) then
    begin
    end;
end;


procedure render();
var
    vec : Vector2;
    x , y : integer;

    outline_rect : Rect_obj;
    
begin
    engine.window.clear(sfColor_New(135,206,235));

    outline_rect.init(0,0,TILE_WIDTH,floor(TILE_WIDTH / 2));
    outline_rect.outline_color := sfColora_New(255,0,0,100);

    for y := 0 to tiles_count_y - 1 do
    begin
        for x := 0 to tiles_count_x - 1 do
        begin

            vec := XYToIso(x,y);
            vec.x := vec.x + start_x;
            vec.y := vec.y  + start_y;

            outline_rect.setPosition(vec.x,vec.y);
            
            tile.setPosition(vec.x,vec.y);
            tile.render(engine.window);
        end;
    end;


    sfRenderWindow_drawConvexShape(engine.window.window_sf,cur_hovered_tilerect,nil);
    debug_render_isomatric_grid();
end;


begin
    engine.window.init('pas-craft',800,600);
    engine.update := @update;  
    engine.render := @render;  
    engine.event := @event;  
    
    
    rect.init(0,0,50,50);
    mouse_rect.init(0,0,TILE_WIDTH,floor(TILE_WIDTH / 2));


    cur_hovered_tile.new(-1,-1);

    cur_hovered_tilerect := sfConvexShape_create();
    sfConvexShape_setPointCount(cur_hovered_tilerect,4);

    sfConvexShape_setPoint(cur_hovered_tilerect,0,sfVector2f_New(50.0,1.0));
    sfConvexShape_setPoint(cur_hovered_tilerect,1,sfVector2f_New(1.0,50.0));
    sfConvexShape_setPoint(cur_hovered_tilerect,2,sfVector2f_New(50.0,100.0));
    sfConvexShape_setPoint(cur_hovered_tilerect,3,sfVector2f_New(100.0,50.0));
     
    
    
    tile.fromFile('./art/tile.png');
    tile.scale(2,2);


    selected_tile.fromFile('./art/tile_selected.png');
    selected_tile.scale(1,1);





    start_x := TILE_WIDTH * 6;
    start_y := TILE_WIDTH * 2;

    tiles_count_x := 10;
    tiles_count_y := 10;

    
    engine.run;
    engine.window.done;


    sfConvexShape_destroy(cur_hovered_tilerect);
end.


