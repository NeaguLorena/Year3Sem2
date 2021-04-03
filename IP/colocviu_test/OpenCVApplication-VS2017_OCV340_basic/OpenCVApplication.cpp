// OpenCVApplication.cpp : Defines the entry point for the console application.
//

#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;
using namespace std;

bool isInside(const Mat &img, int i, int j) {
    return i >= 0 && i < img.rows && j >= 0 && j < img.cols;
}

void neighbourhoodPixel8(Mat_<uchar> img, int i, int j, Point2i *neighbors) {
    int size = 0;
    for (int k = -2; k <= 2; k++){
        for (int l = -2; l<= 2; l++){
            if (isInside(img, i + k, j + l)) {
                neighbors[size++] = Point2i(i + k, j + l);
            } else neighbors[size++] = Point2i(-1, -1);
        }
    }
}

Mat_<int> CCLabelling(Mat_<uchar> img, int &label) {

    std::queue<Point2i> Q;
    label = 0;
    Mat_<int> labels(img.rows, img.cols);
    Point2i neighbors[25];

    for (int i = 0; i < labels.rows; i++) {
        for (int j = 0; j < labels.cols; j++) {
            labels(i, j) = 0;
        }
    }

    for (int i = 0; i < labels.rows; i++) {
        for (int j = 0; j < labels.cols; j++) {
            if (img(i, j) == 0 && labels(i, j) == 0) {
                label++;
                labels(i, j) = label;
                Q.push({i, j});
                while (!Q.empty()) {
                    Point2i q = Q.front();
                    Q.pop();
                    neighbourhoodPixel8(img, q.x, q.y, neighbors);
                    for (int k = 0; k < 25; k++) {
                        if (neighbors[k] != Point2i(-1, -1) && img(neighbors[k].x, neighbors[k].y) == 0 &&
                            labels(neighbors[k].x, neighbors[k].y) == 0) {
                            labels(neighbors[k].x, neighbors[k].y) = label;
                            Q.push(neighbors[k]);
                        }
                    }
                }
            }
        }
    }
    return labels;
}

void createimage(){
    Mat_<uchar> img(512, 1024);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            img(i,j) = 255;
        }
    }
    for(int i = 0;i < img.cols; i++ ){
        img(10,i) = 128;
    }
    imshow(" Image", img);

}
int main() {
    Mat_<uchar> img = imread("Images/cameraman.bmp", CV_LOAD_IMAGE_GRAYSCALE);
    imshow("Original Image", img);
    createimage();
    waitKey(0);
}