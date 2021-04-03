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

//Lab3
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

int checkBoundaries(int val) {
    return max(0, min(255, val));
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

//Lab4
double elongationAxis(const Mat_<Vec3b> &img, const Vec3b &colorPixel, std::vector<int> mass_center) {

    int sum1, sum2, sum3;
    sum1 = 0;
    sum2 = 0;
    sum3 = 0;

    for (int r = 0; r < img.rows; r++) {
        for (int c = 0; c < img.cols; c++) {
            if (img(r, c) == colorPixel) {
                sum1 += (r - mass_center[0]) * (c - mass_center[1]);
                sum2 += pow((c - mass_center[1]), 2);
                sum3 += pow((r - mass_center[0]), 2);
            }
        }
    }
    double angle = atan2(2 * sum1, sum2 - sum3) / 2;
    return angle;
}

double perimeterComputation(const Mat_<Vec3b> &img, const Vec3b &colorPixel) {
    int perimeter;
    perimeter = 0;

    for (int r = 0; r < img.rows; r++) {
        for (int c = 0; c < img.cols; c++) {
            if (img(r, c) == colorPixel
                && ((isInside(img, r, c + 1) && img(r, c + 1) != colorPixel)
                    || (isInside(img, r, c - 1) && img(r, c - 1) != colorPixel)
                    || (isInside(img, r + 1, c) && img(r + 1, c) != colorPixel)
                    || (isInside(img, r - 1, c) && img(r - 1, c) != colorPixel)
                    || (isInside(img, r + 1, c + 1) && img(r + 1, c + 1) != colorPixel)
                    || (isInside(img, r - 1, c + 1) && img(r - 1, c + 1) != colorPixel)
                    || (isInside(img, r + 1, c - 1) && img(r + 1, c - 1) != colorPixel)
                    || (isInside(img, r - 1, c - 1) && img(r - 1, c - 1) != colorPixel))) {
                perimeter++;
            }
        }
    }

    return perimeter;
}

double thinnessComputation(int area, double perimeter) {
    double t_ratio = 4 * M_PI * ((double) area / (perimeter * perimeter));

    return t_ratio;
}

double aspectRatioComputation(const Mat_<Vec3b> &img, const Vec3b &colorPixel) {
    int rmax, rmin, cmax, cmin;
    double ratio;
    rmax = 0;
    rmin = INT_MAX;
    cmax = 0;
    cmin = INT_MAX;

    for (int r = 0; r < img.rows; r++) {
        for (int c = 0; c < img.cols; c++) {
            if (img(r, c) == colorPixel) {
                rmax = max(rmax, r);
                rmin = min(rmin, r);
                cmax = max(cmax, c);
                cmin = min(cmin, c);
            }
        }
    }
    ratio = (cmax - cmin + 1.0) / (rmax - rmin + 1.0);
    return ratio;
}

Mat_<Vec3b> drawShape(const Mat_<Vec3b> &img, const Vec3b &colorPixel) {
    Vec3b white = Vec3b(255, 255, 255);
    Mat_<Vec3b> contour(img.rows, img.cols, white);

    for (int r = 0; r < img.rows; r++) {
        for (int c = 0; c < img.cols; c++) {
            if (img(r, c) == colorPixel
                && ((isInside(img, r, c + 1) && img(r, c + 1) != colorPixel)
                    || (isInside(img, r, c - 1) && img(r, c - 1) != colorPixel)
                    || (isInside(img, r + 1, c) && img(r + 1, c) != colorPixel)
                    || (isInside(img, r - 1, c) && img(r - 1, c) != colorPixel)
                    || (isInside(img, r + 1, c + 1) && img(r + 1, c + 1) != colorPixel)
                    || (isInside(img, r - 1, c + 1) && img(r - 1, c + 1) != colorPixel)
                    || (isInside(img, r + 1, c - 1) && img(r + 1, c - 1) != colorPixel)
                    || (isInside(img, r - 1, c - 1) && img(r - 1, c - 1) != colorPixel))) {
                contour(r, c) = colorPixel;
            }
        }
    }

    return contour;
}

void drawElongationAxis(Mat_<Vec3b> img, const Vec3b &colorPixel, double elongation, std::vector<int> mass_center) {
    int length = 100;

    line(img, Point(mass_center[1], mass_center[0]), Point(mass_center[1] + length * cos(elongation),
                                                           mass_center[0] + length * sin(elongation)), colorPixel, 5);
}

void drawBoundingBox(Mat_<Vec3b> img, Mat_<Vec3b> cloned_image, const Vec3b &colorPixel) {
    int rmax, rmin, cmax, cmin;
    rmax = 0;
    rmin = INT_MAX;
    cmax = 0;
    cmin = INT_MAX;

    for (int r = 0; r < img.rows; r++) {
        for (int c = 0; c < img.cols; c++) {
            if (img(r, c) == colorPixel) {
                rmax = max(rmax, r);
                rmin = min(rmin, r);
                cmax = max(cmax, c);
                cmin = min(cmin, c);
            }
        }
    }
    line(cloned_image, Point(cmin, rmin), Point(cmax, rmin), colorPixel, 5);
    line(cloned_image, Point(cmax, rmin), Point(cmax, rmax), colorPixel, 5);
    line(cloned_image, Point(cmax, rmax), Point(cmin, rmax), colorPixel, 5);
    line(cloned_image, Point(cmin, rmax), Point(cmin, rmin), colorPixel, 5);

}

Mat_<Vec3b> projectionsComputation(const Mat_<Vec3b> &img, const Vec3b &colorPixel) {
    int H[1000], V[1000];
    Vec3b white = Vec3b(255, 255, 255);
    Mat_<Vec3b> projection(img.rows, img.cols, white);

    for (int r = 0; r < img.rows; r++) {
        H[r] = 0;
        for (int c = 0; c < img.cols; c++) {
            if (img(r, c) == colorPixel) {
                H[r]++;
            }
        }
    }

    for (int c = 0; c < img.cols; c++) {
        V[c] = 0;
        for (int r = 0; r < img.rows; r++) {
            if (img(r, c) == colorPixel) {
                V[c]++;
            }
        }
    }

    for (int r = 0; r < img.rows; r++) {
        for (int c = 0; c < H[r]; c++) {
            projection(r, c) = colorPixel;
        }
    }

    for (int c = 0; c < img.cols; c++) {
        for (int r = 0; r < V[c]; r++) {
            projection(r, c) = colorPixel;
        }
    }

    return projection;
}

void onMouse(int event, int y, int x, int flags, void *param) {
    Mat_<Vec3b> img = *((Mat_<Vec3b> *) param);
    Vec3b colorPixel = img(x, y);
    Mat_<Vec3b> cloned_image(img.rows, img.cols);

    if (event == CV_EVENT_LBUTTONDOWN) {
        //area
        int area = 0;

        for (int r = 0; r < img.rows; r++) {
            for (int c = 0; c < img.cols; c++) {
                if (img(r, c) == colorPixel) {
                    area++;
                }
            }
        }
        //center of mass
        int ri, ci;
        std::vector<int> mass_center;
        ri = 0;
        ci = 0;
        for (int r = 0; r < img.rows; r++) {
            for (int c = 0; c < img.cols; c++) {
                if (img(r, c) == colorPixel) {
                    ri += r;
                    ci += c;
                }
            }
        }
        ri /= area;
        ci /= area;
        mass_center.push_back(ri);
        mass_center.push_back(ci);

        double elongation_axis = elongationAxis(img, colorPixel, mass_center);
        double perimeter = perimeterComputation(img, colorPixel);
        double thinness = thinnessComputation(area, perimeter);
        double aspect_ratio = aspectRatioComputation(img, colorPixel);
        std::cout << "Geometrical features of clicked object:" << std::endl;
        std::cout << "Area = " << area << std::endl;
        std::cout << "Center of mass =  " << mass_center[0] << ",  " << mass_center[1] << std::endl;
        std::cout << "Elongation Axis = " << elongation_axis * M_PI / 180 << std::endl;
        std::cout << "Perimeter = " << perimeter << std::endl;
        std::cout << "Thinness = " << thinness << std::endl;
        std::cout << "Aspect ratio = " << aspect_ratio << std::endl;

        //contour points
        cloned_image = drawShape(img, colorPixel);
        //center of mass
        cloned_image(mass_center[0], mass_center[1]) = colorPixel;
        //elongation axis
        drawElongationAxis(cloned_image, colorPixel, elongation_axis, mass_center);
        //bounding box
        drawBoundingBox(img, cloned_image, colorPixel);

        imshow("Contour, Mass Center, Elongation, Bounding Box", cloned_image);
        imshow("Projections", projectionsComputation(img, colorPixel));
    }
}

//Lab5

void neighbourhoodPixel4(Mat_<uchar> img, int i, int j, Point2i *neighbors) {
    int di[4] = {-1, 0, 1, 0};
    int dj[4] = {0, -1, 0, 1};

    for (int k = 0; k < 4; k++) {
        if (i + di[k] > 0 && i + di[k] < img.rows && j + dj[k] > 0 && j + dj[k] < img.cols) {
            neighbors[k] = Point2i(i + di[k], j + dj[k]);
        } else neighbors[k] = Point2i(-1, -1);
    }
}

void neighbourhoodPixel8(Mat_<uchar> img, int i, int j, Point2i *neighbors) {
    int di[8] = {-1, -1, -1, 0, 0, 1, 1, 1};
    int dj[8] = {-1, 0, 1, -1, 1, -1, 0, 1};

    for (int k = 0; k < 8; k++) {
        if (i + di[k] > 0 && i + di[k] < img.rows && j + dj[k] > 0 && j + dj[k] < img.cols) {
            neighbors[k] = Point2i(i + di[k], j + dj[k]);
        } else neighbors[k] = Point2i(-1, -1);
    }
}


//Point2i* neighbourhoodPixel8(Mat_<uchar> img, int i, int j) {
//    Point2i neighbors[8];
//    int di[8] = {0, 0, 1, -1, 1, -1, -1, +1};
//    int dj[8] = {1, -1, 0, 0, 1, +1, -1, -1};
//
//    for (int k = 0; k < 8; k++) {
//        if (isInside(img, i + di[k], j + dj[k])) {
//            neighbors[k] = Point2i(i + di[k], j + dj[k]);
//        } else neighbors[k] = Point2i(-1, -1);
//    }
//    return neighbors;
//}

#include <queue>

#include <random>

Mat_<Vec3b> generateColorImage(Mat_<int> labels, int label) {
    Vec3b white = Vec3b(255, 255, 255);
    Mat_<Vec3b> colorMatrix(labels.rows, labels.cols, white);
    std::default_random_engine gen;
    std::uniform_int_distribution<int> d(0, 255);
    Vec3b label_color[label + 1];

    for (int i = 0; i <= label; i++) {
        uchar c1 = d(gen);
        uchar c2 = d(gen);
        uchar c3 = d(gen);
        label_color[i] = Vec3b(c1, c2, c3);
    }

    for (int i = 0; i < colorMatrix.rows; i++) {
        for (int j = 0; j < colorMatrix.cols; j++) {
            if (labels(i, j) != 0)
                colorMatrix(i, j) = label_color[labels(i, j)];
            else
                colorMatrix(i, j) = white;
        }
    }
    return colorMatrix;
}

void neighbourhoodPrevious(Mat_<uchar> img, int i, int j, Point2i *neighbors) {
    int di[4] = {0, -1, -1, -1};
    int dj[4] = {-1, -1, 0, 1};

    for (int k = 0; k < 4; k++) {
        if (i + di[k] > 0 && i + di[k] < img.rows && j + dj[k] > 0 && j + dj[k] < img.cols) {
            neighbors[k] = Point2i(i + di[k], j + dj[k]);
        } else neighbors[k] = Point2i(-1, -1);
    }
}

int minimumList(std::vector<int> L) {
    int min = INT_MAX;
    for (int x:L) {
        if (x < min) {
            min = x;
        }
    }
    return min;
}

Mat_<int> twoPass(Mat_<uchar> img, Mat_<int> &labels_first_pass, int &label, int &new_label) {

    label = 0;
    Mat_<int> labels(img.rows, img.cols);
    Point2i neighbors[4];
    std::vector<int> L;
    std::vector<std::vector<int>> edges(img.rows * img.cols + 1);
    edges.resize(img.rows * img.cols + 1);

    for (int i = 0; i < labels.rows; i++) {
        for (int j = 0; j < labels.cols; j++) {
            labels(i, j) = 0;
        }
    }

    for (int i = 0; i < labels.rows; i++) {
        for (int j = 0; j < labels.cols; j++) {
            if (img(i, j) == 0 && labels(i, j) == 0) {
                neighbourhoodPrevious(img, i, j, neighbors);
                for (Point2i neighbor : neighbors) {
                    if (neighbor != Point2i(-1, -1) && labels(neighbor.x, neighbor.y) > 0) {
                        L.push_back(labels(neighbor.x, neighbor.y));
                    }
                }
                if (L.size() == 0) {
                    label++;
                    labels(i, j) = label;
                } else {
                    int x = minimumList(L);
                    labels(i, j) = x;
                    for (int y:L) {
                        if (y != x) {
                            edges[x].push_back(y);
                            edges[y].push_back(x);
                        }
                    }
                    L.clear();
                }
            }
        }
    }
    for (int i = 0; i < labels.rows; i++) {
        for (int j = 0; j < labels.cols; j++) {
            labels_first_pass(i, j) = labels(i, j);
        }
    }

    std::cout << label << std::endl;
    new_label = 0;
    int new_labels[label + 1];
    std::queue<int> Q;

    for (int i = 0; i <= label; i++) {
        new_labels[i] = 0;
    }

    for (int i = 1; i <= label; i++) {
        if (new_labels[i] == 0) {
            new_label++;
            new_labels[i] = new_label;
            Q.push(i);
            while (!Q.empty()) {
                int x = Q.front();
                Q.pop();
                for (int y:edges[x]) {
                    if (new_labels[y] == 0) {
                        new_labels[y] = new_label;
                        Q.push(y);
                    }
                }
            }
        }
    }
    std::cout << new_label;

    for (int i = 0; i < labels.rows; i++) {
        for (int j = 0; j < labels.cols; j++) {
            labels(i, j) = new_labels[labels(i, j)];
        }
    }
    return labels;
}

Mat_<uchar> createBorderedImage(Mat_<uchar> img, Point2i *boundary_pixels, int size) {
    Mat_<uchar> contoured_image(img.rows, img.cols);
//    Vec3b white = Vec3b(255, 255, 255);

    for (int i = 0; i < contoured_image.rows; i++) {
        for (int j = 0; j < contoured_image.cols; j++) {
            contoured_image(i, j) = 0;
        }
    }

    for (int i = 0; i < size - 1; i++) {
        contoured_image(boundary_pixels[i].x, boundary_pixels[i].y) = 255;

    }
    return contoured_image;
}

//Lab6:
Point2i *borderTracingAlgorithm(const Mat_<uchar> &img, int &size, std::vector<int> &dirs) {
    int di[8] = {0, -1, -1, -1, 0, 1, 1, 1};
    int dj[8] = {1, 1, 0, -1, -1, -1, 0, 1};
    Point2i boundary_pixels[img.rows * img.cols + 1];
    int dir = 7;
    int i, j;
    for (i = 0; i < img.rows; i++) {
        for (j = 0; j < img.cols; j++) {
            if (img(i, j) == 0) {
                boundary_pixels[0] = Point2i(i, j);
                size = 1;
                goto find_boundaries;

            }
        }
    }
    find_boundaries:
    int new_dir, i2, j2;
//    std::cout << i << " " << j << std::endl;
    while (size < 4 || boundary_pixels[size - 1] != boundary_pixels[1] ||
           boundary_pixels[size - 2] != boundary_pixels[0]) {
        i = boundary_pixels[size - 1].x;
        j = boundary_pixels[size - 1].y;
        (dir % 2 == 0) ? dir = (dir + 7) % 8 : dir = (dir + 6) % 8;
        for (int k = 0; k < 8; k++) {
            new_dir = (dir + k) % 8;
            i2 = i + di[new_dir];
            j2 = j + dj[new_dir];

            if (img(i2, j2) == 0) {
                boundary_pixels[size++] = Point2i(i2, j2);
                dir = new_dir;
                std::cout << dir << " ";
                dirs.push_back(dir);
                break;
            }
        }
    }
    std::cout << std::endl;
    return boundary_pixels;
}

std::vector<int> calcDerivatives(std::vector<int> &dirs) {
    std::vector<int> derivatives;
    int derivative;
    for (int i = 0; i < dirs.size() - 2; i++) {
        derivative = dirs[i + 1] - dirs[i];
        if (derivative < 0)
            derivative += 8;
        std::cout << derivative << " ";
        derivatives.push_back(derivative);
    }
    return derivatives;
}

#include <fstream>
#include <utility>

void reconstructImage(Mat_<uchar> img) {
    std::ifstream f("Images/reconstruct.txt");
    int di[8] = {0, -1, -1, -1, 0, 1, 1, 1};
    int dj[8] = {1, 1, 0, -1, -1, -1, 0, 1};
    int x, y, nb_codes, code;

    f >> x >> y >> nb_codes;
    int i = x, j = y;
    img(i, j) = 0;
    for (int k = 0; k < nb_codes; k++) {
        f >> code;
        i += di[code];
        j += dj[code];
        img(i, j) = 0;
    }
}
//Lab7

Mat_<uchar> dilation(Mat_<uchar> src_img, Mat_<uchar> B) {
    Mat_<uchar> dst_img(src_img.rows, src_img.cols, 255);

    for (int i = 0; i < src_img.rows; i++) {
        for (int j = 0; j < src_img.cols; j++) {
            if (src_img(i, j) == 0) {
                for (int u = 0; u < B.rows; u++) {
                    for (int v = 0; v < B.cols; v++) {
                        Point2i p = Point2i(i + u - B.rows / 2, j + v - B.cols / 2);
                        if (B(u, v) == 0 && isInside(src_img, p.x, p.y))
                            dst_img(p.x, p.y) = 0;
                    }
                }
            }
        }
    }
    return dst_img;
}

Mat_<uchar> erosion(Mat_<uchar> src_img, Mat_<uchar> B) {
    Mat_<uchar> dst_img(src_img.rows, src_img.cols, 255);

    for (int i = 0; i < src_img.rows; i++) {
        for (int j = 0; j < src_img.cols; j++) {
            if (src_img(i, j) == 0) {
                int ok = 0;
                for (int u = 0; u < B.rows; u++) {
                    for (int v = 0; v < B.cols; v++) {
                        Point2i p = Point2i(i + u - B.rows / 2, j + v - B.cols / 2);
                        if (B(u, v) == 0 && isInside(src_img, p.x, p.y) && src_img(p.x, p.y) != 0)
                            ok = 1;
                    }

                }
                if (ok == 0)
                    dst_img(i, j) = 0;
            }

        }
    }
    return dst_img;

}

Mat_<uchar> dilationNTimes(const Mat_<uchar> &img, int n, Mat_<uchar> B) {
    Mat_<uchar> dilation_tst_img(img.rows, img.cols);
    Mat_<uchar> dilationN_img(img.rows, img.cols);
    img.copyTo(dilation_tst_img);
    for (int i = 0; i < n; i++) {
        dilationN_img = dilation(dilation_tst_img, B);
        dilationN_img.copyTo(dilation_tst_img);
    }
    return dilationN_img;
}

Mat_<uchar> erosionNTimes(const Mat_<uchar> &img, int n, Mat_<uchar> B) {
    Mat_<uchar> erosion_tst_img(img.rows, img.cols);
    Mat_<uchar> erosionN_img(img.rows, img.cols);
    img.copyTo(erosion_tst_img);
    for (int i = 0; i < n; i++) {
        erosionN_img = erosion(erosion_tst_img, B);
        erosionN_img.copyTo(erosion_tst_img);
    }
    return erosionN_img;
}

Mat_<uchar> boundaryExtraction(const Mat_<uchar> &img, Mat_<uchar> B) {
    Mat_<uchar> erodedAbyB(img.rows, img.cols);
    Mat_<uchar> res(img.rows, img.cols);
    erodedAbyB = erosion(img, std::move(B));

    for (int i = 0; i < res.rows; i++) {
        for (int j = 0; j < res.cols; j++) {
            res(i, j) = 255;
        }
    }

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (img(i, j) == 0 && erodedAbyB(i, j) != 0) {
                res(i, j) = 0;
            }
        }
    }
    return res;
}

