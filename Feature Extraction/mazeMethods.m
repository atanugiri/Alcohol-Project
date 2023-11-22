% Author: Atanu Giri
% Date: 11/17/2023

function mazeMethods(mazeIndex,feederSize,zoneSize,feeder)
%
% This method chooses the maze in which the trial is taking place. Then it
% shades the feeder zones; highlight the offer and central zone in that maze
%
% mazeIndex = 1; feederSize = 0.20; feeder = 1; zoneSize = 0.5;

if nargin < 4
    feeder = []; % Default value if not provided
end

if nargin < 3
    zoneSize = []; % Default value if not provided
end

if nargin < 2
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
        try
            % Shade central zone
            x1 = xMid - zoneSize/2; y1 = yMid - zoneSize/2;
            rectangle('Position',[x1 y1 zoneSize zoneSize],'EdgeColor','none', ...
                'FaceColor',[1 0 0 0.2]);

            helperPlot;
        catch
            sprintf("Error");
        end

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
        try
            % Shade central zone
            x1 = xMid - zoneSize/2; y1 = yMid - zoneSize/2;
            rectangle('Position',[x1 y1 zoneSize zoneSize],'EdgeColor','none', ...
                'FaceColor',[1 0 0 0.2]);

            helperPlot;
        catch
            sprintf("Error");
        end

    case 3
        % Maze3 a.k.a 3rd quadrant
        % rectangles are denoted according to feeder numbers in this maze
        r1 = rectangle('Position',[-feederSize -1.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r2 = rectangle('Position',[-1.05 -1.05 xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r3 = rectangle('Position',[-1.05 -feederSize xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);
        r4 = rectangle('Position',[-feederSize -feederSize xWidth yWidth], ...
            'EdgeColor','none','FaceColor',grayFace);

        xMid = -0.5; yMid = -0.5;
        try
            % Shade central zone
            x1 = xMid - zoneSize/2; y1 = yMid - zoneSize/2;
            rectangle('Position',[x1 y1 zoneSize zoneSize],'EdgeColor','none', ...
                'FaceColor',[1 0 0 0.2]);

            helperPlot;
        catch
            sprintf("Error");
        end

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
        
        try
            % Shade central zone
            x1 = xMid - zoneSize/2; y1 = yMid - zoneSize/2;
            rectangle('Position',[x1 y1 zoneSize zoneSize],'EdgeColor','none', ...
                'FaceColor',[1 0 0 0.2]);

            helperPlot;
        catch
            sprintf("Error");
        end

    otherwise
        warning('Unexpected maze number.')
end

%% Description of helperPlot
    function helperPlot
        r = [r1,r2,r3,r4];

        % Add text to rectangles
        textPositions = [
            r1.Position(1)+xWidth/2,  r1.Position(2)+yWidth/2;
            r2.Position(1)+xWidth/2,  r2.Position(2)+yWidth/2;
            r3.Position(1)+xWidth/2,  r3.Position(2)+yWidth/2;
            r4.Position(1)+xWidth/2,  r4.Position(2)+yWidth/2;
            ];

        textLabels = {'9%', '5%', '2%', '0.5%'};

        for i = 1:4
            text(textPositions(i, 1), textPositions(i, 2), textLabels{i}, ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                'Color', 'r', 'FontWeight', 'bold');
        end

        % Shade reward
        set(r(feeder),'FaceColor', yellowFace);
    end
end
