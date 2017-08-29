function [findx,dpath] = bhv_data_info(num)
% A REFERENCE FUNCTION OF THE INFORMATION OF THE COLLECTED BEHAVIOR DATASET
% The first file of all long recordings are removed from indices

switch num
    % vulgaris, dark, fed, medium/small size, long
    case 1
        findx = {(1449:1455)',(1457:1463)',(1465:1470)',(1472:1476)',(1478:1484)',(1485:1491)'};
        dpathbase = 'C:\Shuting\Projects\hydra behavior\results\dark_light\svm\';
        dpath = {[dpathbase '20170501\'],[dpathbase '20170501\'],...
            [dpathbase '20170501\'],[dpathbase '20170501\'],...
            [dpathbase '20170501\'],[dpathbase '20170501\']};
    % vulgaris, light, fed, medium/small size, long
    case 2 
        findx = {(1402:1408)',(1410:1416)',(1418:1424)',(1427:1431)',(1433:1434)',(1436:1441)',(1443:1447)'};
        dpathbase = 'C:\Shuting\Projects\hydra behavior\results\dark_light\svm\';
        dpath = {[dpathbase '20170501\'],[dpathbase '20170501\'],[dpathbase '20170501\'],...
            [dpathbase '20170501\'],[dpathbase '20170501\'],[dpathbase '20170501\'],...
            [dpathbase '20170501\']};
    % viridissima, dark, starved, small size, long
    case 3 
        findx = {(761:764)',(766:769)',(771:776)',(779:782)',(785:789)'};
        dpath = repmat({'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\20170209\'},1,5);
    % viridissima, light, fed, small size, long
    case 4 
        findx = {(1302:1308)',(1310:1314)',(1316:1322)',(1324:1329)',(1331:1338)'};
        dpath = {'C:\Shuting\Projects\hydra behavior\results\viridissima\svm\',...
            'C:\Shuting\Projects\hydra behavior\results\viridissima\svm\',...
            'C:\Shuting\Projects\hydra behavior\results\viridissima\svm\',...
            'C:\Shuting\Projects\hydra behavior\results\viridissima\svm\',...
            'C:\Shuting\Projects\hydra behavior\results\viridissima\svm\'};
    % vulgaris, light, starved, medium/small size (?), long
    case 5 
        findx = {(622:627)',(630:635)',(646:651)',(674:678)',(688:693)',(704:709)'};
        dpathbase = 'C:\Shuting\Projects\hydra behavior\results\long_recording\svm\';
        dpath = {[dpathbase '20161026\'],[dpathbase '20161105\'],...
            [dpathbase '20161110\'],[dpathbase '20161203\hydra1\'],...
            [dpathbase '20161203\hydra2\'],[dpathbase '20161211\']};
    % vulgaris, light, starved, big, short
    case 6 
        findx = num2cell(1126:1134)';
        dpath = repmat({'C:\Shuting\Projects\hydra behavior\results\starved_light\svm\'},1,9);
    % vulgaris, light, fed, big, short
    case 7 
        findx = num2cell([1114,1118,1119,1121:1123,1125])';
        dpath = repmat({'C:\Shuting\Projects\hydra behavior\results\big_small_fed\svm\20170301\'},1,7);
    % vulgaris, light, fed, small, short
    case 8
        findx = num2cell(1104:1113)';
        dpath = repmat({'C:\Shuting\Projects\hydra behavior\results\big_small_fed\svm\20170301\'},1,10);
    otherwise
        error('Incorrect behavior dataset index')
end