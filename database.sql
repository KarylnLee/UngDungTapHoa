CREATE DATABASE TapHoaOnlineDB;
USE TapHoaOnlineDB;

## Người dùng và xác thực
CREATE TABLE Users (
    UserId INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    PasswordHash VARCHAR(255),
    AuthProvider ENUM('local', 'google', 'facebook'),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsActive BOOLEAN DEFAULT TRUE
);

CREATE TABLE OTP (
    OtpId INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    Code VARCHAR(10),
    Expiry DATETIME,
    Type ENUM('email', 'sms'),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE TABLE ShippingAddresses (
    ShippingAddressId INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    FullAddress TEXT,
    IsDefault BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

## Sản phẩm & đặt hàng
CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    IconUrl TEXT
);

CREATE TABLE Products (
    ProductId INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    CategoryId INT,
    Brand VARCHAR(100),
    Description TEXT,
    Unit VARCHAR(20),
    Stock INT,
    Price DECIMAL(10, 2),
    ImageURL TEXT,
    RatingAvg FLOAT DEFAULT 0,
    Ingredients TEXT,
    FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);

CREATE TABLE Coupons (
    CouponId INT PRIMARY KEY AUTO_INCREMENT,
    Code VARCHAR(20) UNIQUE,
    DiscountValue DECIMAL(10, 2),
    ExpiryDate DATE,
    MinOrderAmount DECIMAL(10, 2),
    IsActive BOOLEAN DEFAULT TRUE
);

CREATE TABLE Orders (
    OrderId INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    ShippingMethod VARCHAR(100),
    ShippingFee DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    Status ENUM('pending', 'delivering', 'completed', 'cancelled'),
    PaymentMethod ENUM('cash', 'momo', 'zalopay', 'bank'),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    DeliveryRating INT DEFAULT NULL,
    ShipperRating INT DEFAULT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (AddressId) REFERENCES ShippingAddresses(ShippingAddressId)
);



CREATE TABLE OrderDetails (
    OrderDetailId INT PRIMARY KEY AUTO_INCREMENT,
    OrderId INT,
    ProductId INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);

## Lịch sử tìm kiếm
CREATE TABLE SearchHistory (
    SearchHistoryId INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    Keyword VARCHAR(100),
    SearchedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

## Giỏ hàng
CREATE TABLE CartItems (
    CartItemId INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    ProductId INT,
    Quantity INT,
    IsSelected BOOLEAN DEFAULT TRUE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);

## Vận chuyển & giao hàng
CREATE TABLE DeliveryTracking (
    DeliveryTrackingId INT PRIMARY KEY AUTO_INCREMENT,
    OrderId INT,
    CurrentStatus VARCHAR(100),
    Location TEXT,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
);

CREATE TABLE DeliveryChat (
    ChatId INT PRIMARY KEY AUTO_INCREMENT,
    OrderId INT,
    Sender ENUM('user', 'shipper'),
    Message TEXT,
    SentAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
);

## Quản lý đơn hàng
CREATE TABLE ReturnRequests (
    ReturnRequestId INT PRIMARY KEY AUTO_INCREMENT,
    OrderId INT,
    Reason TEXT,
    Status ENUM('pending', 'approved', 'rejected'),
    RequestedAt DATETIME,
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
);

## Tương tác người dùng
CREATE TABLE Reviews (
    ReviewId INT PRIMARY KEY AUTO_INCREMENT,
    ProductId INT,
    UserId INT,
    Rating INT,
    Comment TEXT,
    ImageURL TEXT,
    CreatedAt DATETIME,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE TABLE QnA (
    QnAId INT PRIMARY KEY AUTO_INCREMENT,
    ProductId INT,
    UserId INT,
    Question TEXT,
    Answer TEXT,
    AskedAt DATETIME,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

## Admin
CREATE TABLE Admins (
    AdminId INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    Role ENUM('superadmin', 'moderator'),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE TABLE SystemFeedback (
    FeedbackId INT PRIMARY KEY AUTO_INCREMENT,
    UserId INT,
    Message TEXT,
    CreatedAt DATETIME,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

## Thêm dữ liệu mẫu
INSERT INTO Categories (Name, IconUrl) VALUES
('Thịt heo', 'thitheo.png'),
('Thịt bò', 'thitbo.png'),
('Thịt gà', 'thitga.png'),
('Thịt sơ chế', 'thitsoche.png'),
('Hải sản', 'haisan.png'),
('Trứng', 'trung.png'),
('Trái cây', 'traicay.png'),
('Rau lá', 'raula.png'),
('Củ, quả', 'cuqua.png'),
('Nấm', 'nam.png'),
('Rau làm sẵn', 'raulamsan.png'),
('Dầu gội', 'daugoi.png'),
('Sữa tắm', 'suatam.png'),
('Kem đánh răng', 'kemdanhrang.png'),
('Bàn chải, tăm', 'banchaitam.png'),
('Giấy vệ sinh', 'giayvesinh.png'),
('Dầu xả', 'dauxa.png'),
('Băng vệ sinh', 'bangvesinh.png'),
('Dao cạo', 'daocao.png'),
('Túi rác', 'tuirac.png'),
('Nồi, chảo', 'noichao.png'),
('Dụng cụ bếp', 'dungcubep.png'),
('Quạt', 'quat.png'),
('Cây lau nhà', 'caylaunha.png'),
('Nước rửa chén', 'nuocrua.png'),
('Nước lau nhà', 'nuoclaunha.png'),
('Bột giặt', 'botgiat.png'),
('Nước xả', 'nuocxa.png'),
('Nước tẩy', 'nuoctay.png'),
('Gạo', 'gao.png'),
('Xúc xích', 'xucxich.png'),
('Bột', 'bot.png'),
('Ngũ cốc', 'ngucoc.png'),
('Rong biển', 'rongbien.png'),
('Dầu ăn', 'dauan.png'),
('Nước mắm', 'nuocmam.png'),
('Nước tương', 'nuoctuong.png'),
('Muối', 'muoi.png'),
('Sả tế', 'sate.png'),
('Hạt nêm', 'hatnem.png'),
('Snack', 'snack.png'),
('Kẹo', 'keo.png'),
('Sữa', 'sua.png'),
('Trái cây sấy', 'traicaysay.png'),
('Nước', 'nuoc.png');

-- Thêm dữ liệu mẫu cho Products
INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Ba rọi heo', CategoryId, 'ThitSach', 'Thịt ba rọi heo tươi ngon, chất lượng cao.', 'kg', 100, 120000, 'Thịt heo, muối'
FROM Categories WHERE Name = 'Thịt heo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Tôm sú', CategoryId, 'SeaFresh', 'Tôm sú tươi ngon, kích thước lớn.', 'kg', 50, 300000, 'Tôm, muối'
FROM Categories WHERE Name = 'Hải sản';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Cá hồi phi lê', CategoryId, 'NorSalmon', 'Cá hồi Na Uy phi lê không xương.', 'kg', 50, 290000, 'Cá hồi, muối'
FROM Categories WHERE Name = 'Thịt sơ chế';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Trứng gà ta (10 quả)', CategoryId, 'FarmEgg', 'Trứng gà ta sạch, bổ dưỡng.', 'hộp', 150, 38000, 'Trứng gà'
FROM Categories WHERE Name = 'Trứng';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT '7up', CategoryId, 'PepsiCo', 'Nước ngọt có gas 7up 500ml.', 'chai', 200, 10000, 'Nước, đường, CO2'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Ba chỉ bò mỹ', CategoryId, 'USBeef', 'Ba chỉ bò Mỹ nhập khẩu, mềm và thơm.', 'kg', 80, 280000, 'Thịt bò, gia vị'
FROM Categories WHERE Name = 'Thịt bò';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Bàn chải lông mềm', CategoryId, 'OralB', 'Bàn chải đánh răng lông mềm.', 'cái', 300, 25000, 'Nhựa, lông nylon'
FROM Categories WHERE Name = 'Bàn chải, tăm';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Diana ban đêm 8 miếng', CategoryId, 'Diana', 'Băng vệ sinh ban đêm 8 miếng.', 'gói', 100, 45000, 'Bông, màng chống thấm'
FROM Categories WHERE Name = 'Băng vệ sinh';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Diana ban ngày 8 miếng', CategoryId, 'Diana', 'Băng vệ sinh ban ngày 8 miếng.', 'gói', 150, 40000, 'Bông, màng chống thấm'
FROM Categories WHERE Name = 'Băng vệ sinh';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Bộ dao thớt inox', CategoryId, 'Sunhouse', 'Bộ dao và thớt inox chất lượng cao.', 'bộ', 50, 150000, 'Inox'
FROM Categories WHERE Name = 'Dụng cụ bếp';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Bộ nồi inox 3day', CategoryId, 'Sunhouse', 'Bộ nồi inox 3 đáy bền bỉ.', 'bộ', 30, 800000, 'Inox'
FROM Categories WHERE Name = 'Nồi, chảo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Bột Mì Meizan', CategoryId, 'Meizan', 'Bột mì chất lượng cao 1kg.', 'gói', 200, 20000, 'Bột mì'
FROM Categories WHERE Name = 'Bột';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Bột năng Miwon', CategoryId, 'Miwon', 'Bột năng tinh khiết 400g.', 'gói', 150, 15000, 'Bột năng'
FROM Categories WHERE Name = 'Bột';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Cam sành', CategoryId, 'Organic', 'Cam sành tươi ngon 1kg.', 'kg', 100, 40000, 'Cam'
FROM Categories WHERE Name = 'Trái cây';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Cánh gà giữa nhập khẩu', CategoryId, 'USChicken', 'Cánh gà giữa nhập khẩu đông lạnh.', 'kg', 70, 180000, 'Thịt gà'
FROM Categories WHERE Name = 'Thịt gà';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Cà rốt', CategoryId, 'Organic', 'Cà rốt tươi sạch 1kg.', 'kg', 200, 25000, 'Cà rốt'
FROM Categories WHERE Name = 'Củ, quả';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Cây chổi bông đót', CategoryId, 'HomeCare', 'Chổi bông đót chất lượng.', 'cái', 50, 30000, 'Gỗ, bông đót'
FROM Categories WHERE Name = 'Cây lau nhà';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Cây lau nhà 360 độ', CategoryId, 'HomeCare', 'Cây lau nhà xoay 360 độ.', 'cái', 40, 120000, 'Nhựa, vải'
FROM Categories WHERE Name = 'Cây lau nhà';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Chảo chống dính Sunhouse', CategoryId, 'Sunhouse', 'Chảo chống dính 28cm.', 'cái', 60, 250000, 'Nhôm, lớp chống dính'
FROM Categories WHERE Name = 'Nồi, chảo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'chuối già', CategoryId, 'Organic', 'Chuối già chín tự nhiên 1kg.', 'kg', 150, 30000, 'Chuối'
FROM Categories WHERE Name = 'Trái cây';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Chuối sấy Ropro', CategoryId, 'Ropro', 'Chuối sấy tự nhiên 200g.', 'gói', 100, 40000, 'Chuối, đường'
FROM Categories WHERE Name = 'Trái cây sấy';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Coca', CategoryId, 'CocaCola', 'Nước ngọt có gas Coca 500ml.', 'chai', 250, 10000, 'Nước, đường, CO2'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước giặt Comfort', CategoryId, 'Comfort', 'Nước giặt hương nước hoa 2L.', 'chai', 80, 70000, 'Chất tẩy, hương liệu'
FROM Categories WHERE Name = 'Bột giặt';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Dao cạo Gillette', CategoryId, 'Gillette', 'Dao cạo râu Gillette 4 lưỡi.', 'cái', 120, 150000, 'Thép, nhựa'
FROM Categories WHERE Name = 'Dao cạo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Dầu gội Romano 650ml', CategoryId, 'Romano', 'Dầu gội nam 650ml.', 'chai', 90, 60000, 'Nước, chất tẩy, hương liệu'
FROM Categories WHERE Name = 'Dầu gội';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Dầu gội Sunsilk 650ml', CategoryId, 'Sunsilk', 'Dầu gội cho tóc dài 650ml.', 'chai', 100, 70000, 'Nước, chất tẩy, hương liệu'
FROM Categories WHERE Name = 'Dầu gội';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Dầu xả Dove 320ml', CategoryId, 'Dove', 'Dầu xả dưỡng tóc 320ml.', 'chai', 150, 50000, 'Nước, dưỡng chất'
FROM Categories WHERE Name = 'Dầu xả';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Dầu ăn Neptune', CategoryId, 'Neptune', 'Dầu ăn tinh luyện 1L.', 'chai', 200, 45000, 'Dầu thực vật'
FROM Categories WHERE Name = 'Dầu ăn';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Dầu đậu nành', CategoryId, 'Simply', 'Dầu đậu nành 1L.', 'chai', 180, 40000, 'Dầu đậu nành'
FROM Categories WHERE Name = 'Dầu ăn';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Dầu gội Clear', CategoryId, 'Clear', 'Dầu gội trị gàu 650ml.', 'chai', 110, 65000, 'Nước, chất tẩy, hương liệu'
FROM Categories WHERE Name = 'Dầu gội';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Dưa hấu', CategoryId, 'Organic', 'Dưa hấu tươi ngon 1kg.', 'kg', 120, 25000, 'Dưa hấu'
FROM Categories WHERE Name = 'Trái cây';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Fanta', CategoryId, 'CocaCola', 'Nước ngọt có gas Fanta 500ml.', 'chai', 220, 10000, 'Nước, đường, CO2'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Gạo Meizan nàng thơm', CategoryId, 'Meizan', 'Gạo nàng thơm 5kg.', 'gói', 150, 120000, 'Gạo'
FROM Categories WHERE Name = 'Gạo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Gạo ST25', CategoryId, 'ST25', 'Gạo ST25 cao cấp 5kg.', 'gói', 100, 150000, 'Gạo'
FROM Categories WHERE Name = 'Gạo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Giấy vệ sinh Bless You', CategoryId, 'BlessYou', 'Giấy vệ sinh 10 cuộn.', 'gói', 80, 60000, 'Giấy'
FROM Categories WHERE Name = 'Giấy vệ sinh';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Hạt nêm knorr', CategoryId, 'Knorr', 'Hạt nêm gà 400g.', 'gói', 200, 25000, 'Muối, gia vị'
FROM Categories WHERE Name = 'Hạt nêm';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Kem đánh răng trà xanh', CategoryId, 'Colgate', 'Kem đánh răng trà xanh 100g.', 'tuýp', 300, 30000, 'Trà xanh, chất tẩy'
FROM Categories WHERE Name = 'Kem đánh răng';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Kem đánh răng ngăn ngừa sâu răng', CategoryId, 'Colgate', 'Kem đánh răng chống sâu răng 100g.', 'tuýp', 250, 32000, 'Fluoride, chất tẩy'
FROM Categories WHERE Name = 'Kem đánh răng';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Kem đánh răng thanh hoạt tính', CategoryId, 'Sensodyne', 'Kem đánh răng thanh nhiệt 100g.', 'tuýp', 200, 50000, 'Chất tẩy, hương liệu'
FROM Categories WHERE Name = 'Kem đánh răng';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Kẹo Alpenliebe Caramen', CategoryId, 'Alpenliebe', 'Kẹo caramen 100g.', 'gói', 150, 15000, 'Đường, caramen'
FROM Categories WHERE Name = 'Kẹo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Kẹo dẻo', CategoryId, 'Haribo', 'Kẹo dẻo trái cây 200g.', 'gói', 120, 40000, 'Đường, gelatin'
FROM Categories WHERE Name = 'Kẹo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Khoai tây', CategoryId, 'Organic', 'Khoai tây tươi 1kg.', 'kg', 180, 30000, 'Khoai tây'
FROM Categories WHERE Name = 'Củ, quả';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Lá kim cuốn cơm Ofood', CategoryId, 'Ofood', 'Lá kim sấy khô 100g.', 'gói', 90, 35000, 'Lá kim'
FROM Categories WHERE Name = 'Rong biển';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Mirinda xá xị', CategoryId, 'PepsiCo', 'Nước ngọt Mirinda xá xị 500ml.', 'chai', 200, 10000, 'Nước, đường, CO2'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Mít sấy Vinamit', CategoryId, 'Vinamit', 'Mít sấy tự nhiên 200g.', 'gói', 110, 45000, 'Mít, đường'
FROM Categories WHERE Name = 'Trái cây sấy';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Mực ống', CategoryId, 'SeaFresh', 'Mực ống tươi ngon 1kg.', 'kg', 60, 350000, 'Mực'
FROM Categories WHERE Name = 'Hải sản';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Muối hạt Vĩnh hảo', CategoryId, 'VinhHao', 'Muối hạt tinh khiết 1kg.', 'gói', 300, 10000, 'Muối'
FROM Categories WHERE Name = 'Muối';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nấm kim châm', CategoryId, 'Organic', 'Nấm kim châm tươi 200g.', 'gói', 150, 25000, 'Nấm'
FROM Categories WHERE Name = 'Nấm';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nếp chùm Vinh Hiển', CategoryId, 'VinhHien', 'Nếp chùm 5kg.', 'gói', 80, 130000, 'Gạo nếp'
FROM Categories WHERE Name = 'Gạo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Ngũ cốc Milo', CategoryId, 'Milo', 'Ngũ cốc Milo 400g.', 'gói', 120, 50000, 'Ngũ cốc, đường'
FROM Categories WHERE Name = 'Ngũ cốc';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nho mẫu đơn', CategoryId, 'Organic', 'Nho mẫu đơn 1kg.', 'kg', 100, 120000, 'Nho'
FROM Categories WHERE Name = 'Trái cây';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước cốt dừa nguyên chất', CategoryId, 'Coconut', 'Nước cốt dừa 400ml.', 'chai', 90, 30000, 'Dừa, nước'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước gạo rang', CategoryId, 'Vifon', 'Nước gạo rang 500ml.', 'chai', 200, 15000, 'Gạo rang, nước'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước giặt Omo', CategoryId, 'Omo', 'Nước giặt Omo 2L.', 'chai', 100, 75000, 'Chất tẩy, hương liệu'
FROM Categories WHERE Name = 'Bột giặt';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước khoáng Vĩnh hảo', CategoryId, 'VinhHao', 'Nước khoáng 500ml.', 'chai', 300, 7000, 'Nước khoáng'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước lau nhà', CategoryId, 'Pach', 'Nước lau nhà hương chanh 2L.', 'chai', 80, 40000, 'Chất tẩy, hương liệu'
FROM Categories WHERE Name = 'Nước lau nhà';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước mắm Nam ngư', CategoryId, 'NamNgu', 'Nước mắm cá cơm 500ml.', 'chai', 150, 35000, 'Cá cơm, muối'
FROM Categories WHERE Name = 'Nước mắm';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước rửa chén', CategoryId, 'Sunlight', 'Nước rửa chén Sunlight 900ml.', 'chai', 200, 30000, 'Chất tẩy, hương liệu'
FROM Categories WHERE Name = 'Nước rửa chén';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước suối Lavie', CategoryId, 'Lavie', 'Nước suối tinh khiết 500ml.', 'chai', 400, 7000, 'Nước'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước tẩy Javel', CategoryId, 'Vifon', 'Nước tẩy Javel 1L.', 'chai', 100, 20000, 'Clorine'
FROM Categories WHERE Name = 'Nước tẩy';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Nước tương Maggi', CategoryId, 'Maggi', 'Nước tương 500ml.', 'chai', 150, 25000, 'Đậu nành, muối'
FROM Categories WHERE Name = 'Nước tương';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Pepsi', CategoryId, 'PepsiCo', 'Nước ngọt Pepsi 500ml.', 'chai', 230, 10000, 'Nước, đường, CO2'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Quạt cây 5 cánh', CategoryId, 'Senko', 'Quạt cây 5 cánh 50W.', 'cái', 40, 700000, 'Nhựa, kim loại'
FROM Categories WHERE Name = 'Quạt';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Quạt mini để bàn', CategoryId, 'Senko', 'Quạt mini để bàn 20W.', 'cái', 60, 250000, 'Nhựa, kim loại'
FROM Categories WHERE Name = 'Quạt';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Rau cải ngọt', CategoryId, 'Organic', 'Rau cải ngọt tươi 500g.', 'gói', 200, 15000, 'Rau cải'
FROM Categories WHERE Name = 'Rau lá';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Rau củ trộn salad', CategoryId, 'Organic', 'Rau củ trộn salad 300g.', 'gói', 150, 25000, 'Rau, củ'
FROM Categories WHERE Name = 'Rau làm sẵn';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Rau muống', CategoryId, 'Organic', 'Rau muống tươi 500g.', 'gói', 250, 12000, 'Rau muống'
FROM Categories WHERE Name = 'Rau lá';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Sa tế tôm', CategoryId, 'ChinSu', 'Sa tế tôm 100g.', 'gói', 120, 20000, 'Tôm, ớt, dầu'
FROM Categories WHERE Name = 'Sả tế';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Snack khoai tây', CategoryId, 'Oishi', 'Snack khoai tây 50g.', 'gói', 300, 10000, 'Khoai tây, dầu'
FROM Categories WHERE Name = 'Snack';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Snack tôm vị cay Nóng Oishi', CategoryId, 'Oishi', 'Snack tôm cay 50g.', 'gói', 250, 12000, 'Tôm, gia vị'
FROM Categories WHERE Name = 'Snack';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Sting', CategoryId, 'PepsiCo', 'Nước tăng lực Sting 250ml.', 'chai', 200, 8000, 'Nước, đường, cafein'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Sữa tắm Hazeline', CategoryId, 'Hazeline', 'Sữa tắm dưỡng da 500ml.', 'chai', 90, 60000, 'Nước, dưỡng chất'
FROM Categories WHERE Name = 'Sữa tắm';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Sữa tắm Lifebouy', CategoryId, 'Lifebouy', 'Sữa tắm diệt khuẩn 500ml.', 'chai', 100, 55000, 'Nước, chất tẩy'
FROM Categories WHERE Name = 'Sữa tắm';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Sữa đặt ông thọ', CategoryId, 'OngTho', 'Sữa đặc Ông Thọ 380g.', 'lon', 150, 30000, 'Sữa, đường'
FROM Categories WHERE Name = 'Sữa';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Sữa tươi TH', CategoryId, 'TH', 'Sữa tươi không đường 1L.', 'chai', 200, 25000, 'Sữa bò'
FROM Categories WHERE Name = 'Sữa';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Sườn non heo', CategoryId, 'ThitSach', 'Sườn non heo tươi 1kg.', 'kg', 90, 150000, 'Thịt heo'
FROM Categories WHERE Name = 'Thịt heo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Tăm chỉ nha khoa Oraltree', CategoryId, 'Oraltree', 'Tăm chỉ nha khoa 50m.', 'cuộn', 200, 40000, 'Nhựa, sợi'
FROM Categories WHERE Name = 'Bàn chải, tăm';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Táo Mỹ', CategoryId, 'Organic', 'Táo Mỹ tươi 1kg.', 'kg', 120, 100000, 'Táo'
FROM Categories WHERE Name = 'Trái cây';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Thịt gà nguyên con', CategoryId, 'USChicken', 'Thịt gà nguyên con đông lạnh.', 'con', 60, 200000, 'Thịt gà'
FROM Categories WHERE Name = 'Thịt gà';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Thịt xay', CategoryId, 'ThitSach', 'Thịt xay heo tươi 500g.', 'gói', 150, 70000, 'Thịt heo'
FROM Categories WHERE Name = 'Thịt heo';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Trà ô long', CategoryId, 'Lipton', 'Trà ô long 500ml.', 'chai', 180, 12000, 'Trà, nước'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Trà xanh 0 độ', CategoryId, '0Degree', 'Trà xanh không độ 500ml.', 'chai', 200, 10000, 'Trà, nước'
FROM Categories WHERE Name = 'Nước';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Trứng cút', CategoryId, 'FarmEgg', 'Trứng cút 20 quả.', 'hộp', 100, 30000, 'Trứng cút'
FROM Categories WHERE Name = 'Trứng';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Trứng vịt', CategoryId, 'FarmEgg', 'Trứng vịt 10 quả.', 'hộp', 120, 35000, 'Trứng vịt'
FROM Categories WHERE Name = 'Trứng';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Túi rác', CategoryId, 'HomeCare', 'Túi rác 30L 10 cái.', 'gói', 200, 20000, 'Nhựa'
FROM Categories WHERE Name = 'Túi rác';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Tương ớt Chin-su', CategoryId, 'ChinSu', 'Tương ớt 200g.', 'gói', 150, 15000, 'Ớt, đường'
FROM Categories WHERE Name = 'Sả tế';

INSERT INTO Products (Name, CategoryId, Brand, Description, Unit, Stock, Price, Ingredients)
SELECT 'Xúc xích', CategoryId, 'Vinameat', 'Xúc xích heo 500g.', 'gói', 100, 60000, 'Thịt heo, gia vị'
FROM Categories WHERE Name = 'Xúc xích';

-- Cập nhật ImageURL cho các sản phẩm
UPDATE Products SET ImageURL = 'http://localhost:5257/images/baroiheo.jpg' WHERE Name = 'Ba rọi heo';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/tomsu.jpg' WHERE Name = 'Tôm sú';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/cahoi.jpg' WHERE Name = 'Cá hồi phi lê';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/trunggata.jpg' WHERE Name = 'Trứng gà ta (10 quả)';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/7up.jpg' WHERE Name = '7up';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/bachibomy.jpg' WHERE Name = 'Ba chỉ bò mỹ';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/banchailongmem.jpg' WHERE Name = 'Bàn chải lông mềm';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Diana ban dem 8m.jpg' WHERE Name = 'Diana ban đêm 8 miếng';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Diana ban ngay 8m.jpg' WHERE Name = 'Diana ban ngày 8 miếng';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Bo dao thot Inox.jpg' WHERE Name = 'Bộ dao thớt inox';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/bonoiinox3day.jpg' WHERE Name = 'Bộ nồi inox 3day';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/botmiMeizan.jpg' WHERE Name = 'Bột Mì Meizan';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/botnangmiwon.jpg' WHERE Name = 'Bột năng Miwon';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/camsanh.jpg' WHERE Name = 'Cam sành';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/canhgagiuanhapkhau.jpg' WHERE Name = 'Cánh gà giữa nhập khẩu';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/carot.jpg' WHERE Name = 'Cà rốt';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/choi bong dot.jpg' WHERE Name = 'Cây chổi bông đót';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/caylaunha360do.jpg' WHERE Name = 'Cây lau nhà 360 độ';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/ChaochongdinhSunhouse.jpg' WHERE Name = 'Chảo chống dính Sunhouse';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/chuoigia.jpg' WHERE Name = 'chuối già';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/chuoisayroprop.jpg' WHERE Name = 'Chuối sấy Ropro';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/coca.jpg' WHERE Name = 'Coca';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Comfortgiatdamdat.jpg' WHERE Name = 'Nước giặt Comfort';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/DaocaoGillette.jpg' WHERE Name = 'Dao cạo Gillette';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Dau goi Romano 650ml.png' WHERE Name = 'Dầu gội Romano 650ml';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Dau goi Sunsilk 650ml.jpg' WHERE Name = 'Dầu gội Sunsilk 650ml';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Dau xa Dove 320ml.jpg' WHERE Name = 'Dầu xả Dove 320ml';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/dauanneptune.jpg' WHERE Name = 'Dầu ăn Neptune';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Daudaunanh.jpg' WHERE Name = 'Dầu đậu nành';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/daugoiclear.jpg' WHERE Name = 'Dầu gội Clear';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/duahau.jpg' WHERE Name = 'Dưa hấu';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Fanta.jpg' WHERE Name = 'Fanta';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/GaoMeizannangthom.jpg' WHERE Name = 'Gạo Meizan nàng thơm';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/GaoST25.jpg' WHERE Name = 'Gạo ST25';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Giay ve sinh Bless You.jpg' WHERE Name = 'Giấy vệ sinh Bless You';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/hatnemknorr.jpg' WHERE Name = 'Hạt nêm knorr';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Kemdanhrangtraxanh.jpg' WHERE Name = 'Kem đánh răng trà xanh';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Kemdanhrangngannguasaurang.jpg' WHERE Name = 'Kem đánh răng ngăn ngừa sâu răng';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Kemdanhrangthanhoattinh.jpg' WHERE Name = 'Kem đánh răng thanh hoạt tính';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Keo Alpenliebe Caramen.jpg' WHERE Name = 'Kẹo Alpenliebe Caramen';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/keodeo.jpg' WHERE Name = 'Kẹo dẻo';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/khoaitay.jpg' WHERE Name = 'Khoai tây';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/lakimcuoncomofood.jpg' WHERE Name = 'Lá kim cuốn cơm Ofood';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/mirindaxaxi.jpg' WHERE Name = 'Mirinda xá xị';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/mitsayvinamit.jpg' WHERE Name = 'Mít sấy Vinamit';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/mucong.jpg' WHERE Name = 'Mực ống';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/muoihatvinhhao.jpg' WHERE Name = 'Muối hạt Vĩnh hảo';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/namkimcham.jpg' WHERE Name = 'Nấm kim châm';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nepchum.jpg' WHERE Name = 'Nếp chùm Vinh Hiển';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/ngucocmilo.jpg' WHERE Name = 'Ngũ cốc Milo';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nhomaudon.jpg' WHERE Name = 'Nho mẫu đơn';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuoccotduannguyenchat.jpg' WHERE Name = 'Nước cốt dừa nguyên chất';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuocgaorang.jpg' WHERE Name = 'Nước gạo rang';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuocgiatomo.jpg' WHERE Name = 'Nước giặt Omo';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuockhoangvinhhao.jpg' WHERE Name = 'Nước khoáng Vĩnh hảo';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuoclaunha.jpg' WHERE Name = 'Nước lau nhà';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuocmamnamngu.png' WHERE Name = 'Nước mắm Nam ngư';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuocruachen.jpg' WHERE Name = 'Nước rửa chén';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuocsuoilavie.jpg' WHERE Name = 'Nước suối Lavie';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuoctayjavel.jpg' WHERE Name = 'Nước tẩy Javel';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/nuoctuongmaggi.jpg' WHERE Name = 'Nước tương Maggi';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/pepsi.jpg' WHERE Name = 'Pepsi';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Quat cay 5 canh.jpg' WHERE Name = 'Quạt cây 5 cánh';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Quat min de ban.jpg' WHERE Name = 'Quạt mini để bàn';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/raucaingot.jpg' WHERE Name = 'Rau cải ngọt';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/raucutronsalad.jpg' WHERE Name = 'Rau củ trộn salad';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/raumuong.jpg' WHERE Name = 'Rau muống';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/satetom.jpg' WHERE Name = 'Sa tế tôm';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/snackkhoaitay.jpg' WHERE Name = 'Snack khoai tây';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/snacktomvicaynongoishi.jpg' WHERE Name = 'Snack tôm vị cay Nóng Oishi';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Sting.jpg' WHERE Name = 'Sting';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/SuatamHazeline.jpg' WHERE Name = 'Sữa tắm Hazeline';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/SuatamLifebouy.jpg' WHERE Name = 'Sữa tắm Lifebouy';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/suadacongtho.jpg' WHERE Name = 'Sữa đặt ông thọ';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/suatuoiTH.jpg' WHERE Name = 'Sữa tươi TH';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/suonnonheo.jpg' WHERE Name = 'Sườn non heo';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/Tam chi nha khoa Oraltree.jpg' WHERE Name = 'Tăm chỉ nha khoa Oraltree';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/taomy.jpg' WHERE Name = 'Táo Mỹ';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/thitganguyencon.jpg' WHERE Name = 'Thịt gà nguyên con';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/thitxay.jpg' WHERE Name = 'Thịt xay';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/traolong.jpg' WHERE Name = 'Trà ô long';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/traxanh0do.jpg' WHERE Name = 'Trà xanh 0 độ';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/trungcut.jpg' WHERE Name = 'Trứng cút';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/trungvit.jpg' WHERE Name = 'Trứng vịt';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/tuirac.jpg' WHERE Name = 'Túi rác';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/tuongotchinsu.jpg' WHERE Name = 'Tương ớt Chin-su';
UPDATE Products SET ImageURL = 'http://localhost:5257/images/xucxich.jpg' WHERE Name = 'Xúc xích';


INSERT INTO Admins (UserId, Role) 
VALUES ((SELECT UserId FROM Users WHERE Email = 'admin1@gmail.com'), 'superadmin');

INSERT INTO ShippingAddresses (UserId, FullAddress, IsDefault) 
VALUES ((SELECT UserId FROM Users WHERE Email = 'tuyen2@gmail.com'), '123 Đường Láng, Hà Nội', TRUE),
       ((SELECT UserId FROM Users WHERE Email = 'user2@gmail.com'), '456 Nguyễn Trãi, TP.HCM', FALSE);

INSERT INTO CartItems (UserId, ProductId, Quantity, IsSelected) 
VALUES ((SELECT UserId FROM Users WHERE Email = 'user2@gmail.com'), (SELECT ProductId FROM Products WHERE Name = 'Ba rọi heo'), 2, TRUE),
       ((SELECT UserId FROM Users WHERE Email = 'tuyen2@gmail.com'), (SELECT ProductId FROM Products WHERE Name = 'Trứng gà ta (10 quả)'), 1, FALSE);

INSERT INTO Orders (UserId, AddressId, ShippingMethod, ShippingFee, TotalAmount, Status, PaymentMethod) 
VALUES ((SELECT UserId FROM Users WHERE Email = 'tuyen2@gmail.com'), (SELECT ShippingAddressId FROM ShippingAddresses WHERE FullAddress = '123 Đường Láng, Hà Nội'), 'Grab', 20000, 260000, 'pending', 'momo');

INSERT INTO OrderDetails (OrderId, ProductId, Quantity, UnitPrice) 
VALUES ((SELECT OrderId FROM Orders WHERE UserId = (SELECT UserId FROM Users WHERE Email = 'user2@gmail.com')), (SELECT ProductId FROM Products WHERE Name = 'Ba rọi heo'), 2, 120000);

INSERT INTO Coupons (Code, DiscountValue, ExpiryDate, MinOrderAmount, IsActive) 
VALUES ('SALE2025', 50000, '2025-12-31', 200000, TRUE);

INSERT INTO Reviews (ProductId, UserId, Rating, Comment, ImageURL, CreatedAt) 
VALUES ((SELECT ProductId FROM Products WHERE Name = 'Ba rọi heo'), (SELECT UserId FROM Users WHERE Email = 'user2@gmail.com'), 4, 'Thịt tươi, ngon', 'http://localhost:5257/images/review_baroiheo.jpg', NOW());

INSERT INTO SystemFeedback (UserId, Message) 
VALUES ((SELECT UserId FROM Users WHERE Email = 'user2@gmail.com'), 'Ứng dụng chạy chậm, cần cải thiện.');


SELECT * FROM shippingaddresses;


SELECT * FROM users;

ALTER TABLE Users ADD COLUMN IsActive BOOLEAN DEFAULT TRUE;
ALTER TABLE Products ADD COLUMN Ingredients TEXT;
ALTER TABLE Categories ADD COLUMN IconUrl VARCHAR(255);

ALTER TABLE orders ADD COLUMN DeliveryRating INT DEFAULT 0;


SELECT ProductId, Name, ImageURL FROM Products;







