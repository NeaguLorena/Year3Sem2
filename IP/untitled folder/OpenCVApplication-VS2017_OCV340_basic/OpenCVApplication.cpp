// OpenCVApplication.cpp : Defines the entry point for the console application.
//

#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

void showHistogram(const std::string &name, const int *hist, const int hist_cols, const int hist_height) {
    Mat imgHist(hist_height, hist_cols, CV_8UC3, CV_RGB(255, 255, 255));

    int max_hist = 0;
    for (int i = 0; i < hist_cols; i++)
        if (hist[i] > max_hist)
            max_hist = hist[i];
    double scale = 1.0;
    scale = (double) hist_height / max_hist;
    int baseline = hist_height - 1;
    for (int x = 0; x < hist_cols; x++) {
        Point p1 = Point(x, baseline);
        Point p2 = Point(x, baseline - cvRound(hist[x] * scale));
        line(imgHist, p1, p2, CV_RGB(255, 0, 255)); // histogram bins
    }

    imshow(name, imgHist);
}

int *computeHistogram(Mat_<uchar> &img) {
    int *histogram = new int[256];

    for (int i = 0; i < 256; i++) {
        histogram[i] = 0;
    }

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            histogram[img(i, j)] += 1; //used a frequency vector : pixels of same intensity are added
        }
    }
    return histogram;
}

float *computePdf(const int *histogram, Mat_<uchar> img) {
    float *pdf = new float[256];
    auto M = img.cols * img.rows;

    for (int i = 0; i < 256; i++) {
        pdf[i] = 0;
    }

    for (int i = 0; i < 256; i++) {
        pdf[i] = (float) histogram[i] / M;
    }

    return pdf;
}

void floyd_steinberg(Mat_<uchar> original) {
    //computes the quantization error and spreads it to the neighboring pixels,
    //according to the fraction matrix (from lab)
    std::vector<int> histoMaximas = computeLocalMaximas(original);
    int min, pixel, newPixel, error;

    for (int i = 0; i < original.rows; i++) {
        for (int j = 0; j < original.cols; j++) {
            pixel = original(i, j);
            min = 0;
            for (int localMaxima : histoMaximas) {
                if (abs(pixel - min) > abs(pixel - localMaxima)) {
                    min = localMaxima;
                }
            }
            newPixel = min;
            error = pixel - newPixel;

            if (isInside(original, i, j + 1)) {
                original(i, j + 1) = checkBoundaries(original(i, j + 1) + 7 * error / 16);
            }

            if (isInside(original, i + 1, j - 1)) {
                original(i + 1, j - 1) = checkBoundaries(original(i + 1, j - 1) + 3 * error / 16);
            }

            if (isInside(original, i + 1, j)) {
                original(i + 1, j) = checkBoundaries(original(i + 1, j) + 5 * error / 16);
            }

            if (isInside(original, i + 1, j + 1)) {
                original(i + 1, j + 1) = checkBoundaries(original(i + 1, j + 1) + 1 * error / 16);
            }
        }
    }
}

int *computeHistogramForGivenBins(const int *histogram, int m) {
    int *newHisto = new int[200];
    float rescale = 256 / m;
    int newI;

    for (int i = 0; i < 256; i++) {
        newHisto[i] = 0;
    }

    for (int i = 0; i < 256; i++) {
        newI = floor(i / rescale);
        newHisto[newI] += histogram[i];
    }

    return newHisto;
}

std::vector<int> computeLocalMaximas(Mat_<uchar> &original) {
    int *histogram = computeHistogram(original);
    float *pdf = computePdf(histogram, original);

    std::vector<int> histoMaximas;
    int WH = 5;
    float window_width = 2 * WH + 1, TH = 0.0003;

    for (int k = 0 + WH; k < 255 - WH; k++) {
        float averageV = 0;
        bool ok = true;

        for (int j = k - WH; j <= k + WH; j++) {
            //compute the average of normalized histogram values
            averageV += pdf[j];
            //pdf[k] is greater or equal than all PDF values
            if (pdf[k] < pdf[j]) {
                ok = false;
            }
        }

        averageV /= window_width;

        if (pdf[k] > (averageV + TH) && ok) {
            //k corresponds to a histogram maximum
            histoMaximas.push_back(k);//store k in vector
        }
    }
    //insert 0 at the beginning of the maximas list and 255 at the end
    histoMaximas.insert(histoMaximas.begin(), 0);
    histoMaximas.insert(histoMaximas.begin() + histoMaximas.size(), 255);

    return histoMaximas;

}

Mat_<uchar> levelThresholding(Mat_<uchar> &img) {
    std::vector<int> histoMaximas = computeLocalMaximas(img);
    Mat_<uchar> threshholdedImage(img.rows, img.cols);
    int min;

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            min = 0;
            for (int localMaxima : histoMaximas) {
                if (abs(img(i, j) - min) > abs(img(i, j) - localMaxima)) {
                    min = localMaxima;//compute nearest histogram maximum to the pixel
                }
            }

            threshholdedImage(i, j) = min; //assign to each pixel the color value of the nearest histogram maximum.
        }
    }

    return threshholdedImage;

}

int checkBoundaries(int val) {
    return max(0, min(255, val));
}

bool isInside(const Mat &img, int i, int j) {
    return i >= 0 && i < img.rows && j >= 0 && j < img.cols;
}

int main() {
    Mat_<uchar> img = imread("Images/saturn.bmp", CV_LOAD_IMAGE_GRAYSCALE);
    imshow("Original Image", img);

    int *histogram = computeHistogram(img);
    float *pdf = computePdf(histogram, img);
//    int *newHisto = computeHistogramForGivenBins(histogram, 200);

    showHistogram("Histogram", histogram, 256, 300);
//    showHistogram("Histogram with 200 bins", newHisto, 300, 300);

    auto thresholdedImage = levelThresholding(img);

    imshow("After Thresholding Image", thresholdedImage);

    floyd_steinberg(img);

    imshow("After Floyd-Steinberg Image", img);

    waitKey(0);
}