Mat_<uchar> complementBoundary(Mat_<uchar> img) {
    Mat_<uchar> res(img.rows, img.cols);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            (img(i, j) == 0) ? res(i, j) = 255 : res(i, j) = 0;
        }
    }
    return res;
}

bool compareImages(Mat_<uchar> img1, Mat_<uchar> img2) {

    for (int i = 0; i < img1.rows; i++) {
        for (int j = 0; j < img1.cols; j++) {
            if (img1(i, j) != img2(i, j))
                return false;
        }
    }
    return true;
}

Mat_<uchar> unionImages(Mat_<uchar> img1, Mat_<uchar> img2) {
    Mat_<uchar> res(img1.rows, img1.cols, 255);

    for (int i = 0; i < img1.rows; i++) {
        for (int j = 0; j < img1.cols; j++) {
            if (img1(i, j) == 0 && img2(i, j) == 0)
                res(i, j) = 0;
        }
    }
    return res;
}

Mat_<uchar> regionFilling(const Mat_<uchar> &img, Mat_<uchar> B) {
    Mat_<uchar> boundary_img(img.rows, img.cols);
    Mat_<uchar> boundary_img_complement(img.rows, img.cols);
    Mat_<uchar> X_img(img.rows, img.cols, 255);
    Mat_<uchar> Xminus1_img(img.rows, img.cols, 255);
    Mat_<uchar> dil(img.rows, img.cols);
    boundary_img = boundaryExtraction(img, B);
    boundary_img_complement = complementBoundary(boundary_img);

    for (int i = 1; i < img.rows; i++) {
        for (int j = 1; j < img.cols; j++) {
            if (img(i, j) == 255 && img(i - 1, j) == 0 && img(i, j - 1) == 0) {
                Xminus1_img(i, j) = 0;
                goto found_start;
            }
        }
    }
    found_start:
    int ok = 1;
    while (ok) {
        dil = dilation(Xminus1_img, B);
        X_img = unionImages(dil, boundary_img_complement);
        if (compareImages(X_img, Xminus1_img))
            ok = 0;
        Xminus1_img = X_img.clone();
    }
    return X_img;
}
//Lab8

