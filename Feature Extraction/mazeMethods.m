% Author: Atanu Giri
% Date: 11/17/2023

function mazeMethods(mazeIndex,feeder,zoneSize,feederSize)
%
% This method chooses the maze in which the trial is taking place. Then it
% shades the feeder zones; highlight the offer and central zone in that maze
%
% mazeIndex = 2; feeder = 1;

if nargin < 4
        feederSize = 0.25; % Default value if not provided
end

grayFace = [0.3 0.3 0.3 0.3]; yellowFace = [1 1 0 0.3];
xWidth = (feederSize+0.05); yWidth = xWidth;

switch mazeIndex
    case 1
        % Maze2 a.k.a 1st quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[(1-feederSize) -0.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r2 = rectangle('Position',[-0.05 -0.05 xWidth yWidth], ...
            'EdgeColor','none', 'FaceColor',grayFace);
        r3 = rectangle('Position',[-0.05 (1-feederSize) xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r4 = rectangle('Position',[(1-feederSize) (1-feederSize) xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        
        xMid = 0.5; yMid = 0.5;
        helperPlot;

    case 2
        % Maze1 a.k.a 2nd quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[-1.05 (1-feederSize) xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r2 = rectangle('Position',[-1.05 -0.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r3 = rectangle('Position',[-feederSize -0.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r4 = rectangle('Position',[-feederSize (1-feederSize) xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        
        xMid = -0.5; yMid = 0.5;
        helperPlot;

    case 3
        % Maze3 a.k.a 3rd quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[-feederSize -1.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r2 = rectangle('Position',[-feederSize -feederSize xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r3 = rectangle('Position',[-1.05 -feederSize xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r4 = rectangle('Position',[-1.05 -1.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        
        xMid = -0.5; yMid = -0.5;
        helperPlot;

    case 4
        % Maze4 a.k.a 4th quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[-0.05 -feederSize xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r2 = rectangle('Position',[(1-feederSize) -feederSize xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r3 = rectangle('Position',[(1-feederSize) -1.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r4 = rectangle('Position',[-0.05 -1.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);

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
