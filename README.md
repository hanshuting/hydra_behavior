# hydra_behavior
This project provides a tool for classifying Hydra behaviors with computer vision methods. For details about the method, see Han et al. [1].

## Compilation
The only thing that needs to be compiled is the dense trajectory package. Please follow instructions on [this](https://lear.inrialpes.fr/people/wang/dense_trajectories) page. Basically, you need to compile first OpenCV and ffmpeg, then the dense trajectories package.

The compile parameters we used in this project is as following:
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

## File organization
By default, the code operates on a base folder specified by `param.pbase`. Path to the videos is specified by `param.dpath`. The current run is specified by a data string in `param.datastr`, so that each run with a different parameter/data set will be processed separately. The code will then create several different directories under the base folder, including `seg` (segmentation results), `segvid` (segmented videos), `dt` (dense trajectory results), `fv` (Fisher vectors), `svm` (SVM training results), `tsne` (t-SNE embedding results), and `param` (parameters used in the current run). For SVM training, path to the annotation files are specified in `param.annopath`, where each file should be a `.mat` file and contain a variable named `anno`.
