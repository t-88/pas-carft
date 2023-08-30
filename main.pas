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

const 
  WIDTH = 800;
  HEIGHT = 800;
  TILE_WIDTH =  64;
  TILE_HEIGHT = 32;



type Vector2 = record 
  x : integer;
  y : integer;
end;

function sfVector2f_New(x,y:cfloat): sfVector2f;
begin
  result.x := x;
  result.y := y;
end;
function sfVector2i_New(x,y:Integer): sfVector2i;
begin
  result.x := x;
  result.y := y;
end;
function sfColor_New(r,g,b:sfUint8): sfColor;
begin
  result.r := r;
  result.g := g;
  result.b := b;
  result.a := 255;
end;
function sfFRect_New(x,y,w,h:cfloat): sfFloatRect;
begin
  result.left := x;
  result.top := y;
  result.width := w;
  result.height := h;
end;

function IsoProj(x , y : integer) : Vector2;
begin
  result.x :=  (x - y) * (TILE_WIDTH  >> 1);
  result.y :=  (x + y) * (TILE_HEIGHT >> 1);
end;

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
constructor Window_obj.init(title_ : string = 'sfml-window'; width_  : integer = 800; height_ : integer = 600);
begin
    height:= height_;     
    width := width_;     
    title := title_;


    video_mode.width := width_;
    video_mode.height := height_;

    window_sf := sfRenderWindow_Create(video_mode,PChar(title_),sfUint32(sfResize) or sfUint32(sfClose),nil);

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


type Rect_obj = object
//TODO: i dont destory the refernce for the sf_rectangle
    x , y , width , height : integer;
    rect_sfshape : PsfRectangleShape;


    procedure init(x_ ,y_ , width_ , height_ : integer);
    procedure setSize(width_ , height_ : integer);
    procedure setPosition(x_ ,y_ : integer);
    procedure move(x_ : integer = 0;y_ : integer = 0);

    procedure render(window : Window_obj);
end;



procedure Rect_obj.init(x_ ,y_ , width_ , height_ : integer);
begin
    x := x_;
    y := y_;
    width := width_;
    height := height_;

    rect_sfshape := sfRectangleShape_create();
    sfRectangleShape_SetSize(rect_sfshape,sfVector2f_New(cfloat(width_),cfloat(height_)));
    sfRectangleShape_setPosition(rect_sfshape,sfVector2f_New(cfloat(x_),cfloat(y_)));
end;
procedure Rect_obj.setSize(width_ , height_ : integer);
begin
    width := width_;
    height := height_;
    sfRectangleShape_SetSize(rect_sfshape,sfVector2f_New(cfloat(width_),cfloat(height_)));

end;
procedure Rect_obj.setPosition(x_ , y_ : integer);
begin
    x := x_;
    y := y_;
    sfRectangleShape_setPosition(rect_sfshape,sfVector2f_New(cfloat(x_),cfloat(y_)));
end;

procedure Rect_obj.move(x_ :integer = 0;y_ : integer = 0);
begin
    x := x + x_;
    y := y + y_;
    sfRectangleShape_setPosition(rect_sfshape,sfVector2f_New(cfloat(x),cfloat(y)));
end;

procedure Rect_obj.render(window : Window_obj);
begin
    sfRenderWindow_drawRectangleShape(window.window_sf,rect_sfshape,nil);
end;



type Sprite_obj = object
    texture_sf : psfTexture;
    sprite_sf : psfSprite;
    x , y , width , height : integer;

    procedure setPosition(x_ , y_ : integer);
    procedure move(x_ :integer = 0;y_ : integer = 0);
    procedure scale(x_ :cfloat = 1;y_ : cfloat = 1);

    procedure fromFile(file_path : string);
    procedure render(window : Window_obj);

end;
procedure Sprite_obj.setPosition(x_ , y_ : integer);
begin
    x := x_;
    y := y_;
    sfSprite_setPosition(sprite_sf,sfVector2f_New(cfloat(x_),cfloat(y_)));
end;

procedure Sprite_obj.move(x_ :integer = 0;y_ : integer = 0);
begin
    x := x + x_;
    y := y + y_;
    sfSprite_setPosition(sprite_sf,sfVector2f_New(cfloat(x),cfloat(y)));
end;
procedure Sprite_obj.scale(x_ :cfloat = 1;y_ : cfloat = 1);
begin
    sfSprite_setScale(sprite_sf,sfVector2f_New(x_,y_));

    width :=  Floor(width * x_);
    height := Floor(height * y_);
end;

procedure Sprite_obj.fromFile(file_path : string);
var 
    size : sfVector2u;
begin
    texture_sf := sfTexture_createFromFile(pChar(file_path),nil);
    if texture_sf = nil then
        raise Exception.Create('[Sprite_obj Err] Could not create sprite from file_path');
    sprite_sf := sfSprite_create();
    sfSprite_setTexture(sprite_sf,texture_sf,sfTrue);

    size := sfTexture_getSize(texture_sf);
    width := integer(size.x);
    height := integer(size.y);

    if (width = 0) or (height = 0) then
        raise Exception.Create('[Sprite_obj Err] sprite width or height = 0');
end;
procedure Sprite_obj.render(window : Window_obj);
begin
    sfRenderWindow_drawSprite(window.window_sf,sprite_sf,nil);
end;



type Engine_obj  = object 
    window : Window_obj;
    sf_event : sfEvent;
    temp_ints : array[0..10] of integer;

    update : procedure();
    render : procedure();
    event : procedure(sf_event : sfEvent);
    
    procedure run();