int *cumulativeHistogram(int *histogram) {
    int *cumulativeHisto = new int[256];
    int sum = 0;

    for (int i = 0; i <= 255; i++) {
        sum += histogram[i];
        cumulativeHisto[i] = sum;
    }
    return cumulativeHisto;
}

double meanIntensityValue(Mat_<uchar> img) {
    int nbPixels = img.rows * img.cols;
    double miv = 0;
    int *histo = computeHistogram(img);
    for (int g = 0; g < 255; g++) {
        miv += g * histo[g];
    }
    return miv / nbPixels;
}

double standardDeviation(Mat_<uchar> img, double miv) {
    int nbPixels = img.rows * img.cols;
    double sd = 0;
    int *histo = computeHistogram(img);
    for (int g = 0; g < 255; g++) {
        sd += pow(g - miv, 2) * histo[g] / nbPixels;
    }
    return sqrt(sd);
}

int maxIntensity(int *h) {
    for (int i = 255; i >= 0; i--) {
        if (h[i] != 0) {
            return i;
        }
    }
}

int minIntensity(int *h) {
    for (int i = 0; i <= 255; i++) {
        if (h[i] != 0) {
            return i;
        }
    }
}

Mat_<uchar> basicGlobalThresholding(Mat_<uchar> img, int *histogram, int imax, int imin, float threshold) {
    Mat_<uchar> imgThresholded(img.rows, img.cols);
    float ug1 = 0, ug2 = 0, n1 = 0, n2 = 0;
    int g;
    float newTh;
    float error = 0.1;

    int ok = 1;
    do {
        n1 = 0;
        for (g = imin; g <= threshold; g++) {
            n1 += histogram[g];
        }
        n2 = 0;
        for (g = threshold + 1; g <= imax; g++) {
            n2 += histogram[g];
        }
        ug1 = 0;
        for (g = imin; g <= threshold; g++) {
            ug1 += g * histogram[g];
        }
        ug1 /= n1;
        ug2 = 0;
        for (g = threshold + 1; g <= imax; g++) {
            ug2 += g * histogram[g];
        }
        ug2 /= n2;

        newTh = (ug1 + ug2) / 2;
        if (abs(newTh - threshold) < error)
            ok = 0;
        else
            threshold = newTh;
    } while (ok);

    cout << "threshold " << newTh << endl;
    for (int i = 0; i < imgThresholded.rows; i++) {
        for (int j = 0; j < imgThresholded.cols; j++) {
            if (img(i, j) >= newTh)
                imgThresholded(i, j) = 255;
            else
                imgThresholded(i, j) = 0;
        }
    }
    return imgThresholded;
}

