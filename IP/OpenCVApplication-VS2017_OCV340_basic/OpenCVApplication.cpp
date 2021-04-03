// OpenCVApplication.cpp : Defines the entry point for the console application.
//

#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

void negative_image() {
    Mat img = imread("Images/cameraman.bmp",
                     CV_LOAD_IMAGE_GRAYSCALE);
    Mat img1 = imread("Images/cameraman.bmp",
                      CV_LOAD_IMAGE_GRAYSCALE);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            img1.at<uchar>(i, j) = 255 - img.at<uchar>(i, j);
        }
    }
    imshow("negative image", img1);
    imshow("original image", img);
    waitKey(0);
}

void additive_image() {
    Mat_<uchar> img = imread("Images/cameraman.bmp",
                             CV_LOAD_IMAGE_GRAYSCALE);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            img(i, j) = 100 + img(i, j) < 256 ? 10 + img(i, j) : 255;
        }
    }

    imshow("additive image", img);
    waitKey(0);
}

void multiplicative_image() {
    Mat_<uchar> img = imread("Images/cameraman.bmp",
                             CV_LOAD_IMAGE_GRAYSCALE);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            img(i, j) = 2.0 * img(i, j) < 256 ? 2.0 * img(i, j) : 255;
        }
    }

    imshow("multiplicative image", img);
    imwrite("multiplicative_img.jpg", img);
    waitKey(0);
}

void color_matrix() {
    Mat_<Vec3b> img(256, 256);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (i < 128 && j < 128) {
                img(i, j)[0] = 255;
                img(i, j)[1] = 255;
                img(i, j)[2] = 255;
            } else if (i < 128 && j >= 128) {
                img(i, j)[0] = 0;
                img(i, j)[1] = 0;
                img(i, j)[2] = 255;
            } else if (i >= 128 && j < 128) {
                img(i, j)[0] = 0;
                img(i, j)[1] = 255;
                img(i, j)[2] = 0;
            } else {
                img(i, j)[0] = 0;
                img(i, j)[1] = 255;
                img(i, j)[2] = 255;
            }
        }
    }

    imshow("color matrix", img);
    waitKey(0);
}

void inverse_matrix() {
    float vals[10] = {2, 3, 5, 1, 6, 6, 1, 4, 2};
    Mat_<float> img(3, 3, vals);
    Mat_<float> inv = img.inv();

    for (int i = 0; i < inv.rows; i++) {
        for (int j = 0; j < inv.cols; j++) {
            std::cout << inv(i, j) << " ";
        }

        std::cout << std::endl;
    }
}

void rotate_matrix() {
    float vals[10] = {2, 3, 5, 1, 6, 6, 1, 4, 2};
    Mat_<float> img(3, 3, vals);

    for (int i = 0; i < img.rows / 2; i++) {
        int top = i;
        int bottom = img.rows - 1 - i;
        for (int j = top; j < bottom; j++) {
            int temp = img[top][j];
            img[top][j] = img[j][bottom];
            img[j][bottom] = img[bottom][bottom - (j - top)];
            img[bottom][bottom - (j - top)] = img[bottom - (j - top)][top];
            img[bottom - (j - top)][top] = temp;
        }
    }

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            std::cout << img(i, j) << " ";
        }

        std::cout << std::endl;
    }
}
//Lab2
void convert_grayscale(const Mat_<Vec3b> &rgb_img) {
    Mat_<uchar> grayscale_img(rgb_img.rows, rgb_img.cols);

    for (int i = 0; i < rgb_img.rows; i++) {
        for (int j = 0; j < rgb_img.cols; j++) {
            grayscale_img(i, j) = (rgb_img(i, j)[0] + rgb_img(i, j)[1] + rgb_img(i, j)[2]) / 3;
        }
    }

    imshow("RGB Image", rgb_img);
    imshow("Grayscale Image", grayscale_img);
}

