#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>

using namespace cv;
using namespace std;

bool isInside(const Mat_<uchar> &img, int i, int j) {
    return i >= 0 && i < img.rows && j >= 0 && j < img.cols;
}

long long computeCensusTransformBitArray(const Mat_<uchar> &img, int i, int j) {
    long long bitArray = 0;
    int di[7] = {-3, -2, -1, 0, 1, 2, 3};
    int dj[9] = {-4, -3, -2, -1, 0, 1, 2, 3, 4};

    for (int k = 0; k < 7; k++) {
        for (int l = 0; l < 9; l++) {
            if (!(k == (i + di[k]) && l == (j + dj[l]))) {
                if (isInside(img, i + di[k], j + dj[l])) {
                    bitArray += (img(i + di[k], j + dj[l]) < img(i, j)) ? 1 : 0;
                    bitArray <<= 1;
                }
            }
        }
    }
    return bitArray;
}

int countSetBits(long long n) {
    int count = 0;
    int nb = 63;
    while (nb--) {
        count += n & 1;
        n >>= 1;
    }
    return count;
}

int computeHammingDistance(long long bitsValueR, long long bitsValueL) {
    int countDifferentBits = 0;

    countDifferentBits = countSetBits(bitsValueL ^ bitsValueR);
    return countDifferentBits;
}

Mat_<uchar> computeDisparityMap(Mat_<uchar> imgR, Mat_<uchar> imgL) {
    Mat_<uchar> disparityMap(imgL.rows, imgL.cols);
    int census_height = 7;
    int census_width = 9;
    int dims[] = {imgR.rows, imgR.cols, imgR.cols};

    Mat_<int> C = Mat(3, dims, CV_8UC1);
    Mat_<int> S = Mat(3, dims, CV_8UC1);

    for (int i = 0; i < imgL.rows; i++) {
        for (int j = 0; j < imgL.cols; j++) {
            for (int d = 1; d <= 50; d++) {
                if (i >= census_height && i <= imgL.rows - census_height && j >= census_width &&
                    j <= imgL.cols - census_width
                    && j - d >= census_width && j - d <= imgL.cols - census_width)
                    C(i, j, d) = computeHammingDistance(computeCensusTransformBitArray(imgL, i, j),
                                                        computeCensusTransformBitArray(imgR, i, j - d));
                else C(i, j, d) = 0;
            }
        }
    }
    for (int i = census_height; i < disparityMap.rows - census_height; i++) {
        for (int j = census_width; j < disparityMap.cols - census_width; j++) {
            int min = INT_MAX, min_d = 0;
            for (int d = 1; d <= 50; d++) {
                int sum = 0;
                for (int z = -5; z < 5; z++) {
                    for (int w = -5; w < 5; w++) {
                        sum += C(i + z, j + w, d);
                    }
                }
                S(i, j, d) = sum;
                if (sum < min) {
                    min = sum;
                    min_d = d;
                }
            }
            disparityMap(i, j) = min_d; //round(((min_d - 1) * 255) / 49);
        }
    }
    return disparityMap;
}

void swap(int *xp, int *yp) {
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}

void sort(int arr[], int n) {
    int i, j;
    for (i = 0; i < n - 1; i++)
        for (j = 0; j < n - i - 1; j++)
            if (arr[j] > arr[j + 1])
                swap(&arr[j], &arr[j + 1]);
}

Mat_<uchar> medianFilter(Mat_<uchar> img, int w) {
    Mat_<uchar> dst(img.rows, img.cols);
    int *orderedStatistic = new int[w * w];

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            int nb_elems = 0;
            for (int u = 0; u < w; u++) {
                for (int v = 0; v < w; v++) {
                    if (isInside(img, i + u - w / 2, j + v - w / 2)) {
                        orderedStatistic[nb_elems++] = img(i + u - w / 2, j + v - w / 2);
                    }
                }
            }
            sort(orderedStatistic, nb_elems);
            dst(i, j) = orderedStatistic[nb_elems / 2];
        }
    }
    return dst;
}

float computeError(Mat_<uchar> img, Mat_<uchar> groundTruth){
    float diff = 0;

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
        if(abs(img(i,j) - groundTruth(i,j)/4) > 2){
            diff++;
        }
    }
}
    return diff/(float)(img.rows * img.cols);
}

int main() {
    Mat_<uchar> imgR = imread("Images/teddyimR.png", CV_LOAD_IMAGE_GRAYSCALE);
    Mat_<uchar> imgL = imread("Images/teddyimL.png", CV_LOAD_IMAGE_GRAYSCALE);
    Mat_<uchar> imgGT = imread("Images/teddyDispL.png", CV_LOAD_IMAGE_GRAYSCALE);
    Mat_<uchar> disparityMap(imgR.rows, imgR.cols);
    Mat_<uchar> disparityMapFiltered(imgR.rows, imgR.cols);

    imshow("Original image right", imgR);
    imshow("Original image left", imgL);
    imshow("Original image gt", imgGT);

    disparityMap = computeDisparityMap(imgR, imgL);
    imshow("Disparity map", disparityMap);

    int w = 10;
    disparityMapFiltered = medianFilter(disparityMap, w);
    imshow("Disparity map filtered", disparityMapFiltered);

    cout << " Error: " << computeError(disparityMapFiltered, imgGT) << endl;
    cout << " Error: " << computeError(disparityMap, imgGT);

    cout << imgGT;
    waitKey(0);

    return 0;
}