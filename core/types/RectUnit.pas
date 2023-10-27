unit RectUnit;
    
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


    type Rect_obj = object
        //TODO: i dont destory the refernce for the sf_rectangle
        x , y : cfloat;
        width , height : integer;
        rect_sfshape : PsfRectangleShape;


        procedure init(x_ ,y_ , width_ , height_ : integer);
        procedure setSize(width_ , height_ : integer);
        procedure setPosition(x_ ,y_ : integer);
        procedure setPosition(x_ , y_ : cfloat);
        
        procedure move(x_ : integer = 0;y_ : integer = 0);
        procedure move(x_ :cfloat = 0;y_ : cfloat = 0);

        procedure render(window : Window_obj);
        procedure render_outline(window : Window_obj);
    end;
    
implementation


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

    procedure Rect_obj.setPosition(x_ , y_ : cfloat);
    begin
        x := x_;
        y := y_;
        sfRectangleShape_setPosition(rect_sfshape,sfVector2f_New(x_,y_));
    end;

    procedure Rect_obj.move(x_ :integer = 0;y_ : integer = 0);
    begin
        x := x + x_;
        y := y + y_;
        sfRectangleShape_setPosition(rect_sfshape,sfVector2f_New(cfloat(x),cfloat(y)));
    end;
    procedure Rect_obj.move(x_ :cfloat = 0;y_ : cfloat = 0);
    begin
        x := x + x_;
        y := y + y_;
        sfRectangleShape_setPosition(rect_sfshape,sfVector2f_New(cfloat(x),cfloat(y)));
    end;

    procedure Rect_obj.render(window : Window_obj);
    begin
        sfRenderWindow_drawRectangleShape(window.window_sf,rect_sfshape,nil);
    end;

    procedure Rect_obj.render_outline(window : Window_obj);
    begin
        sfRectangleShape_setOutlineThickness(rect_sfshape,2.0);
        sfRectangleShape_setOutlineColor(rect_sfshape,sfColor_New(0,0,0));
        sfRectangleShape_setFillColor(rect_sfshape,sfColora_New(0,0,0,0));
        sfRenderWindow_drawRectangleShape(window.window_sf,rect_sfshape,nil);
    end;

end.