int *histogramStetchingShrinking(Mat_<uchar> img, int gomin, int gomax) {
    Mat_<uchar> newImg(img.rows, img.cols);

    int ginmin = minIntensity(computeHistogram(img)), ginmax = maxIntensity(computeHistogram(img));
    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            int gin = img(i, j);
            float gout = gomin + (gin - ginmin) * round((gomax - gomin) / (ginmax - ginmin));
            if (gout <= 0)
                gout = 0;
            else if (gout >= 255)
                gout = 255;
            newImg(i, j) = round(gout);
        }
    }
    imshow("Histo stretching/shrinking image", newImg);
    return computeHistogram(newImg);
}

int *gammaCorrection(Mat_<uchar> img, float gamma) {
    float L = 255;
    Mat_<uchar> newImg(img.rows, img.cols);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            float gin = img(i, j);
            float gout = L * pow(double(gin / L), double(gamma));
            if (gout <= 0)
                gout = 0;
            else if (gout >= 255)
                gout = 255;
            newImg(i, j) = round(gout);
        }
    }
    imshow("Gamma correction image", newImg);
    return computeHistogram(newImg);
}

int *brightnessChanging(Mat_<uchar> img, int offset) {
    Mat_<uchar> newImg(img.rows, img.cols);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            int gin = img(i, j);
            int gout = gin + offset;
            if (gout <= 0)
                gout = 0;
            else if (gout >= 255)
                gout = 255;
            newImg(i, j) = gout;
        }
    }
    imshow("Brightness changing image", newImg);
    return computeHistogram(newImg);
}

