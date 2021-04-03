#include <iostream>

Mat_<int> CCLabelling(Mat_<uchar> img, int &label, int nbh_type) {

    std::queue<Point2i> Q;
    label = 0;
    Mat_<int> labels(img.rows, img.cols);
    Point2i neighbors[8];

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
                    if (nbh_type == 8) {
                        neighbourhoodPixel8(img, q.x, q.y, neighbors);
                    } else if (nbh_type == 4) {
                        neighbourhoodPixel4(img, q.x, q.y, neighbors);
                    } else std::cout << "Neighbourhood type nbh_type needs to be 4 or 8" << std::endl;
                    for (int k = 0; k < nbh_type; k++) {
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

Mat_ <uchar> edgeLinkingHysteresis(Mat_ <uchar> src) {
    int height = src.rows;
    int width = src.cols;

    Mat_ <uchar> dst(height, width);

    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++) {
            dst(i, j) = src(i, j);
        }

    std::queue<Point2i> queue;
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            if (src(i, j) == 255) {
                queue.push(Point2i(i, j));
                dst(i, j) = 255;
                while (!queue.empty()) {
                    Point2i currentPoint = queue.front();
                    queue.pop();
                    std::vector<Point2i> neighbors = getN8(currentPoint.x, currentPoint.y);
                    for (int k = 0; k < 8; k++) {
                        int neighborI = neighbors.at(k).x;
                        int neighborJ = neighbors.at(k).y;
                        if (isInside(dst, neighborI, neighborJ) && dst(neighborI, neighborJ) == 128) {
                            dst(neighborI, neighborJ) = 255;
                            queue.push(Point2i(neighborI, neighborJ));
                        }
                    }
                }
            }
        }
    }

    //eliminate remaining weak edge points
    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++) {
            if (dst(i, j) == 128) {
                dst(i, j) = 0;
            }
        }

    return dst;
}

void cannyEdgeDetection(Mat_ <uchar> src) {
    //apply gaussian filter
    int height = src.rows;
    int width = src.cols;
    Mat_ <uchar> dst(height, width);
    dst = gaussianFilter(src, 3, 0.5);

    //apply convolution with the 2 Sobel filters
    Mat_<int> sobelX(3, 3);
    sobelX(0, 0) = -1;
    sobelX(1, 0) = -2;
    sobelX(2, 0) = -1;
    sobelX(0, 1) = 0;
    sobelX(1, 1) = 0;
    sobelX(2, 1) = 0;
    sobelX(0, 2) = 1;
    sobelX(1, 2) = 2;
    sobelX(2, 2) = 1;

    Mat_<int> gradientFx;
    convolutionWithoutScaling(sobelX, dst, gradientFx);

    Mat_<int> sobelY(3, 3);
    sobelY(0, 0) = 1;
    sobelY(1, 0) = 0;
    sobelY(2, 0) = -1;
    sobelY(0, 1) = 2;
    sobelY(1, 1) = 0;
    sobelY(2, 1) = -2;
    sobelY(0, 2) = 1;
    sobelY(1, 2) = 0;
    sobelY(2, 2) = -1;

    Mat_<int> gradientFy;
    convolutionWithoutScaling(sobelY, dst, gradientFy);

    //compute magnitude(module)
    Mat_ <uchar> mag(height, width);

    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++) {
            mag(i, j) = sqrt(gradientFx(i, j) * gradientFx(i, j) + gradientFy(i, j) * gradientFy(i, j)) / (4 * sqrt(2));
        }

    imshow("magnitude", mag);

    //compute gradient orientation(direction)
    Mat_<int> theta(height, width);

    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++) {
            theta(i, j) = (atan2(gradientFy(i, j), gradientFx(i, j)) + PI) * 180 / PI;
        }

    imshow("direction", (Mat_ <uchar>) theta);

    //non-maxima suppression
    Mat_ <uchar> mag2(height, width);

    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++) {
            mag2(i, j) = mag(i, j);
        }

    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++) {
            float rad = theta(i, j) * PI / 180;
            if ((rad > PI / 8 && rad <= 3 * PI / 😎 || (rad > 9 * PI / 8 && rad <= 11 * PI / 8)) //1 slices
            {
                if (!(isInside(mag2, i + 1, j - 1) && mag(i + 1, j - 1) < mag(i, j) && isInside(mag2, i - 1, j + 1) &&
                      mag(i - 1, j + 1) < mag(i, j))) {
                    mag2(i, j) = 0;
                }
            }
            else if ((rad > 3 * PI / 8 && rad <= 5 * PI / 😎 || (rad > 11 * PI / 8 && rad <= 13 * PI / 8)) //0 slices
            {
                if (!(isInside(mag2, i + 1, j) && mag(i + 1, j) < mag(i, j) && isInside(mag2, i - 1, j) &&
                      mag(i - 1, j) < mag(i, j))) {
                    mag2(i, j) = 0;
                }
            }
            else if ((rad > 5 * PI / 8 && rad <= 7 * PI / 😎 || (rad > 13 * PI / 8 && rad <= 15 * PI / 8)) //3 slices
            {
                if (!(isInside(mag2, i + 1, j + 1) && mag(i + 1, j + 1) < mag(i, j) && isInside(mag2, i - 1, j - 1) &&
                      mag(i - 1, j - 1) < mag(i, j))) {
                    mag2(i, j) = 0;
                }
            }
            else if ((rad > 7 * PI / 8 && rad <= 9 * PI / 😎 || (rad > 15 * PI / 8 && rad <= 16 * PI / 😎
            || (rad >= 0 && rad <= PI / 8)) //2 slices
            {
                if (!(isInside(mag2, i, j - 1) && mag(i, j - 1) < mag(i, j) && isInside(mag2, i, j + 1) &&
                      mag(i, j + 1) < mag(i, j))) {
                    mag2(i, j) = 0;
                }
            }
        }

    imshow("magnitude 2", mag2);

    //adaptive thresholding
    int *hist = computeHistogram(mag2);
    int nonEdgePixels = (1 - 0.1f) * ((height - 2) * (width - 2) - hist[0]);

    int thresholdHigh;
    int thresholdLow;

    int sum = 0;
    for (int i = 1; i <= 255; i++) {
        sum += hist[i];
        if (sum > nonEdgePixels) {
            thresholdHigh = i;
            break;
        }
    }
    thresholdLow = 0.4f * thresholdHigh;

    Mat_ <uchar> labels(height, width);

    for (int i = 0; i < height; i++)
        for (int j = 0; j < width; j++) {
            int value = mag2(i, j);
            if (value < thresholdLow) {
                labels(i, j) = 0;
            } else if (value >= thresholdLow && value <= thresholdHigh) {
                labels(i, j) = 128;
            } else {
                labels(i, j) = 255;
            }
        }

    imshow("adaptive thresholding", labels);
    waitKey(0);

    Mat_ <uchar> linkedEdges = edgeLinkingHysteresis(labels);

    imshow("edge linking hysteresis", linkedEdges);

    waitKey(0);
}

Andreea Beatrice


int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}