void display_RGB(Mat_<Vec3b> rgb_img) {
    Mat_<uchar> b_img(rgb_img.rows, rgb_img.cols);
    Mat_<uchar> g_img(rgb_img.rows, rgb_img.cols);
    Mat_<uchar> r_img(rgb_img.rows, rgb_img.cols);

    for (int i = 0; i < rgb_img.rows; i++) {
        for (int j = 0; j < rgb_img.cols; j++) {
            b_img(i, j) = rgb_img(i, j)[0];
            g_img(i, j) = rgb_img(i, j)[1];
            r_img(i, j) = rgb_img(i, j)[2];
        }
    }

    imshow("RGB Image", rgb_img);
    imshow("B Image", b_img);
    imshow("G Image", g_img);
    imshow("R Image", r_img);
}

void convert_binary(Mat_<uchar> gray_img) {
    uchar threshold = 100;
    Mat_<uchar> binary_img(gray_img.rows, gray_img.cols);

    for (int i = 0; i < gray_img.rows; i++) {
        for (int j = 0; j < gray_img.cols; j++) {
            if (gray_img(i, j) < threshold) {
                binary_img(i, j) = 0;
            } else {
                binary_img(i, j) = 255;
            }
        }
    }

    imshow("Grayscale Image", gray_img);
    imshow("Binary Image", binary_img);
}

void RGB_to_HSV(const Mat_<Vec3b> &rgb_img) {
    Mat_<uchar> h_img(rgb_img.rows, rgb_img.cols);
    Mat_<uchar> s_img(rgb_img.rows, rgb_img.cols);
    Mat_<uchar> v_img(rgb_img.rows, rgb_img.cols);
    Mat_<Vec3b> hsv_img(rgb_img.rows, rgb_img.cols);
    Mat_<Vec3b> rgb_img2(rgb_img.rows, rgb_img.cols);

    float r, g, b, R, G, B, M, m, C, V, S, H, V_norm, S_norm, H_norm;

    for (int i = 0; i < rgb_img.rows; i++) {
        for (int j = 0; j < rgb_img.cols; j++) {
            R = rgb_img(i, j)[2];
            G = rgb_img(i, j)[1];
            B = rgb_img(i, j)[0];

            r = R / 255;
            g = G / 255;
            b = B / 255;

            M = max(r, max(g, b));
            m = min(r, min(g, b));

            C = M - m;

            V = M;

            if (V != 0) {
                S = C / V;
            } else {
                S = 0;
            }

            if (C != 0) {
                if (M == r) {
                    H = 60 * (g - b) / C;
                }
                if (M == g) {
                    H = 120 + 60 * (b - r) / C;
                }
                if (M == b) {
                    H = 240 + 60 * (r - g) / C;
                }

            } else {
                H = 0;
            }

            if (H < 0) {
                H = H + 360;
            }

            H_norm = H * 255 / 360;
            S_norm = S * 255;
            V_norm = V * 255;

            h_img(i, j) = H_norm;
            s_img(i, j) = S_norm;
            v_img(i, j) = V_norm;

            hsv_img(i, j)[0] = H / 2;
            hsv_img(i, j)[1] = S_norm;
            hsv_img(i, j)[2] = V_norm;
        }
    }

    imshow("HSV Image", hsv_img);
    imshow("Original Image", rgb_img);
//    imshow("H Image", h_img);
//    imshow("S Image", s_img);
//    imshow("V Image", v_img);
    cvtColor(hsv_img, rgb_img2, CV_HSV2BGR);
    imshow("RGB Image", rgb_img2);
}

bool isInside(const Mat &img, int i, int j) {
    return i >= 0 && i < img.rows && j >= 0 && j < img.cols;
}

int *get_histogram(const Mat_<uchar> &img) {
    auto *histogram = new int[256];
    memset(histogram, 0, 256 * sizeof(int));

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            histogram[img(i, j)]++;
        }
    }

    return histogram;
}

