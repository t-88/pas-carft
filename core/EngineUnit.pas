unit EngineUnit;



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
  WindowUnit;


    type Engine_obj  = object 
        window : Window_obj;
        sf_event : sfEvent;
        temp_ints : array[0..10] of integer;

        update : procedure();
        render : procedure();
        event : procedure(sf_event : sfEvent);

        procedure run();
    end;
    
implementation

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


    
end.

