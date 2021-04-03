// OpenCVApplication.cpp : Defines the entry point for the console application.
//

#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

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

bool isInside(const Mat &img, int i, int j) {
    return i >= 0 && i < img.rows && j >= 0 && j < img.cols;
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

int main() {
    Mat_<Vec3b> img = imread("Images/trasaturi_geom.bmp", CV_LOAD_IMAGE_COLOR);
    imshow("Image", img);
    setMouseCallback("Image", onMouse, &img);

    waitKey(0);
}