float *compute_pdf(const int *histogram, const Mat_<uchar> &img) {
    auto *pdf = new float[256];
    memset(pdf, 0, 256 * sizeof(float));
    auto nr_pixels = img.rows * img.cols;

    for (int i = 0; i < 256; i++) {
        pdf[i] = (float) histogram[i] / nr_pixels;
    }

    return pdf;
}

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

int *convert_histogram(const int *histogram, int nr_bins) {
    auto *converted_histogram = new int[nr_bins];
    memset(converted_histogram, 0, nr_bins * sizeof(int));

    for (int i = 0; i < 256; i++) {
        int index = floor(i / (256 / nr_bins));
        converted_histogram[index] += histogram[i];
    }

    return converted_histogram;
}

std::vector<int> get_local_maximas(const Mat_<uchar> &original_img) {
    auto *histogram = get_histogram(original_img);
    auto *pdf = compute_pdf(histogram, original_img);

    std::vector<int> local_maximas;
    int window_height = 5;
    float window_width = 2 * window_height + 1, threshold = 0.0003;

    for (int i = 0 + window_height; i < 255 - window_height; i++) {
        float v = 0;
        bool ok = true;

        for (int j = i - window_height; j <= i + window_height; j++) {
            v += pdf[j];

            if (pdf[i] < pdf[j]) {
                ok = false;
            }
        }

        v /= window_width;

        if (pdf[i] > (v + threshold) && ok) {
            local_maximas.push_back(i);
        }
    }

    local_maximas.insert(local_maximas.begin(), 0);
    local_maximas.insert(local_maximas.begin() + local_maximas.size(), 255);

    free(histogram);
    free(pdf);

    return local_maximas;
}

Mat_<uchar> multi_level_thresholding(const Mat_<uchar> &img) {
    std::vector<int> local_maximas = get_local_maximas(img);

    Mat_<uchar> rez(img.rows, img.cols);

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            int min_value = 0, pixel = img(i, j);

            for (int local_maxima : local_maximas) {
                if (abs(pixel - min_value) > abs(pixel - local_maxima)) {
                    min_value = local_maxima;
                }
            }

            rez(i, j) = min_value;
        }
    }

    return rez;
}

int check_boundaries(int val) {
    return max(0, min(255, val));
}

void floyd_steinberg(Mat_<uchar> original_img) {
    std::vector<int> local_maximas = get_local_maximas(original_img);

    for (int i = 0; i < original_img.rows; i++) {
        for (int j = 0; j < original_img.cols; j++) {
            int old_pixel = original_img(i, j);
            int min_value = 0;

            for (int local_maxima : local_maximas) {
                if (abs(old_pixel - min_value) > abs(old_pixel - local_maxima)) {
                    min_value = local_maxima;
                }
            }

            int new_pixel = min_value, error = old_pixel - new_pixel;

            if (isInside(original_img, i, j + 1)) {
                original_img(i, j + 1) = check_boundaries(original_img(i, j + 1) + 7 * error / 16);
            }

            if (isInside(original_img, i + 1, j - 1)) {
                original_img(i + 1, j - 1) = check_boundaries(original_img(i + 1, j - 1) + 3 * error / 16);
            }

            if (isInside(original_img, i + 1, j)) {
                original_img(i + 1, j) = check_boundaries(original_img(i + 1, j) + 5 * error / 16);
            }

            if (isInside(original_img, i + 1, j + 1)) {
                original_img(i + 1, j + 1) = check_boundaries(original_img(i + 1, j + 1) + 1 * error / 16);
            }
        }
    }
}

//Lab4
int compute_area(const Mat_<Vec3b> &img, const Vec3b &obj_color) {
    int area = 0;

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (img(i, j) == obj_color) {
                area++;
            }
        }
    }

    return area;
}