int *histogramEqualization(Mat_<uchar> src, int *histogram) {
    float *pc = new float[256];
    float *tab = new float[256];
    int L = 255, M = src.rows * src.cols;
    Mat_<uchar> dst(src.rows, src.cols);
    float *pdf = computePdf(histogram, src);

    pc[0] = pdf[0];
    for (int i = 1; i < 256; i++) {
        pc[i] = pc[i - 1] + pdf[i];
    }

    for (int i = 0; i < src.rows; i++) {
        for (int j = 0; j < src.cols; j++) {
            int gin = src(i, j);
            tab[gin] = L * pc[gin];
            dst(i, j) = round(tab[gin]);
        }
    }
    imshow("Histo equalization image", dst);
    return computeHistogram(dst);
}

//Lab9 part1
Mat_<uchar> normalize(Mat_<float> srcf, Mat_<float> kernel) {
    Mat_<uchar> dst(srcf.rows, srcf.cols);

    float sum_plus = 0, sum_minus = 0;
    for (int u = 0; u < kernel.rows; u++) {
        for (int v = 0; v < kernel.cols; v++) {
            if (kernel(u, v) > 0)
                sum_plus += kernel(u, v);
            else
                sum_minus += kernel(u, v);
        }
    }
    float max = sum_plus * 255;
    float min = sum_minus * 255;
    float L = 255;
    for (int i = 0; i < srcf.rows; i++) {
        for (int j = 0; j < srcf.cols; j++) {
            dst(i, j) = round(L * ((srcf(i, j) - min) / (max - min)));
        }
    }
    return dst;
}

