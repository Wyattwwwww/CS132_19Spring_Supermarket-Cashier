classdef SalesRecord
    % SalesRecord Record of sale info.
    
    properties
        barcode uint64;
        quantity
        price
        cost
        time
    end
    
    methods
        function obj = SalesRecord(barcode,quantity,price,cost,time)
            obj.barcode = barcode;
            obj.quantity = quantity;
            obj.price = price;
            obj.cost = cost;
            obj.time = time;
        end
        
    end
end

