unit UtilsUnit;
    
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

  GlobalsUnit,
  Vector2Unit;


    function XYToIso(x , y : integer) : Vector2;
    function XYToIso(x , y : cfloat) : sfVector2f;
    function IsoToXY(x , y: integer)  : Vector2;


implementation
    function XYToIso(x , y: integer)  : Vector2;
    begin
        // using matrix multiplication https://pikuma.com/blog/isometric-projection-in-games
        // x * (0.5 * Tw) + y * (-0.5 * Tw)
        //    (0.25 * Th) +     (0.25 * Th)
        result.x :=  (x - y) * (TILE_WIDTH  >> 1);
        result.y :=  (x + y) * (TILE_HEIGHT >> 2);
    end;
    
    function XYToIso(x , y : cfloat) : sfVector2f;
    begin
        result.x :=  (x - y) * (TILE_WIDTH  / 2);
        result.y :=  (x + y) * (TILE_HEIGHT / 4);
    end;
    function IsoToXY(x , y: integer)  : Vector2;
    var 
        inv : cfloat;
    begin
        // matrix
        // (0.5  * Tw  , -0.5* Tw)
        // (0.25 * Th , 0.25 * Th)

        // inverse of matrix
        // 1/(a*b-c*d) *  (0.25 * Th  , 0.5* Tw)
                        // (-0.25 * Th ,0.5  * Tw)

        inv := 1./(TILE_WIDTH  * (TILE_HEIGHT >> 2));

        result.x :=  Floor((x  * (TILE_HEIGHT >> 2) + y * (TILE_WIDTH  >> 1)) * inv);
        result.y :=  Floor((-x * (TILE_HEIGHT >> 2) + y * (TILE_WIDTH  >> 1)) * inv);
    end;




end.