Mat_<float> convolve(Mat_<float> src, Mat_<float> kernel) {
    Mat_<float> dst(src.rows, src.cols);
    int k1 = (kernel.rows - 1) / 2;
    int k2 = (kernel.cols - 1) / 2;

    for (int i = k1; i < src.rows - k1; i++) {
        for (int j = k2; j < src.cols - k2; j++) {
            float sum = 0;
            for (int u = 0; u < kernel.rows; u++) {
                for (int v = 0; v < kernel.cols; v++) {
                    if (isInside(src, i + u - k1, j + v - k2))
                        sum += kernel(u, v) * src(i + u - k1, j + v - k2);
                }
            }
            dst(i, j) = sum;
        }
    }
    return dst;
}

Mat_<uchar> spatial_filter(Mat_<uchar> src, Mat_<float> kernel) {
    Mat srcf;
    src.convertTo(srcf, CV_32FC1);

    Mat_<float> dstf = convolve(srcf, kernel);
    Mat_<uchar> dst = normalize(dstf, kernel);
    return dst;
}

//Lab9: part 2
void centering_transform(Mat img) {
    //expects floating point image
    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            img.at<float>(i, j) = ((i + j) & 1) ? -img.at<float>(i, j) : img.at<float>(i, j);
        }
    }
}

