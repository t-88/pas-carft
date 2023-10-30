unit DebugUnit;


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
      
        UtilsUnit,
        EngineUnit,
        GlobalsUnit,
        Vector2Unit
    ;

    procedure debug_render_isomatric_grid();

implementation

    procedure debug_render_isomatric_grid();
    var 
        line : PsfVertexArray;
        projected : Vector2;


        vertex : sfVertex;

        x , y : integer;

        grid_offset : sfVector2f;


    begin
        vertex.color    := sfColor_New(0,0,0);
        grid_offset := XYToIso(0.5,-0.5);






        line := sfVertexArray_create();
        sfVertexArray_setPrimitiveType(line,sfPrimitiveType.sfLines);

        // draw horizontal lines
        for y := 0 to tiles_count_y do 
        begin
            for x := 0 to tiles_count_x do 
            begin
                projected := XYToIso(x,y);

                vertex.position.x := projected.x  + start_x + grid_offset.x;      
                vertex.position.y := projected.y  + start_y + grid_offset.y;      
                    
                sfVertexArray_append(line,vertex);

                if (x <> 0) and (x <> tiles_count_x) then 
                    sfVertexArray_append(line,vertex);
            end;
        end;

        // draw vertical lines
        for x := 0 to  tiles_count_x do
        begin
            for y := 0 to tiles_count_y do
            begin
                projected := XYToIso(x,y);

                vertex.position.x := projected.x + start_x + grid_offset.x;            
                vertex.position.y := projected.y + start_y + grid_offset.y;            

                sfVertexArray_append(line,vertex);
                if (y <> 0) and (y <> tiles_count_y) then
                    sfVertexArray_append(line,vertex);
            end;
        end;   

        sfRenderWindow_drawVertexArray(engine.window.window_sf,line,nil);
        sfVertexArray_clear(line); 
        sfVertexArray_destroy(line);

    end;


end.