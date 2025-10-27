<img width="641" height="1126" alt="482868814-ba9ea9b5-dd7d-446e-9853-80ddb86b3638" src="https://github.com/user-attachments/assets/a0b16cee-980b-4f34-98b8-2c2304191ba8" />markdown
# Real-Time Moving Object Detection and Background Removal in Video Streams

![MATLAB](https://img.shields.io/badge/MATLAB-R2020a%2B-blue)
![Computer Vision](https://img.shields.io/badge/Computer-Vision-green)
![Project](https://img.shields.io/badge/Project-Academic-orange)

A MATLAB-based implementation of real-time moving object detection and background removal system for video surveillance applications.

## Project Overview

This project implements a robust moving object detection system using background subtraction techniques in MATLAB. The system can detect and track moving objects (primarily humans) in real-time video streams while effectively removing the background for enhanced visualization.

## Key Features

- **Real-time Motion Detection**: Uses background subtraction with dynamic thresholding
- **Background Elimination**: Removes static background while preserving moving objects
- **Human Detection**: Identifies humans using height-to-width ratio analysis
- **Morphological Filtering**: Reduces noise and enhances object detection
- **Adaptive Background Update**: Continuously updates background model for changing environments
- **Multiple Object Tracking**: Capable of detecting and tracking multiple moving objects

## Technical Implementation

### Core Algorithms
- **Background Subtraction Method**: Pixel-by-pixel comparison with reference background
- **Mean Squared Error (MSE) Thresholding**: For block-based background identification
- **Morphological Operations**: Erosion, dilation, and closing for noise reduction
- **Blob Analysis**: Connected component analysis for object identification
- **Dynamic Thresholding**: Adaptive to lighting changes

### System Architecture
1. **Frame Separation** - Extract and preprocess video frames
2. **Background Modeling** - Create and maintain reference background
3. **Motion Detection** - Identify moving regions using temporal differencing
4. **Object Classification** - Human detection using shape-based analysis
5. **Background Elimination** - Remove static background elements


<img width="641" height="1126" alt="482868814-ba9ea9b5-dd7d-446e-9853-80ddb86b3638" src="https://github.com/user-attachments/assets/b5804c13-7f19-4675-bec1-0a5672fd8bc8" />

## Performance Results

| Test Case | Success Rate |
|-----------|-------------|
| Single Person Detection |  100% |
| Body Pose Changes |  100% |
| Multiple Persons |  100% |
| Half-body Detection |  100% |
| Shadow Elimination |  50% |
| Moving Camera |  0% |

**Overall System Efficiency: 87.5%**
<img width="615" height="362" alt="482868898-0e14a0ae-f500-4163-922a-80f97c1ebc6a" src="https://github.com/user-attachments/assets/25a85450-31be-4b7d-9771-169014865587" />

## Installation & Usage

### Prerequisites
- MATLAB R2020a or later
- Computer Vision Toolbox
- Image Processing Toolbox
