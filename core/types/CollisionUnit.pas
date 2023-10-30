unit CollisionUnit;
    
interface

{$mode objfpc}{$H+}
  
uses 
    Math,  
    GlobalsUnit,
    UtilsUnit,
    Vector2Unit,
    RectUnit,
    PolygonUnit;


    function collision_AABB(rect1, rect2 : Rect_obj) : boolean;
    procedure max_min_projection_poly_on_vec(poly : array of Vector2; vec : Vector2; var min , max : integer);
    function collision_Sat(poly1 , poly2 : Polygon) : boolean;
    function isomatric_collided_with_center(var cords : Vector2): boolean;
    function get_selected_block_index():Vector2;

implementation


function collision_AABB(rect1, rect2 : Rect_obj) : boolean;
begin
    result := (rect1.x + rect1.width > rect2.x) and (rect1.y + rect1.height > rect2.y) and
              (rect2.x + rect2.width > rect1.x) and (rect2.y + rect2.height > rect1.y);
end;

procedure max_min_projection_poly_on_vec(poly : array of Vector2; vec : Vector2; var min , max : integer);
var 
    i ,projected : integer;
begin
    max := -1;
    min := Floor(intPower(2,30));

    for i := 0 to 3 do
    begin
        projected := poly[i].x * vec.x + poly[i].y * vec.y;
        if(projected > max) then max := projected; 
        if(projected < min) then min := projected; 
    end;
end;

function collision_Sat(poly1 , poly2 : Polygon) : boolean;
var 
    i: integer;
    points1 , points2 : array [0..3] of Vector2;
    p1 , p2 : Vector2;
    
    norm , vec : Vector2;
    
    pmin1 , pmin2 , pmax1, pmax2 : integer;
begin
    points1[0] := poly1.p1; points1[1] := poly1.p2; points1[2] := poly1.p3; points1[3] := poly1.p4;
    points2[0] := poly2.p1; points2[1] := poly2.p2; points2[2] := poly2.p3; points2[3] := poly2.p4;
    
    result := true;
    for i := 0 to 3 do 
    begin
        p1 := points1[i];
        p2 := points1[(i + 1) mod 4];

        vec.new(p1.x - p2.x,p1.y - p2.y);
        norm.new(-vec.y,vec.x);

        max_min_projection_poly_on_vec(points1,norm,pmin1,pmax1);        
        max_min_projection_poly_on_vec(points2,norm,pmin2,pmax2);

        // no overlap
        if ((pmax1 < pmin2) or (pmax2 < pmin1)) then
        begin
            result := false;
            break;
        end;
    end;


    if(result) then 
    begin
        for i := 0 to 3 do 
        begin
            p1 := points2[i];
            p2 := points2[(i + 1) mod 4];


            vec.new(p1.x - p2.x,p1.y - p2.y);
            norm.new(vec.y,-vec.x);

            max_min_projection_poly_on_vec(points1,norm,pmin1,pmax1);        
            max_min_projection_poly_on_vec(points2,norm,pmin2,pmax2);

            if ((pmax1 < pmin2) or (pmax2 < pmin1)) then
            begin
                result := false;
                break;
            end;
        end;
    end;


    Exit(result);

end;


function isomatric_collided_with_center(var cords : Vector2): boolean;
var 
    poly1, poly2 : Polygon;
    selected_tile_pos : Vector2;
begin
    // calc mouse click offseted 
    selected_tile_pos.new(Floor(mouse_rect.x) - start_x,Floor(mouse_rect.y) - start_y);
    // get iso (x , y)
    cords := IsoToXY(selected_tile_pos.x,selected_tile_pos.y);
    
    poly1.p1.new(round(mouse_position.x)                       ,round(mouse_position.y));
    poly1.p2.new(round(mouse_position.x                   )    ,round(mouse_position.y + 1));
    poly1.p3.new(round(mouse_position.x + 1),round(mouse_position.y + 1));
    poly1.p4.new(round(mouse_position.x + 1),round(mouse_position.y    ));

    poly2.p1.new(round(mouse_rect.x + mouse_rect.width / 2),round(mouse_rect.y                                ));
    poly2.p2.new(round(mouse_rect.x                               ),round(mouse_rect.y + mouse_rect.height / 2));
    poly2.p3.new(round(mouse_rect.x + mouse_rect.width / 2),round(mouse_rect.y + mouse_rect.height    ));
    poly2.p4.new(round(mouse_rect.x + mouse_rect.width    ),round(mouse_rect.y + mouse_rect.height / 2));
    Exit(collision_Sat(poly1,poly2));
end;

  function get_selected_block_index():Vector2;
  var
      mouse_rect_pos ,corner_rect  : Rect_obj;
  begin

      if(isomatric_collided_with_center(result)) then
          Exit(result);

      mouse_rect_pos.init(mouse_position.x,mouse_position.y,1,1);
      corner_rect.init(round(mouse_rect.x),round(mouse_rect.y),round(mouse_rect.width / 2),round(mouse_rect.height / 2));

      if(collision_AABB(mouse_rect_pos,corner_rect)) then
      begin
          result.x -= 1;
          Exit(result);
      end;

      corner_rect.x += round(mouse_rect.width / 2);
      if(collision_AABB(mouse_rect_pos,corner_rect)) then
      begin
          result.y -= 1;
          Exit(result);
      end;

      corner_rect.y += round(mouse_rect.height / 2);
      if(collision_AABB(mouse_rect_pos,corner_rect)) then
      begin
          result.x += 1;
          Exit(result);
      end;

      corner_rect.x -= round(mouse_rect.width / 2);
      if(collision_AABB(mouse_rect_pos,corner_rect)) then
      begin
          result.y += 1;
          Exit(result);
      end;
  end;

end.
