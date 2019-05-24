classdef Merchandise < handle

    properties
        name;
        cost single;
        price single;
        unit;
        stockQuantity single;
        barcode uint64;
    end
    
    methods
        function obj = Merchandise(a1,a2,a3,a4,a5,a6)
            %   initialize all the properties of a merchandise
            obj.name = a1;
            obj.cost = a2;
            obj.price = a3;
            obj.unit = a4;
            obj.barcode = a6;
            obj.stockQuantity = a5;
        end
    end
end

