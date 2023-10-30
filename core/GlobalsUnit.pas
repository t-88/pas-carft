unit GlobalsUnit;
    
interface
uses 
    EngineUnit,
    RectUnit,
    Vector2Unit;
const 
    WIDTH = 800;
    HEIGHT = 800;
    TILE_WIDTH =  64;
    TILE_HEIGHT = 64;
var
    engine : Engine_obj;
    start_x : integer;
    start_y : integer;
    mouse_position : Vector2;
    mouse_rect : Rect_obj;

    tiles_count_x : integer;
    tiles_count_y : integer;


implementation
end.
