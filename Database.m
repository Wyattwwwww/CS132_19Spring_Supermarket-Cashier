classdef Database < handle
    
    properties 
        merchandiseList = []; 
        costChangeList = [];
        priceChangeList = [];
        profitChangeList = [];
        amountChangeList = [];
        salesRecordList = [];
    end
    
    methods
        function result = getQuantity(DB,barcode)
            % return -1 if not found, return stock quantity if found
            for i=1:length(DB.merchandiseList)
               if isequal(DB.merchandiseList(i).barcode,barcode) 
                   result = DB.merchandiseList(i).stockQuantity;
                   return;
               end
            end
            result = -1;
        end
        
        function addMerchandise(DB,barcode,name,quantity,cost,price,unit)
            if DB.getQuantity(barcode) == -1
                merchandise = Merchandise(name,cost,price,unit,quantity,barcode);
                DB.merchandiseList = [DB.merchandiseList, merchandise];

                DB.recordChange(barcode,quantity,cost,price,MerchandiseEvent.putIn);
                
            else
                for i=1:length(DB.merchandiseList)
                    if isequal(DB.merchandiseList(i).barcode,barcode)
                        DB.merchandiseList(i).stockQuantity = DB.merchandiseList(i).stockQuantity+quantity;
                        DB.merchandiseList(i).name = name;
                        DB.merchandiseList(i).cost = cost;
                        DB.merchandiseList(i).price = price;
                        DB.merchandiseList(i).unit = unit;
                    end
                end
                
                quantity = DB.getQuantity(barcode);
                DB.recordChange(barcode,quantity,cost,price,MerchandiseEvent.putIn);
            end
        end
        
        function editQuantity(DB,barcode,quantity,event)
            % event is either edit or sell
            for i=1:length(DB.merchandiseList)
                if isequal(DB.merchandiseList(i).barcode,barcode)
                    DB.merchandiseList(i).stockQuantity = DB.merchandiseList(i).stockQuantity+quantity;
                    
                    price = DB.merchandiseList(i).price;
                    cost = DB.merchandiseList(i).cost;
                    
                    if event == MerchandiseEvent.editQuantity
                        DB.recordChange(barcode,DB.merchandiseList(i).stockQuantity,cost,price,event);
                    else
                        DB.recordChange(barcode,quantity,cost,price,event);
                    end
                    
                    return;
                end
            end
        end
        
        function editInfo(DB,barcode,name,cost,price,unit)
            for i=1:length(DB.merchandiseList)
                if isequal(DB.merchandiseList(i).barcode,barcode)
                    DB.recordChange(barcode,0,cost,price,MerchandiseEvent.editInfo);
                    
                    DB.merchandiseList(i).name = name;
                    DB.merchandiseList(i).cost = cost;
                    DB.merchandiseList(i).price = price;
                    DB.merchandiseList(i).unit = unit;
                    return;
                end
            end
        end
        
        function result = getName(DB,barcode)
            for i=1:length(DB.merchandiseList)
                if isequal(DB.merchandiseList(i).barcode,barcode)
                    result = DB.merchandiseList(i).name;
                    return;
                end
            end
        end
        
        function result = getPrice(DB,barcode)
            for i=1:length(DB.merchandiseList)
                if isequal(DB.merchandiseList(i).barcode,barcode)
                    result = DB.merchandiseList(i).price;
                    return;
                end
            end
        end
        
        function result = getCost(DB,barcode)
            for i=1:length(DB.merchandiseList)
                if isequal(DB.merchandiseList(i).barcode,barcode)
                    result = DB.merchandiseList(i).cost;
                    return;
                end
            end
        end
        
        function result = getUnit(DB,barcode)
            for i=1:length(DB.merchandiseList)
                if isequal(DB.merchandiseList(i).barcode,barcode)
                    result = DB.merchandiseList(i).unit;
                    return;
                end
            end
            result = -1;
        end
        
        function recordChange(DB,barcode,quantity,cost,price,event)
            % quantity is the new stock quantity
            t = datetime('now','TimeZone','local','Format','uuuu-MM-dd HH:mm:ss');
            switch event
                case MerchandiseEvent.putIn
                    amountRecord = MerchandiseUpdate(barcode,quantity,t,event);
                    costRecord = MerchandiseUpdate(barcode,cost,t,event);
                    priceRecord = MerchandiseUpdate(barcode,price,t,event);
                    profitRecord = MerchandiseUpdate(barcode,price-cost,t,event);
                    
                    DB.amountChangeList = [DB.amountChangeList,amountRecord];
                    DB.costChangeList = [DB.costChangeList,costRecord];
                    DB.priceChangeList = [DB.priceChangeList,priceRecord];
                    DB.profitChangeList = [DB.profitChangeList,profitRecord];
                    
                case MerchandiseEvent.editInfo
                    profitRecord = MerchandiseUpdate(barcode,price-cost,t,event);
                    DB.profitChangeList = [DB.profitChangeList,profitRecord];

                    costRecord = MerchandiseUpdate(barcode,cost,t,event);
                    DB.costChangeList = [DB.costChangeList,costRecord];

                    priceRecord = MerchandiseUpdate(barcode,price,t,event);
                    DB.priceChangeList = [DB.priceChangeList,priceRecord];
                       
                case MerchandiseEvent.editQuantity
                    amountRecord = MerchandiseUpdate(barcode,quantity,t,event);
                    DB.amountChangeList = [DB.amountChangeList,amountRecord];

                case MerchandiseEvent.sell
                    for i=1:length(DB.merchandiseList)
                        if isequal(DB.merchandiseList(i).barcode,barcode)
                            stockQuantity = DB.merchandiseList(i).stockQuantity;
                            break;
                        end
                    end
                    
                    amountRecord = MerchandiseUpdate(barcode,stockQuantity,t,event);
                    DB.amountChangeList = [DB.amountChangeList,amountRecord];
                    
                    salesRecord = SalesRecord(barcode,-quantity,price,cost,t);
                    DB.salesRecordList = [DB.salesRecordList,salesRecord];
            end
        end
        
    end
    
end

