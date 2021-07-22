function genDic(obj,dist,max_an_mag)
% generate searching dictionary
% dist: separation of magnitude of an
% max_an_mag: maximum magnitude of an, max_an_mag should be smaller than 1.
    if dist<0 || dist>1
        obj.addLog('error: Because the specific dist is unknown, genDic is not successful.')
        error('Because the specific dist is unknown, genDic is not successful.')
    end
    
    if max_an_mag<0 || max_an_mag>1
        obj.addLog('error: Because the specific max_an_mag is unknown, genDic is not successful.')
        error('Because the specific max_an_mag is unknown, genDic is not successful.')
    end
    
    obj.time_genDic=zeros(size(obj.G,1),1);
    switch obj.decompMethod
        case 'Single Channel Conventional AFD'
            switch obj.dicGenMethod
                case 'square'
                    for ch_i=1:size(obj.G,1)
                        tic
                        obj.dic_an{ch_i,1} = obj.Unit_Disk(dist,max_an_mag);
                        obj.time_genDic(ch_i,1)=toc;
                    end
                case 'circle'
                    K = size(obj.G,2);
                    for ch_i=1:size(obj.G,1)
                        tic
                        obj.dic_an{ch_i,1} = obj.Circle_Disk(dist,max_an_mag,0:2*pi/K:(2*pi-2*pi/K));
                        obj.time_genDic(ch_i,1)=toc;
                    end
            end
        case 'Single Channel Fast AFD'
            switch obj.dicGenMethod
                case 'square'
                    obj.addLog('error: Because dicGenMethod is not correct (fast AFD only can use "circle"), genDic is not successful.')
                    error('Because dicGenMethod is not correct (fast AFD only can use "circle"), genDic is not successful.')
                case 'circle'
                    K = size(obj.G,2);
                    for ch_i=1:size(obj.G,1)
                        tic
                        cont = max_an_mag;
                        abs_a=0:dist:1;
                        abs_a(abs(abs_a) >= cont) = [];
                        obj.dic_an{ch_i,1} = abs_a;
                        obj.time_genDic(ch_i,1)=toc;
                    end
            end
    end
    
    obj.addLog('generate searching dictionary successfully.')
end