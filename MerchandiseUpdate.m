classdef MerchandiseUpdate
    %MerchandiseUpdate Record of the change of merchandise.
    
    properties
        barcode uint64;
        num
        time
        event MerchandiseEvent
    end
    
    methods
        function obj = MerchandiseUpdate(barcode,num,time,event)
            obj.num = num;
            obj.time = time;
            obj.event = event;
            obj.barcode = barcode;
        end
    end
end

