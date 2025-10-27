% Task 1: Read the video
videoFile = 'project.mp4'; % Replace with your video file path
videoObj = VideoReader(videoFile);

% Initialize the foreground detector
foregroundDetector = vision.ForegroundDetector('NumGaussians', 5, ...
    'NumTrainingFrames', 100, 'MinimumBackgroundRatio', 0.5, 'LearningRate', 0.005);

% Initialize the blob analysis object
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 500);

% Create a video player to display the video frames
videoPlayer = vision.VideoPlayer;

% Create a video writer object to save the output video
outputVideo = VideoWriter('output.mp4', 'MPEG-4');
open(outputVideo);

% Read the first frame and use it as the initial background model
backgroundFrame = readFrame(videoObj);
[height, width, ~] = size(backgroundFrame);

% Ensure the number of blocks is an integer
numBlocksHeight = floor(height / 16);
numBlocksWidth = floor(width / 16);

% Adjust the frame size to be divisible by the block size
adjustedHeight = numBlocksHeight * 16;
adjustedWidth = numBlocksWidth * 16;
backgroundFrame = backgroundFrame(1:adjustedHeight, 1:adjustedWidth, :);

% Divide the first frame into blocks
backgroundBlocks = mat2cell(backgroundFrame, repmat(16, 1, numBlocksHeight), repmat(16, 1, numBlocksWidth), 3);

% Initialize the background model
backgroundModel = zeros(size(backgroundFrame));
mseThreshold = 15; % Threshold for MSE

% Process each frame in the video
while hasFrame(videoObj)
    frame = readFrame(videoObj);
    
    % Compute the foreground mask
    foregroundMask = step(foregroundDetector, frame);
    
    % Perform morphological filtering to remove noise and fill in holes
    cleanForeground = imopen(foregroundMask, strel('Disk', 3));
    cleanForeground = imclose(cleanForeground, strel('Disk', 30));
    cleanForeground = imfill(cleanForeground, 'holes');
    
    % Find the boundaries of the foreground object
    boundingBoxes = step(blobAnalysis, cleanForeground);
    
    % Adjust the frame size to match the background model
    frame = frame(1:adjustedHeight, 1:adjustedWidth, :);
    
    % Divide the current frame into blocks
    currentFrameBlocks = mat2cell(frame, repmat(16, 1, numBlocksHeight), repmat(16, 1, numBlocksWidth), 3);
    
    % Initialize the mask for the current frame
    frameMask = zeros(adjustedHeight, adjustedWidth);
    
    % Update the background model and compare each block with the corresponding block in the background model
    for i = 1:numBlocksHeight
        for j = 1:numBlocksWidth
            % Calculate the Mean Squared Error (MSE) between blocks
            mse = immse(cell2mat(backgroundBlocks(i,j)), cell2mat(currentFrameBlocks(i,j)));
            
            % If MSE is below the threshold, mark as background
            if mse < mseThreshold
                frameMask((i-1)*16+1:i*16, (j-1)*16+1:j*16) = 1;
            else
                % Update the background model for blocks that are not part of the background
                backgroundBlocks(i,j) = currentFrameBlocks(i,j);
            end
        end
    end
    
    % Apply the mask to the current frame to eliminate the background
    frame(repmat(frameMask, [1, 1, 3]) == 1) = 255;
    
    % Draw red outlines around the detected objects
    for i = 1:size(boundingBoxes, 1)
        frame = insertShape(frame, 'Rectangle', boundingBoxes(i, :), ...
            'Color', 'red', 'LineWidth', 2);
    end
    
    % Display the result with background removed and object highlighted
    step(videoPlayer, frame);
    
    % Write the frame to the output video
    writeVideo(outputVideo, frame);
end

% Release the video player
release(videoPlayer);

% Close the output video
close(outputVideo);
