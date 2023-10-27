unit Vector2Unit;

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
CSFMLWindow;



  type Vector2 = object 
    x : integer;
    y : integer;
    procedure new(x_ , y_ : integer);

  end;

  function sfVector2f_New(x,y:cfloat): sfVector2f;
  function sfVector2i_New(x,y:Integer): sfVector2i;
  function sfColor_New(r,g,b:sfUint8): sfColor;
  function sfColora_New(r,g,b,a:sfUint8): sfColor;
  function sfFRect_New(x,y,w,h:cfloat): sfFloatRect;


implementation
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
  function sfColora_New(r,g,b,a:sfUint8): sfColor;
  begin
    result.r := r;
    result.g := g;
    result.b := b;
    result.a := a;
  end;  
  function sfFRect_New(x,y,w,h:cfloat): sfFloatRect;
  begin
    result.left := x;
    result.top := y;
    result.width := w;
    result.height := h;
  end;

  procedure Vector2.new(x_ , y_ : integer);
  begin
    x := x_;
    y := y_;
  end;

end.