Mat_<float> low_pass_filter(Mat_<float> src, int H, int W, int R) {
    Mat_<float> dst(src.rows, src.cols);

    for (int u = 0; u < src.rows; u++) {
        for (int v = 0; v < src.cols; v++) {
            if ((pow(H / 2 - u, 2) + pow(W / 2 - v, 2)) > pow(R, 2)) //low-pass
                dst(u, v) = 0;
            else
                dst(u, v) = src(u, v);
        }
    }
    return dst;
}

Mat_<float> high_pass_filter(Mat_<float> src, int H, int W, int R) {
    Mat_<float> dst(src.rows, src.cols);

    for (int u = 0; u < src.rows; u++) {
        for (int v = 0; v < src.cols; v++) {
            if ((pow(H / 2 - u, 2) + pow(W / 2 - v, 2)) <= pow(R, 2)) //high-pass
                dst(u, v) = 0;
            else
                dst(u, v) = src(u, v);
        }
    }
    return dst;
}

Mat_<float> gaussian_low_pass_filter(Mat_<float> src, int H, int W, int R) {
    Mat_<float> dst(src.rows, src.cols);

    int A = 20;
    for (int u = 0; u < src.rows; u++) {
        for (int v = 0; v < src.cols; v++) {
            double d = pow(H / 2 - u, 2) + pow(W / 2 - v, 2);
            dst(u, v) = src(u, v) * exp(-(d / (A * A)));
        }
    }
    return dst;
}

Mat_<float> gaussian_high_pass_filter(Mat_<float> src, int H, int W, int R) {
    Mat_<float> dst(src.rows, src.cols);

    int A = 20;
    for (int u = 0; u < src.rows; u++) {
        for (int v = 0; v < src.cols; v++) {
            double d = pow(H / 2 - u, 2) + pow(W / 2 - v, 2);
            dst(u, v) = src(u, v) * (1 - exp(-(d / (A * A))));
        }
    }
    return dst;
}