std::pair<int, int> compute_center_of_mass(const Mat_<Vec3b> &img, const Vec3b &obj_color, int area) {
    int ri = 0, ci = 0;

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (img(i, j) == obj_color) {
                ri += i;
                ci += j;
            }
        }
    }

    ri /= area;
    ci /= area;

    return std::make_pair(ri, ci);
}

double compute_orientation(const Mat_<Vec3b> &img, const Vec3b &obj_color, int area, std::pair<int, int> center_of_mass) {
    int sum1 = 0, sum2 = 0, sum3 = 0;

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (img(i, j) == obj_color) {
                sum1 += 2 * (i - center_of_mass.first) * (j - center_of_mass.second);
                sum2 += (j - center_of_mass.second) * (j - center_of_mass.second);
                sum3 += (i - center_of_mass.first) * (i - center_of_mass.first);
            }
        }
    }

    return (atan2(sum1, sum2 - sum3) / 2) * (180 / M_PI); // convert radians to degrees
}

void draw_elongation_line(Mat_<Vec3b> img, const Vec3b &obj_color, double orientation, std::pair<int, int> center_of_mass) {
    int length = 100;
    double end_r, end_c;

    end_r = center_of_mass.first + length * cos(orientation);
    end_c = center_of_mass.second + length * sin(orientation);

    line(img, Point(center_of_mass.second, center_of_mass.first), Point(end_c, end_r), obj_color, 2);
}

std::pair<int, Mat_<Vec3b>> compute_perimeter(const Mat_<Vec3b> &img, const Vec3b &obj_color) {
    int perimeter = 0;
    Mat_<Vec3b> perimeter_img(img.rows, img.cols, Vec3b(255, 255, 255));

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (img(i, j) == obj_color && ((isInside(img, i, j + 1) && img(i, j + 1) != obj_color)
                                           || (isInside(img, i, j - 1) && img(i, j - 1) != obj_color)
                                           || (isInside(img, i + 1, j) && img(i + 1, j) != obj_color)
                                           || (isInside(img, i - 1, j) && img(i - 1, j) != obj_color)
                                           || (isInside(img, i + 1, j + 1) && img(i + 1, j + 1) != obj_color)
                                           || (isInside(img, i - 1, j + 1) && img(i - 1, j + 1) != obj_color)
                                           || (isInside(img, i + 1, j - 1) && img(i + 1, j - 1) != obj_color)
                                           || (isInside(img, i - 1, j - 1) && img(i - 1, j - 1) != obj_color))) {
                perimeter++;
                perimeter_img(i, j) = obj_color;
            }
        }
    }

    return std::make_pair(perimeter * M_PI, perimeter_img);
}

double compute_thinness(int area, int perimeter) {
    return 4 * M_PI * ((double) area / (perimeter * perimeter));
}

double compute_aspect_ratio(const Mat_<Vec3b> &img, const Vec3b &obj_color) {
    int cmax = 0, cmin = INT_MAX, rmax = 0, rmin = INT_MAX;

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (img(i, j) == obj_color) {
                rmax = max(rmax, i);
                rmin = min(rmin, i);
                cmax = max(cmax, j);
                cmin = min(cmin, j);
            }
        }
    }

    return (cmax - cmin + 1.0) / (rmax - rmin + 1.0);
}

Mat_<Vec3b> compute_projections(const Mat_<Vec3b> &img, const Vec3b &obj_color) {
    int H[1000], V[1000], temp = 0;
    Mat_<Vec3b> projection_img(img.rows, img.cols, Vec3b(255, 255, 255));

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (img(i, j) == obj_color) {
                temp++;
            }
        }

        H[i] = temp;
        temp = 0;
    }

    for (int j = 0; j < img.cols; j++) {
        for (int i = 0; i < img.rows; i++) {
            if (img(i, j) == obj_color) {
                temp++;
            }
        }

        V[j] = temp;
        temp = 0;
    }

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < H[i]; j++) {
            projection_img(i, j) = obj_color;
        }
    }

    for (int j = 0; j < img.cols; j++) {
        for (int i = 0; i < V[j]; i++) {
            projection_img(i, j) = obj_color;
        }
    }

    return projection_img;
}