end;
procedure Engine_obj.run();
begin

    while window.isOpen() do 
    begin
        while window.pollEvents() do 
        begin
            event(window.event_sf);
        end;
    
        update();
        render();

        window.display();
    end;
end;


type Cursor_obj = object
    x , y : integer;
    constructor init(x_ , y_ : integer);
end;
constructor Cursor_obj.init(x_ , y_ : integer);
begin
    x := x_;
    y := y_;
end;

var 
    engine : Engine_obj;
    rect : Rect_obj;

    tile : Sprite_obj;
    selected_tile : Sprite_obj;


    tiles : array [0..10] of integer;
    start_x : integer; 
    start_y : integer; 
    tiles_count_x : integer;
    tiles_count_y : integer;

    cursor : Cursor_obj;



procedure event(event_sf : sfEvent);
begin
    if event_sf.type_ = sfEvtKeyPressed then
    begin
        if sfKeyEvent(event_sf).code = sfKeyCode.sfKeyRight then
        begin
            cursor.x := (cursor.x + 1) mod tiles_count_x;
        end
        else if sfKeyEvent(event_sf).code = sfKeyCode.sfKeyLeft then
        begin
            cursor.x -= 1;
            if cursor.x < 0 then
                cursor.x := tiles_count_x - 1; 
        end
        else if sfKeyEvent(event_sf).code = sfKeyCode.sfKeyDown then
        begin
            cursor.y := (cursor.y + 1) mod tiles_count_y;
        end
        else if sfKeyEvent(event_sf).code = sfKeyCode.sfKeyUp then
        begin
            cursor.y -= 1;
            if cursor.y < 0 then
                cursor.y := tiles_count_y - 1; 
        end; 
        
    end;
end;

procedure update();
begin
    
end;

procedure render_isomatric_grid();
const
    // manual project
    GRID_OFFSET_X = TILE_HEIGHT;
    GRID_OFFSET_Y = TILE_HEIGHT / 2 - 16;
var 
    line : PsfVertexArray;
    projected : Vector2;


    vertex : sfVertex;

    x , y : integer;


begin
    vertex.color    := sfColor_New(0,0,0);


    line := sfVertexArray_create();
    sfVertexArray_setPrimitiveType(line,sfPrimitiveType.sfLines);

    // draw horizontal lines
    for y := 0 to Floor((engine.window.height / TILE_HEIGHT) + 0.5) do 
    begin
        for x := 0 to Floor((engine.window.width / TILE_WIDTH) + 0.5) do 
        begin
            projected := IsoProj(x,y);

            vertex.position.x := projected.x  + start_x + GRID_OFFSET_X;      
            vertex.position.y := projected.y  + start_y + GRID_OFFSET_Y;      
                  
            sfVertexArray_append(line,vertex);

            if (x <> 0) and (x <> Floor((engine.window.width / TILE_WIDTH) + 0.5)) then 
                sfVertexArray_append(line,vertex);
        end;
    end;

    // draw vertical lines
    for x := 0 to  Floor((engine.window.width / TILE_WIDTH) + 0.5) do
    begin
        for y := 0 to Floor((engine.window.height / TILE_HEIGHT) + 0.5) do
        begin
            projected := IsoProj(x,y);

            vertex.position.x := projected.x + start_x + GRID_OFFSET_X;            
            vertex.position.y := projected.y + start_y + GRID_OFFSET_Y;            

            sfVertexArray_append(line,vertex);
            if (y <> 0) and (y <> Floor((engine.window.height / TILE_HEIGHT) + 0.5)) then
                sfVertexArray_append(line,vertex);
        end;
    end;   

    sfRenderWindow_drawVertexArray(engine.window.window_sf,line,nil);


    sfVertexArray_clear(line); 
    sfVertexArray_destroy(line);
end;


procedure render();
var
    vec : Vector2;
    x , y : integer;
begin
    engine.window.clear(sfColor_New(135,206,235));



    for y := 0 to tiles_count_y - 1 do
    begin
        for x := 0 to tiles_count_x - 1 do
        begin
            if (cursor.x = x) and (cursor.y = y) then
            begin 
                vec := IsoProj(cursor.x,cursor.y);
                vec.x := vec.x + start_x;
                vec.y := vec.y + start_y;
                
                selected_tile.setPosition(vec.x,vec.y);
                selected_tile.render(engine.window);
            end
            else 
            begin
                vec := IsoProj(x,y);
                vec.x := vec.x + start_x;
                vec.y := vec.y + start_y;

                tile.setPosition(vec.x,vec.y);
                tile.render(engine.window);
            end;
        end;
    end;



    render_isomatric_grid();
end;


var 
    i : integer;

        
begin
    
    engine.window.init('pas-mine',800,600);
    engine.update := @update;  
    engine.render := @render;  
    engine.event := @event;  
    
    
    rect.init(0,0,50,50);
    
    tile.fromFile('./art/tile.png');
    tile.scale(2,2);


    selected_tile.fromFile('./art/tile_selected.png');
    selected_tile.scale(1,1);





    start_x := engine.window.width >> 1;
    start_y := 200;
    for i := 0 to 10 do
        tiles[i] := 0;

    tiles_count_x := 2;
    tiles_count_y := 5;

    cursor.init(0,0);
    
    
    engine.run;
    engine.window.done;


end.