# Weather-Forecast
Weather Forecast App là một ứng dụng thời tiết cho phép người dùng theo dõi tình hình thời tiết theo thời gian thực ở bất kỳ địa điểm nào trên thế giới. Ứng dụng cung cấp thông tin thời tiết chi tiết, bao gồm nhiệt độ, độ ẩm, tốc độ gió, và dự báo trong nhiều ngày tiếp theo

## Link demo youtube
https://youtu.be/H1jY4WeQlOc
## Link deploy
https://weather-forecast-c1c3c.web.app

## Link github
https://github.com/ndthienKHTN/Weather-Forecast

## Cách chạy project
- Clone project về máy
- Chạy lệnh `flutter pub get` để lấy các package cần thiết
- Chạy project bằng `flutter run`

## Các công nghệ sử dụng
- Flutter
- Provider
- Dio
- Cached Network Image
- Sqflite

## Các tính năng
- Xem thời tiết hiện tại và dự báo thời tiết trong nhiều ngày tiếp theo
- Lưu lại lịch sử tìm kiếm
- Tìm kiếm thời tiết theo tên thành phố
- Xem lại lịch sử tìm kiếm
- Đăng ký và hủy đăng ký thông báo, có hỗ trợ email xác nhận
- Deploy lên Firebase Hosting

## Cấu trúc thư mục 
- models: chứa các model của project
- services: chứa các service lấy dữ liệu từ API của project
- viewmodels: chứa các viewmodel quản lý dữ liệu của project
- views: chứa các view hiển thị dữ liệu của project
- storage: chứa các file lưu trữ dữ liệu của project
- utils: chứa các hàm hỗ trợ khác của project như validator
- widgets: chứa các widget reusable của project
- main.dart: file khởi tạo project