void on_mouse(int event, int y, int x, int flags, void *param) {
    Mat_<Vec3b> img = *((Mat_<Vec3b> *) param);

    if (event == CV_EVENT_LBUTTONDOWN) {
        Vec3b obj_color = img(x, y);

        auto area = compute_area(img, obj_color);
        auto center_of_mass = compute_center_of_mass(img, obj_color, area);
        auto elongation_axis = compute_orientation(img, obj_color, area, center_of_mass);
        auto perimeter = compute_perimeter(img, obj_color);
        auto thinness = compute_thinness(area, perimeter.first);
        auto aspect_ratio = compute_aspect_ratio(img, obj_color);

        std::cout << "Area = " << area << std::endl;
        std::cout << "Center of mass: row = " << center_of_mass.first << ", col = " << center_of_mass.second
                  << std::endl;
        std::cout << "Elongation = " << elongation_axis << std::endl;
        std::cout << "Perimeter = " << perimeter.first << std::endl;
        std::cout << "Thinness = " << thinness << std::endl;
        std::cout << "Aspect ratio = " << aspect_ratio << std::endl;

        Mat_<Vec3b> cloned_img(img.rows, img.cols);

        cloned_img += perimeter.second;
        cloned_img(center_of_mass.first, center_of_mass.second) = obj_color;
        draw_elongation_line(cloned_img, obj_color, elongation_axis, center_of_mass);

        imshow("Geometric Features of Image", cloned_img);
        imshow("Projections", compute_projections(img, obj_color));
    }
}

void remove_object(Mat_<Vec3b> img, const Vec3b &obj_color) {
    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            if (img(i, j) == obj_color) {
                img(i, j) = Vec3b(255, 255, 255);
            }
        }
    }
}

std::vector<Vec3b> get_objects_by_color(const Mat_<Vec3b> &img) {
    std::vector<Vec3b> obj_colors;

    for (int i = 0; i < img.rows; i++) {
        for (int j = 0; j < img.cols; j++) {
            Vec3b obj_color = img(i, j);

            if (obj_color != Vec3b(255, 255, 255) &&
                std::find(obj_colors.begin(), obj_colors.end(), obj_color) == obj_colors.end()) {
                obj_colors.push_back(obj_color);
            }
        }
    }

    return obj_colors;
}

void remove_objects_by_area(const Mat_<Vec3b> &img, int threshold) {
    auto cloned_img = img.clone();
    auto obj_colors = get_objects_by_color(img);

    for (const Vec3b &color : obj_colors) {
        if (compute_area(img, color) < threshold) {
            remove_object(cloned_img, color);
        }
    }

    imshow("Threshold area", cloned_img);
}

