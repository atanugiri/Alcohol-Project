% Author: Atanu Giri
% Date: 12/01/2022
% This method chooses the maze in which the trial is taking place. Then it
% shades the feeder zones; highlight the offer and central zone in that maze

function mazeMethods(mazeIndex,feeder,zoneSize)
% mazeIndex = 2; feeder = 1;
grayFace = [0.3 0.3 0.3 0.3]; yellowFace = [1 1 0 0.3];
switch mazeIndex
    case 1
        % Maze2 a.k.a 1st quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[0.75 -0.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r2 = rectangle('Position',[-0.05 -0.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r3 = rectangle('Position',[-0.05 0.75 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r4 = rectangle('Position',[0.75 0.75 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        
        xMid = 0.5; yMid = 0.5;
        helperPlot;

    case 2
        % Maze1 a.k.a 2nd quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[-1.05 0.75 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r2 = rectangle('Position',[-1.05 -0.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r3 = rectangle('Position',[-0.25 -0.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r4 = rectangle('Position',[-0.25 0.75 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        
        xMid = -0.5; yMid = 0.5;
        helperPlot;

    case 3
        % Maze3 a.k.a 3rd quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[-0.25 -1.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r2 = rectangle('Position',[-0.25 -0.25 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r3 = rectangle('Position',[-1.05 -0.25 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r4 = rectangle('Position',[-1.05 -1.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        
        xMid = -0.5; yMid = -0.5;
        helperPlot;

    case 4
        % Maze4 a.k.a 4th quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[-0.05 -0.25 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r2 = rectangle('Position',[0.75 -0.25 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r3 = rectangle('Position',[0.75 -1.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);
        r4 = rectangle('Position',[-0.05 -1.05 0.3 0.3],'EdgeColor','none', ...
            'FaceColor',grayFace);

        xMid = 0.5; yMid = -0.5;
        helperPlot;

    otherwise
        warning('Unexpected maze number.')
end

%% Description of helperPlot
    function helperPlot
        r = [r1,r2,r3,r4];
        set(r(feeder),'FaceColor', yellowFace);
        x1 = xMid - zoneSize/2; y1 = yMid - zoneSize/2;
        rectangle('Position',[x1 y1 zoneSize zoneSize],'EdgeColor','none', ...
            'FaceColor',[1 0 0 0.2]);
    end
end
