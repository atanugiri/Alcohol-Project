id = 4985;


[accOutlierMoveMedian,jerkOutlierMoveMedian, h1, accOutlierTime] = ...
    accelerationAndJerkOulierFun(id);
set(gcf, 'Windowstyle', 'docked');
h2 = trajectoryPlot(id, accOutlierTime);
set(gcf, 'Windowstyle', 'docked');