void remove_objects_by_orientation(const Mat_<Vec3b> &img, double phi_low, double phi_high) {
    auto cloned_img = img.clone();
    auto obj_colors = get_objects_by_color(img);

    for (const Vec3b &color : obj_colors) {
        int area = compute_area(img, color);
        double orientation = compute_orientation(img, color, area, compute_center_of_mass(img, color, area));

        if (orientation >= phi_high || orientation <= phi_low) {
            remove_object(cloned_img, color);
        }
    }

    imshow("Threshold orientation", cloned_img);
}
vector<Point> findContour(Mat_<uchar> img, vector<int> &dirs, vector<int> &derivatives)
{
    int di[8] = {
            0, -1, -1, -1, 0, 1, 1, 1
    };

    int dj[8] = {
            1, 1, 0, -1, -1, -1, 0, 1
    };

    vector<Point> points;
    int i, j;
    boolean found = false;

    //primul pixel din obiect
    for (i = 0; i < img.rows; i++)
    {
        for (j = 0; j < img.cols; j++)
        {
            if (img(i, j) == 0)
            {
                found = true;
                break;
            }
        }

        if (found == true)
            break;
    }

    points.push_back(Point(i, j));
    int dir = 7; //directia precedenta
    boolean finished = false;

    while(!finished)
    {
        int dir0 = (dir + 7) % 8;
        if (dir % 2)
        {
            dir0 = (dir + 6) % 8;
        }

        for (int k = 0; k < 8; k++) //se parcurge vecinatatea
        {
            int dir_now = (dir0 + k) % 8;

            int i2 = i + di[dir_now];
            int j2 = j + dj[dir_now];

            if (isInside(img, i2, j2) && img(i2, j2)==0) //inside and black
            {
                dirs.push_back(dir_now);
                points.push_back(Point(i2, j2));
                derivatives.push_back((dir - dir0 + 😎 % 8);
                dir = dir_now;
                i = i2;
                j = j2;

                break;
            }
        }

        int size = points.size();
        finished = (size > 4 && (points.at(1) == points.at(size - 1)) && (points.at(0) == points.at(size - 2)));
    }

    return points;
}
Mat_<uchar> border_tracing(const Mat_<uchar> &img, const uchar &obj_color, std::vector<int> &directions,
                           std::vector<int> &derivatives) {
    int dir = 7, prev_dir = 0, size = 1;
    std::vector<Point2i> obj_contours;
    Mat_<uchar> result_img(img.rows, img.cols, (uchar) 255);
    Point2i dir_point_map[8] = {
            {0,  1},
            {-1, 1},
            {-1, 0},
            {-1, -1},
            {0,  -1},
            {1,  -1},
            {1,  0},
            {1,  1}
    };

    for (int i = 0; i < img.rows; ++i) {
        for (int j = 0; j < img.cols; ++j) {
            if (img(i, j) == obj_color) {
                obj_contours.emplace_back(i, j);
                goto label_break;
            }
        }
    }

    label_break:
    while (size < 4 || obj_contours[0] != obj_contours[size - 2] || obj_contours[1] != obj_contours[size - 1]) {
        int i;
        auto current_element = obj_contours[size - 1];
        dir = (dir % 2 != 0) ? (dir + 6) % 8 : (dir + 7) % 8;

        for (i = 0; i < 8; ++i) {
            auto next_element = current_element + dir_point_map[(dir + i) % 8];

            if (img(next_element.x, next_element.y) == obj_color) {
                obj_contours.emplace_back(next_element);
                ++size;
                dir = (dir + i) % 8;
                directions.emplace_back(dir);
                derivatives.emplace_back((prev_dir > dir) ? dir - prev_dir + 8 : dir - prev_dir);
                break;
            }
        }

        prev_dir = dir;
    }

    directions.erase(directions.end() - 2, directions.end());
    derivatives.erase(derivatives.end() - 2, derivatives.end());
    derivatives.erase(derivatives.begin(), derivatives.begin() + 1);

    for (const auto &pos : obj_contours) {
        result_img(pos.x, pos.y) = obj_color;
    }

    return result_img;
}
//Iuby's
int main() {
    Mat_<Vec3b> img = imread("Images/trasaturi_geom.bmp", CV_LOAD_IMAGE_COLOR);
    auto *histogram = get_histogram(img);
    auto *pdf = compute_pdf(histogram, img);
    auto *converted_histogram = convert_histogram(histogram, 128);

    showHistogram("Intensity Histogram", histogram, 256, 300);
    showHistogram("128 bins Histogram", converted_histogram, 128, 300);

    auto thresholded_img = multi_level_thresholding(img);

    imshow("After Multilevel Thresholding", thresholded_img);
    imshow("Image", img);

    floyd_steinberg(img);

    imshow("After Floyd-Steinberg", img);

    free(histogram);
    free(pdf);
    free(converted_histogram);

    setMouseCallback("Image",on_mouse,&img);
    waitKey(0);
}