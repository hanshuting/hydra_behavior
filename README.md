# hydra_behavior
This project provides a tool for classifying Hydra behaviors with computer vision methods. For details about the method, see Han et al. [1].

## Overview
This is an automated behavior analysis method developed for _Hydra vulgaris_, using an adapted Bag-of-Words (BoW) framework. Briefly, this method consists of the following steps:
1. Video pre-processing -- Segment the hydra from background, fit hydra to an ellipse, segment the hydra to three body parts (tentacles, upper body, lower body), rotate the hydra region to a vertical position, scale it to a normalized length, and generate short video clips of user-specified length (5 seconds by default).
2. Feature extraction -- Using dense trajectories tool to extract video features including Histogram of Optical Flow (HOF), Histogram of Oriented Gradients (HOG) and Motion Boundary Histogram (MBH).
3. Codebook generation -- Using Gaussian Mixture Models (GMM) to generate a codebook of Gaussian Mixtures with user-specified number.
4. Feature encoding -- Encode the extracted features with GMM codebook using Fisher Vectors.
5. Classification -- Train SVM classifiers with manual labels to classify pre-defined behavior types.
6. t-SNE embedding -- Embed the high-dimensional Fisher Vectors to a 2D space, and discover behavior types in an unsupervised manner.

## Compilation
### Dense trajectories
The first thing that needs to be compiled is the dense trajectory package. Please follow instructions on this page: https://lear.inrialpes.fr/people/wang/dense_trajectories. Basically, you need to compile first OpenCV and ffmpeg, then the dense trajectories package.

The compile parameters we used in this project are as following:
```
int start_frame = 0;
int end_frame = INT_MAX;
int scale_num = 8;
const float scale_stride = sqrt(2);

// parameters for descriptors
int patch_size = 32;
int nxy_cell = 2;
int nt_cell = 3;
float epsilon = 0.05;
const float min_flow = 0.4;

// parameters for tracking
double quality = 0.01; //default 0.001
int min_distance = 5;
int init_gap = 1;
int track_length = 15;

// parameters for rejecting trajectory
const float min_var = 0.1; //default sqrt(3)
const float max_var = 50; //default 50
const float max_dis = 50; //default 20
```

### Fisher vector
INRIA's Fisher vector implementation could be found here: https://lear.inrialpes.fr/src/inria_fisher/.

### libSVM
You will also need to compiles the libSVM package for training SVM classifiers. Please follow the instructions here: https://www.csie.ntu.edu.tw/~cjlin/libsvm/.

## File organization
### Working directories
By default, the code operates on a base folder specified by `param.pbase`. Path to the videos is specified by `param.dpath`. The current run is specified by a data string in `param.datastr`, so that each run with a different parameter/data set will be processed separately. The code will then create several different directories under the base folder, including `seg` (segmentation results), `segvid` (segmented videos), `dt` (dense trajectory results), `fv` (Fisher vectors), `svm` (SVM training results), `tsne` (t-SNE embedding results), and `param` (parameters used in the current run). For SVM training, path to the annotation files are specified in `param.annopath`, where each file should be a `.mat` file and contain a variable named `anno`. This `anno` variable should be a column vector containing discrete integer labels of behavior types.

### Input format
For the ease of testing with different files, we arranged input video files using a script `data_info\fileinfo.m`. This file contains the video information of all the files that are to be analyzed, including file name, number of frames, frames per second, and image size. Please add a new entry to this file for each video.

## Classifying Hydra behavior
To train new classifiers, run script `main_analysis.m` with desired parameters in the parameter code block. 

**_[Fix this]_** Due to the limitation of dense trajactories package, this code could only run from linux environment at this moment. Once you start a Matlab session from the terminal, call `main_analysis.m`, and it will automatically create all necessary paths, do segmentation, registration and generate registered video clips, and write a bash script for running the dense trajectory package. However, the code will pause here, and you will need to go to the DT script and manually run it from the bash. After the DT script finishes running, please go back to Matlab and type "dbcont" to continue the main script.

To run classifiers on new videos, run script `main_analysis_new.m` and modify `param.mstr` to match the datastr of the classifiers. Also please modify `param.dpath` which specifies the data path and `param.pbase` which specifies where the results would be saved.

**_[Add a demo file]_**

## Options
All the options can be changed in the `param` structure.

### File information
fileIndx -- Video files to be analyzed, see script `data_info\fileinfo.m` for more information.

trainIndx -- Video files used for training SVM and generating embedding space.

testIndx -- Video files used as withheld test sample for SVM and embedding.

datastr -- An experiment date or any unique ID that you can use to identify each run of the code.

dpathbase -- Data path base **_[Fix]_**

pbase -- Path to where the results will be saved.

### Segmentation
seg.outputsz -- Size (in pixels) of the video clips generated by the code, which will be the input of the following DT step.

seg.ifscale -- 1 if normalize the length of the hydra, 0 otherwise.

### Fisher vectors
fv.K -- Number of GMMs to be generated.

fv.ci -- percentage of variance to be kept when doing PCA on the FVs

fv.intran -- 1 if apply intra normalization, 0 otherwise

fv.powern -- 1 if apply power normalization, 0 otherwise

### SVM
svm.src -- Path to the compiled libsvm package.

svm.percTrain -- Percentage of training samples

svm.kernel -- Type of kernel to use in SVM: 0, linear; 1, polynomial; 2, RBF; 3, sigmoid.


## Reference
[1] Shuting Han, Ekaterina Taralova, Christophe Dupre, Rafael Yuste. Comprehensive machine learning analysis of Hydra behavior reveals a stable behavioral repertoire. eLife 2018;7:e32605 DOI: 10.7554/eLife.32605
