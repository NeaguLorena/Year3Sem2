#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
//#include "Functions.h"

using namespace cv;
using namespace std;

bool isInside(const Mat &img, int i, int j) {
    return i >= 0 && i < img.rows && j >= 0 && j < img.cols;
}

void neighbourhoodPixel63(Mat_<uchar> img, int i, int j, Point2i *neighbors) {
    int d[8] = {-4, -3, -2, -1, 0, 1, 2, 3};
    int pos = 0;
    for (int k = 0; k < 8; k++) {
        for (int l = 0; l < 8; l++) {
            if (!(k == 4 && k == l)) {
                if (isInside(img, i + d[k], j + d[l])) {
                    neighbors[pos++] = Point2i(i + d[k], j + d[l]);
                } else neighbors[pos++] = Point2i(-1, -1);
            }
        }
    }
}

long long computeCensusTransformBitArray(Mat_<uchar> img, int i, int j) {
    Point2i neighbors[63];
    long long bitArray = 0;
    neighbourhoodPixel63(img, i, j, neighbors);
    int power = 0;
    for (int k = 62; k >= 0; k--) {
        if (neighbors[k] != Point2i(-1, -1)) {
            int n = (img(neighbors[k].x, neighbors[k].y) > img(i, j)) ? 1 : 0;
            bitArray += n * pow(2, power);
        }
        power++;
    }
    return bitArray;
}

int computeHammingDistance(long long bitsValueR, long long bitsValueL) {
    int countDifferentBits = 0;
    unsigned long long mask = 4611686018427387904;   //mask = [100000000000000000000000000000000000000000000000000000000000000] //63 bits

    while (mask > 0) {
        if ((bitsValueL & mask) != (bitsValueR & mask))
            countDifferentBits++;
        mask = mask >> 1;
    }
    return countDifferentBits;
}

Mat_<uchar> computeDisparityMap(Mat_<uchar> imgR, Mat_<uchar> imgL) {
    Mat_<uchar> disparityMap(imgL.rows, imgL.cols);

    int dims[] = {imgR.rows, imgR.cols, imgR.cols};

    Mat_<int> C = Mat(3, dims, CV_8UC1);
    Mat_<int> S = Mat(3, dims, CV_8UC1);

    for (int i = 0; i < imgR.rows; i++) {
        for (int j = 0; j < imgR.cols; j++) {
            for (int d = 0; d <= j; d++) {
                C(i, j, d) = computeHammingDistance(computeCensusTransformBitArray(imgL, i, j),
                                                    computeCensusTransformBitArray(imgR, i, j - d));
            }
        }
    }
    for (int i = 0; i < imgR.rows; i++) {
        for (int j = 0; j < imgR.cols; j++) {
            int min = j + 1, min_d = 0;
            for (int d = 0; d < j; d++) {
                int sum = 0;
                for (int w = -5; w < 5; w++) {
                    sum += C(i + w, j + w, d);
                }
                S(i, j, d) = sum;
                if (sum < min) {
                    min = sum;
                    min_d = d;
                }
            }
            if (min_d > 255)
                min_d = 255;
            disparityMap(i, j) = min_d;
        }
    }
    return disparityMap;
}

int main() {
    Mat_<uchar> imgR = imread("Images/conesimR.png", CV_LOAD_IMAGE_GRAYSCALE);
    Mat_<uchar> imgL = imread("Images/conesimL.png", CV_LOAD_IMAGE_GRAYSCALE);
    Mat_<uchar> imgH(imgR.rows, imgR.cols);

    imshow("Original image right", imgR);
    imshow("Original image left", imgL);

    imgH = computeDisparityMap(imgR, imgL);

    imshow("Hamming distance image result", imgH);

    waitKey(0);

    return 0;
}