Mat generic_frequency_domain_filter(Mat src) {
//convert input image to float image
    Mat srcf;
    src.convertTo(srcf, CV_32FC1);
//centering transformation
    centering_transform(srcf);
//perform forward transform with complex image output
    Mat fourier;
    dft(srcf, fourier, DFT_COMPLEX_OUTPUT);
//split into real and imaginary channels
    Mat channels[] = {Mat::zeros(src.size(), CV_32F), Mat::zeros(src.size(), CV_32F)};
    split(fourier, channels); // channels[0] = Re(DFT(I)), channels[1] = Im(DFT(I))
//calculate magnitude and phase in floating point images mag and phi
    Mat mag, phi;
    magnitude(channels[0], channels[1], mag);
    phase(channels[0], channels[1], phi);

//display the phase and magnitude images here
// ......
    Mat_<float> magg(mag.rows, mag.cols);
    Mat_<uchar> image_magg(mag.rows, mag.cols);
    Mat_<float> magFilter(mag.rows, mag.cols);

    for (int u = 0; u < mag.rows; u++) {
        for (int v = 0; v < mag.cols; v++) {
            magg(u, v) = log(mag.at<float>(u, v) + 1);
        }
    }
    normalize(magg, image_magg, 0, 255, NORM_MINMAX, CV_8UC1);

    imshow("PHASE", phi);
    imshow("MAGNITUDE", image_magg);
//insert filtering operations on Fourier coefficients here
// ......
    int R = 20;
    magFilter = gaussian_high_pass_filter(mag, src.rows, src.cols, R);

//store in real part in channels[0] and imaginary part in channels[1]
// ......
    for (int u = 0; u < magFilter.rows; u++) {
        for (int v = 0; v < magFilter.cols; v++) {
            channels[0].at<float>(u, v) = magFilter.at<float>(u, v) * cos(phi.at<float>(u, v));
            channels[1].at<float>(u, v) = magFilter.at<float>(u, v) * sin(phi.at<float>(u, v));
        }
    }

//perform inverse transform and put results in dstf
    Mat dst, dstf;
    merge(channels, 2, fourier);
    dft(fourier, dstf, DFT_INVERSE | DFT_REAL_OUTPUT | DFT_SCALE);
//inverse centering transformation
    centering_transform(dstf);
//normalize the result and put in the destination image
    normalize(dstf, dst, 0, 255, NORM_MINMAX, CV_8UC1);
//Note: normalizing distorts the resut while enhancing the image display in the range [0,255].
//For exact results (see Practical work 3) the normalization should be replaced with convertion:
//dstf.convertTo(dst, CV_8UC1);
    return dst;
}

//Lab10
void swap(int *xp, int *yp) {
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}

// A function to implement bubble sort
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

Mat_<uchar> gaussianFiltering(Mat_<uchar> img, int w, float sigma) {
    //w - size of kernel/gaussian fitler
    //sigma - standard deviation
    Mat_<float> g_filter(w, w);
    Mat dst;
//    Mat_<float> dst(img.rows, img.cols, CV_32FC1);

    int x0 = w / 2, y0 = w / 2;
    for (int i = 0; i < w; i++) {
        for (int j = 0; j < w; j++) {
            double exponent = exp(-((pow(i - x0, 2) + pow(j - y0, 2)) / (2 * pow(sigma, 2))));
            g_filter(i, j) = (1. / (2 * M_PI * sigma)) * exponent;
        }
    }
    dst = spatial_filter(img, g_filter);
    return dst;
}

Mat_<uchar> gaussianFilteringDecomposition(Mat_<uchar> img, int w, float sigma) {
    Mat_<float> gx_filter(1, w);
    Mat_<float> gy_filter(w, 1);
    Mat dst;
//    Mat_<float> dst(w, w, CV_32FC1);
    int x0 = w / 2, y0 = w / 2;

    for (int i = 0; i < w; i++) {
        double exponent = exp(-(pow(i - y0, 2) / (2 * sigma * sigma)));
        gy_filter(i, 0) = (1. / (sqrt(2 * M_PI) * sigma)) * exponent;
    }
    for (int j = 0; j < w; j++) {
        double exponent = exp(-(pow(j - x0, 2) / (2 * sigma * sigma)));
        gx_filter(0, j) = (1. / (sqrt(2 * M_PI) * sigma)) * exponent;
    }
    dst = spatial_filter(spatial_filter(img, gy_filter), gx_filter);
    return dst;
}