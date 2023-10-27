

unit SpriteUnit;
    
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
  CSFMLWindow,
  Vector2Unit,
  WindowUnit;

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
    
implementation
    

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



    
end.
