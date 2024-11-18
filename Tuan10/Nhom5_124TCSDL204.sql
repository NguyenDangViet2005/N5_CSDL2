if exists (select * from sys.databases where name = 'N5_CSDL2')
	begin
		use master
		alter database N5_CSDL2 set single_user with rollback immediate
		drop database N5_CSDL2 
	end
create database N5_CSDL2
go
use N5_CSDL2
go
create table KHACHHANG
(
	maKH char(10) primary key,
	tenCongTy nvarchar(50) not null,
	tenGiaoDich nvarchar(50) not null,
	diaChi nvarchar(50) not null,
	Email varchar(30) unique not null,
	SDT char(11) unique not null,
	Fax char(10) unique not null
)
create table DONDATHANG
(
	soHD char(10) primary key,
	maKH char(10) not null,
	maNV char(10) not null,
	ngayDatHang date not null,
	ngayGiaoHang date not null,
	ngayChuyenHang date not null,
	noiGiaoHang nvarchar(50) not null
)

create table NHANVIEN
(
	maNV char(10) primary key,
	Ho nvarchar(10) not null,
	Ten nvarchar(10) not null,
	ngaySinh date not null,
	ngayLamViec date not null,
	diaChi nvarchar(50) not null,
	SDT char(11) unique not null,
	luongCB money not null,
	phuCap money not null
)


create table NHACUNGCAP
(
	maCongTy char(10) primary key,
	tenCongTy nvarchar(50) not null,
	tenGiaoDich nvarchar(50) not null,
	diaChi nvarchar(50) not null,
	SDT char(11) unique not null,
	Fax char(10) unique not null,
	Email varchar(30) unique not null
)
create table CHITIETDATHANG
(
	soHD char(10) not null,
	maHang char(10) not null,
	giaBan decimal(10,2) not null,
	soLuong float not null,
	mucGiamGia decimal(10,2) not null
	primary key(soHD,maHang)
)
create table MATHANG
(
	maHang char(10) primary key,
	tenHang nvarchar(50) not null,
	maCongTy char(10) not null,
	maLoaiHang char(10) not null,
	soLuong int not null,
	donViTinh nvarchar(20) not null,
	giaHang decimal(10,2) not null
)
create table LOAIHANG
(
	maLoaiHang char(10) primary key,
	tenLoaiHang nvarchar(50) not null
)


create table QuocGia
(
	maQG char(5) primary key,
	tenQG Nvarchar(25)
)
--lệnh tạo bảng tỉnh thành
create table TinhThanh
(
	maTT char(5) primary key,
	tenTT Nvarchar(25),
	QGno char(5)not null
)
--lệnh tạo bảng quận huyện
create table QuanHuyen
(
	maQH char(5) primary key,
	tenQH Nvarchar(25),
	TTno char(5) not null 
)
--lệnh tạo bảng phường xã
create table PhuongXa
(
	maPX char(5) primary key,
	tenPX Nvarchar(25),
	QHno char(5) not null
)
--bổ xung column DonDatHang_HoaDon.PXno
ALTER TABLE DONDATHANG
add DDH_PXno char(5),
    soNhaTenDuong nvarchar(50);
--xóa đia column diaChiGiaoHang đã có trước đó
ALTER TABLE DONDATHANG
drop column noiGiaoHang;
--bổ xung column KhachHang.PXno
ALTER TABLE KHACHHANG
add KH_PXno char(5) not null ,
    soNhaTenDuong nvarchar(50) not null ;	
--xóa đia column diaChiKH đã có trước đó
ALTER TABLE KHACHHANG
drop column diaChi;
--bổ xung column diaChiNCC.PXno
ALTER TABLE NHACUNGCAP
add NCC_PXno char(5) not null ,
    soNhaTenDuong nvarchar(50) not null;
--xóa đia column diaChiNCC đã có trước đó
ALTER TABLE NHACUNGCAP
drop column diaChi;
ALTER TABLE NHANVIEN
add NV_PXno char(5) not null ,
    soNhaTenDuong nvarchar(50) not null;
--xóa đia column diaChiNCC đã có trước đó
ALTER TABLE NHANVIEN
drop column diaChi;
-- thêm constraint cho các bảng địa chỉ mới
alter table TinhThanh
	add constraint FK_TinhThanh_QuocGia foreign key (QGno) references QuocGia(maQG) 
		on delete cascade on update cascade
alter table QuanHuyen
	add constraint FK_QuanHuyen_TinhThanh foreign key (TTno) references TinhThanh(maTT)
		on delete cascade on update cascade
alter table PhuongXa
	add constraint FK_PhuongXa_QuanHuyen foreign key (QHno) references QuanHuyen(maQH)
		on delete cascade on update cascade
alter table DONDATHANG
	add constraint FK_DonDatHang_PX foreign key (DDH_PXno) references PhuongXa(maPX)
		on delete no action on update no action
alter table KHACHHANG
	add constraint FK_KhachHang_PX foreign key (KH_PXno) references PhuongXa(maPX)
		on delete no action on update no action
alter table NHACUNGCAP
	add constraint FK_NCC_PX foreign key (NCC_PXno) references PhuongXa(maPX)
		on delete no action on update no action
alter table NHANVIEN
	add constraint FK_NhanVien_PX foreign key (NV_PXno) references PhuongXa(maPX)
		on delete no action on update no action
-- yêu cầu 1 tuần 6
alter table MATHANG
add constraint FK_MACONGTY FOREIGN KEY (maCongTy) REFERENCES NHACUNGCAP(maCongTy)
		on delete cascade
		on update cascade,
	constraint FK_MALOAIHANG FOREIGN KEY (maLoaiHang) REFERENCES LOAIHANG(maLoaiHang)
		on delete cascade 
		on update cascade
alter table DONDATHANG
add constraint FK_MAKHACHHANG FOREIGN KEY (maKH) REFERENCES KHACHHANG(maKH)
		on delete cascade 
		on update cascade,
	constraint FK_MANHANVIEN FOREIGN KEY (maNV) REFERENCES NHANVIEN(maNV)
		on delete no action 
		on update no action

alter table CHITIETDATHANG
add constraint FK_SOHOADON FOREIGN KEY (soHD) REFERENCES DONDATHANG(soHD)
		on delete cascade 
		on update cascade,
	constraint FK_MAHANG FOREIGN KEY (maHang) REFERENCES MATHANG(maHang)
		on delete cascade 
		on update cascade

-- yêu cầu 2 tuần 6:
alter table CHITIETDATHANG
add constraint CK_SoLuong check(soLuong >= 1),default 1 for soLuong,
	constraint CK_MucGiamGia check(mucGiamGia >=0),default 0 for mucGiamGia
-- yêu cầu 3 tuần 6:
alter table DONDATHANG
add constraint CK_NGAYDATHANG_NGAYCHUYENHANG check(ngayChuyenHang>=ngayDatHang),
    constraint CK_NGAYDATHANG_NGAYGIAOHANG check(ngayGiaoHang>=ngayDatHang)
-- yêu cầu 4 tuần 6
alter table NHANVIEN
add constraint CK_NHANVIEN_TUOI CHECK (
    ngaySinh <= DATEADD(YEAR, -18, GETDATE()) and
    ngaySinh >= DATEADD(YEAR, -60, GETDATE()))
-- bổ sung constraint
-- table KHACHHANG
alter table KHACHHANG
add constraint Check_SDT_KhachHang Check(SDT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
                              or SDT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    constraint Check_Email_KhachHang Check(Email like '[a-z]%@%' or Email like '[A-Z]%@%'),
    constraint Check_Fax Check(Fax like  '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ),
    constraint DF_tenCongTy_KhachHang default 'NO name' for tenCongTy
-- table CHITIETDONHANG
alter table CHITIETDATHANG
add constraint Check_giaBan_ChiTietDatHang Check(giaBan >= 0)
-- table MATHANG
alter table MATHANG
add constraint Check_soLuong_MatHang Check(soLuong >= 0)
INSERT INTO QuocGia(maQG, tenQG)
VALUES 
    ('VN', 'Vietnam'),
    ('US', 'United States'),
    ('JP', 'Japan'),
    ('KR', 'South Korea'),
    ('CN', 'China'),
    ('FR', 'France'),
    ('DE', 'Germany'),
    ('IN', 'India'),
    ('IT', 'Italy'),
    ('CA', 'Canada');
INSERT INTO TinhThanh(maTT, tenTT, QGno)
VALUES 
    ('TT01', N'Hà Nội', 'VN'),
    ('TT02', N'Hồ Chí Minh', 'VN'),
    ('TT03', N'Đà Nẵng', 'VN'),
    ('TT04', N'New York', 'US'),
    ('TT05', N'Los Angeles', 'US'),
    ('TT06', N'Tokyo', 'JP'),
    ('TT07', N'Osaka', 'JP'),
    ('TT08', N'Seoul', 'KR'),
    ('TT09', N'Paris', 'FR'),
    ('TT10', N'Berlin', 'DE');
INSERT INTO QuanHuyen(maQH, tenQH, TTno)
VALUES 
    ('QH01', N'Ba Đình', 'TT01'),
    ('QH02', N'Hoàn Kiếm', 'TT01'),
    ('QH03', N'Hai Bà Trưng', 'TT01'),
    ('QH04', N'Quận 1', 'TT02'),
    ('QH05', N'Quận 3', 'TT02'),
    ('QH06', N'Ngũ Hành Sơn', 'TT03'),
    ('QH07', N'Liên Chiểu', 'TT03'),
    ('QH08', N'Manhattan', 'TT04'),
    ('QH09', N'Hollywood', 'TT05'),
    ('QH10', N'Shibuya', 'TT06');
INSERT INTO PhuongXa(maPX, tenPX, QHno)
VALUES 
    ('PX01', N'Phường Điện Biên', 'QH01'),
    ('PX02', N'Phường Cửa Đông', 'QH01'),
    ('PX03', N'Phường Phan Chu Trinh', 'QH02'),
    ('PX04', N'Phường Hàng Bạc', 'QH02'),
    ('PX05', N'Phường Bến Nghé', 'QH04'),
    ('PX06', N'Phường Bến Thành', 'QH04'),
    ('PX07', N'Phường Thảo Điền', 'QH05'),
    ('PX08', N'Phường Thạch Thang', 'QH06'),
    ('PX09', N'Phường Hòa Hiệp', 'QH07'),
    ('PX10', N'Phường Dogenzaka', 'QH10');
INSERT INTO KHACHHANG(maKH, tenCongTy, tenGiaoDich, Email, SDT, Fax, KH_PXno, soNhaTenDuong)
VALUES 
    ('KH01', N'Công ty A', N'Giao dịch A', 'contactA@company.com', '0123456789', '0123456781', 'PX01', N'123 Đường Trần Phú'),
    ('KH02', N'Công ty B', N'Giao dịch B', 'contactB@company.com', '0987654321', '0987654321', 'PX02', N'45 Đường Lý Thái Tổ'),
    ('KH03', N'Công ty C', N'Giao dịch C', 'contactC@company.com', '0111111111', '0111111111', 'PX03', N'78 Đường Nguyễn Huệ'),
    ('KH04', N'Công ty D', N'Giao dịch D', 'contactD@company.com', '0222222222', '0222222221', 'PX04', N'56 Đường Hàng Bông'),
    ('KH05', N'Công ty E', N'Giao dịch E', 'contactE@company.com', '0333333333', '0333333331', 'PX05', N'23 Đường Lê Lợi'),
    ('KH06', N'Công ty F', N'Giao dịch F', 'contactF@company.com', '0444444444', '0444444441', 'PX06', N'89 Đường Hàm Nghi'),
    ('KH07', N'Công ty G', N'Giao dịch G', 'contactG@company.com', '0555555555', '0555555551', 'PX07', N'101 Đường Pasteur'),
    ('KH08', N'Công ty H', N'Giao dịch H', 'contactH@company.com', '0666666666', '0666666661', 'PX08', N'67 Đường Điện Biên Phủ'),
    ('KH09', N'Công ty I', N'Giao dịch I', 'contactI@company.com', '0777777777', '0777777771', 'PX09', N'89 Đường Nguyễn Thị Minh Khai'),
    ('KH10', N'Công ty J', N'Giao dịch J', 'contactJ@company.com', '0888888888', '0888888881', 'PX10', N'12 Đường Dogenzaka');
INSERT INTO NHANVIEN(maNV, Ho, Ten, ngaySinh, ngayLamViec, SDT, luongCB, phuCap, NV_PXno, soNhaTenDuong)
VALUES 
    ('NV01', N'Nguyen', N'An', '1990-05-15', '2015-06-01', '0912345678', 12000000, 1500000, 'PX01', N'15 Đường Trần Phú'),
    ('NV02', N'Tran', N'Binh', '1988-10-22', '2014-08-12', '0934567890', 14000000, 2000000, 'PX02', N'37 Đường Lý Thái Tổ'),
    ('NV03', N'Le', N'Chau', '1992-12-05', '2016-11-25', '0945678901', 13000000, 1800000, 'PX03', N'58 Đường Nguyễn Huệ'),
    ('NV04', N'Pham', N'Dung', '1985-07-18', '2012-04-15', '0956789012', 15000000, 2500000, 'PX04', N'90 Đường Hàng Bông'),
    ('NV05', N'Hoang', N'Em', '1993-03-20', '2017-03-30', '0967890123', 12500000, 1700000, 'PX05', N'120 Đường Lê Lợi'),
    ('NV06', N'Do', N'Phong', '1989-09-17', '2015-01-20', '0978901234', 14500000, 2200000, 'PX06', N'55 Đường Hàm Nghi'),
    ('NV07', N'Vo', N'Giang', '1994-11-30', '2018-09-10', '0989012345', 11000000, 1200000, 'PX07', N'78 Đường Pasteur'),
    ('NV08', N'Dang', N'Hoang', '1987-04-14', '2013-12-05', '0990123456', 16000000, 3000000, 'PX08', N'69 Đường Điện Biên Phủ'),
    ('NV09', N'Mai', N'Khuyen', '1991-06-22', '2016-07-18', '0901234567', 13500000, 1900000, 'PX09', N'22 Đường Nguyễn Thị Minh Khai'),
    ('NV10', N'Bui', N'Linh', '1986-02-27', '2014-05-22', '0912345679', 15500000, 2600000, 'PX10', N'88 Đường Dogenzaka');

INSERT INTO NHACUNGCAP(maCongTy, tenCongTy, tenGiaoDich, SDT, Fax, Email, NCC_PXno, soNhaTenDuong)
VALUES 
    ('CT01', N'Công ty A', N'Giao dịch A', '0911111111', '0211111111', 'contactA@provider.com', 'PX01', N'12 Đường Trần Phú'),
    ('CT02', N'Nhà cung cấp B', N'Giao dịch B', '0922222222', '0222222221', 'contactB@provider.com', 'PX02', N'34 Đường Lý Thái Tổ'),
    ('CT03', N'Nhà cung cấp C', N'Giao dịch C', '0933333333', '0233333331', 'contactC@provider.com', 'PX03', N'56 Đường Nguyễn Huệ'),
    ('CT04', N'Nhà cung cấp D', N'Giao dịch D', '0944444444', '0244444441', 'contactD@provider.com', 'PX04', N'78 Đường Hàng Bông'),
    ('CT05', N'Nhà cung cấp E', N'Giao dịch E', '0955555555', '0255555551', 'contactE@provider.com', 'PX05', N'90 Đường Lê Lợi'),
    ('CT06', N'Nhà cung cấp F', N'Giao dịch F', '0966666666', '0266666661', 'contactF@provider.com', 'PX06', N'23 Đường Hàm Nghi'),
    ('CT07', N'Nhà cung cấp G', N'Giao dịch G', '0977777777', '0277777771', 'contactG@provider.com', 'PX07', N'45 Đường Pasteur'),
    ('CT08', N'Nhà cung cấp H', N'Giao dịch H', '0988888888', '0288888881', 'contactH@provider.com', 'PX08', N'67 Đường Điện Biên Phủ'),
    ('CT09', N'Nhà cung cấp I', N'Giao dịch I', '0999999999', '0299999991', 'contactI@provider.com', 'PX09', N'89 Đường Nguyễn Thị Minh Khai'),
    ('CT10', N'Nhà cung cấp J', N'Giao dịch J', '0900000000', '0200000001', 'contactJ@provider.com', 'PX10', N'10 Đường Dogenzaka'),
    ('CT11', N'Vinamilk', N'VINAMILK', '0900000004', '0203940440', 'contactK@provider.com', 'PX10', N'10 Đường Dogenzaka');
INSERT INTO LOAIHANG(maLoaiHang, tenLoaiHang)
VALUES 
    ('LH01', N'Đồ điện tử'),
    ('LH02', N'Thực phẩm'),
    ('LH03', N'Đồ gia dụng'),
    ('LH04', N'Quần áo'),
    ('LH05', N'Sách và văn phòng phẩm'),
    ('LH06', N'Đồ nội thất'),
    ('LH07', N'Dược phẩm'),
    ('LH08', N'Đồ chơi trẻ em'),
    ('LH09', N'Mỹ phẩm'),
    ('LH10', N'Thiết bị y tế');

INSERT INTO MATHANG(maHang, tenHang, maCongTy, maLoaiHang, soLuong, donViTinh, giaHang)
VALUES 
    ('MH01', N'Smartphone', 'CT01', 'LH01', 100, N'Cái', 1300000.00),
    ('MH02', N'Laptop', 'CT02', 'LH01', 50, N'Cái', 22500000.00),
    ('MH03', N'Gạo', 'CT03', 'LH02', 200, N'Kg', 20000.00),
    ('MH04', N'Nước mắm', 'CT04', 'LH02', 150, N'Lít', 25000.00),
    ('MH05', N'Bát đĩa', 'CT05', 'LH03', 300, N'Set', 120000.00),
    ('MH06', N'Áo sơ mi', 'CT06', 'LH04', 120, N'Cái', 250000.00),
    ('MH07', N'Sách giáo khoa', 'CT07', 'LH05', 500, N'Quyển', 35000.00),
    ('MH08', N'Ghế sofa', 'CT08', 'LH06', 20, N'Cái', 6500000.00),
    ('MH09', N'Paracetamol', 'CT09', 'LH07', 100, N'Hộp', 20000.00),
    ('MH10', N'Đồ chơi lắp ráp', 'CT10', 'LH08', 80, N'Cái', 140000.00),
    ('MH11', N'Sữa Vinamilk không đường', 'CT11', 'LH02', 80, N'Thùng', 200000.00),
	('MH12', N'Sữa hộp XYZ', 'CT11', 'LH02', 80, N'Hộp', 10000.00);

INSERT INTO DONDATHANG(soHD, maKH, maNV, ngayDatHang, ngayGiaoHang, ngayChuyenHang, DDH_PXno, soNhaTenDuong)
VALUES 
    ('HD01', 'KH01', 'NV01', '2024-10-01', '2024-10-05', '2024-10-03', 'PX01', N'15 Đường Trần Phú'),
    ('HD02', 'KH02', 'NV02', '2024-10-02', '2024-10-06', '2024-10-04', 'PX02', N'37 Đường Lý Thái Tổ'),
    ('HD03', 'KH03', 'NV03', '2024-10-03', '2024-10-07', '2024-10-05', 'PX03', N'58 Đường Nguyễn Huệ'),
    ('HD04', 'KH04', 'NV04', '2024-10-04', '2024-10-08', '2024-10-06', 'PX04', N'90 Đường Hàng Bông'),
    ('HD05', 'KH05', 'NV05', '2024-10-05', '2024-10-09', '2024-10-07', 'PX05', N'120 Đường Lê Lợi'),
    ('HD06', 'KH06', 'NV06', '2024-10-06', '2024-10-10', '2024-10-08', 'PX06', N'55 Đường Hàm Nghi'),
    ('HD07', 'KH07', 'NV07', '2024-10-07', '2024-10-11', '2024-10-09', 'PX07', N'78 Đường Pasteur'),
    ('HD08', 'KH08', 'NV08', '2024-10-08', '2024-10-12', '2024-10-10', 'PX08', N'67 Đường Điện Biên Phủ'),
    ('HD09', 'KH09', 'NV09', '2024-10-09', '2024-10-13', '2024-10-11', 'PX09', N'89 Đường Nguyễn Thị Minh Khai');

INSERT INTO CHITIETDATHANG(soHD, maHang, giaBan, soLuong, mucGiamGia)
VALUES 
    ('HD01', 'MH01', 15000000, 2, 0.1),   
    ('HD01', 'MH02', 25000000, 1, 0.05),  
    ('HD02', 'MH12', 12000, 5, 0),         
    ('HD02', 'MH04', 30000, 3, 0.15), 
    ('HD03', 'MH05', 150000, 4, 0.2),    
    ('HD03', 'MH06', 300000, 2, 0.1),
    ('HD04', 'MH07', 50000, 10, 0.05),
    ('HD04', 'MH08', 8000000, 1, 0.1), 
    ('HD05', 'MH09', 50000, 6, 0.2),   
    ('HD05', 'MH10', 200000, 3, 0.15),
	('HD06', 'MH03', 25000, 10, 0.12),
    ('HD06', 'MH11', 250000, 11, 0.12),
	('HD07', 'MH12', 25000, 2, 0.13);
set dateformat dmy
-------------------------------------------------------BÀI TẬP---------------------------------------------------------------------------
--------------------------------------------------------TUẦN 8---------------------------------------------------------------------------
---a)Cập nhật lại giá trị trường NGAYCHUYENHANG của những bản ghi có NGAYCHUYENHANG
---chưa xác định (NULL) trong bảng DONDATHANG bằng với giá trị của trường NGAYDATHANG.
UPDATE DONDATHANG
set ngayChuyenHang=ngayDatHang
where ngayChuyenHang is null
---------
alter table DONDATHANG
alter column ngayChuyenHang date null;
insert into DONDATHANG(soHD, maKH, maNV, ngayDatHang, ngayGiaoHang, DDH_PXno, soNhaTenDuong)
values ('HD10', 'KH02', 'NV01', '20/10/2024', '25/10/2024', 'PX08', '12 street')
select * from DONDATHANG
---------
---b)Tăng số lượng hàng của những mặt hàng do công ty VINAMILK cung cấp lên gấp đôi.
UPDATE MATHANG
set soLuong=2*soLuong
where MATHANG.maCongTy in(select maCongTy
				from NHACUNGCAP
				where NHACUNGCAP.tenCongTy= 'vinamilk')
select * from MATHANG
--c) Cập nhật giá trị của trường NOIGIAOHANG trong bảng DONDATHANG bằng địa chỉ của khách hàng đối 
--với những đơn đặt hàng chưa xác định được nơi giao hàng (giá trị trường NOIGIAOHANG bằng NULL).
update DONDATHANG
set DDH_PXno = null,soNhaTenDuong= null
where soHD in ('HD01','HD03','HD05')
update DONDATHANG 
set DDH_PXno = KH_PXno,
	soNhaTenDuong=kh.soNhaTenDuong
from KHACHHANG kh
join DONDATHANG ddh on kh.maKH = ddh.maKH
where DDH.DDH_PXno is null
select *  from DONDATHANG
select * from KHACHHANG 
where maKH = 'KH01' or maKH ='KH03' or maKH = 'KH05'
--d) Cập nhật lại dữ liệu trong bảng KHACHHANG sao cho nếu tên công ty và tên giao dịch của khách hàng 
-- trùng với tên công ty và tên giao dịch của một nhà cung cấp nào đó thì địa chỉ, điện thoại, fax, và email phải
-- giống nhau
UPDATE KHACHHANG
SET KH_PXno = ncc.NCC_PXno, 
    soNhaTenDuong = ncc.soNhaTenDuong, 
    SDT = ncc.SDT, 
    Fax = ncc.Fax, 
    Email = ncc.Email
FROM NHACUNGCAP ncc
WHERE KHACHHANG.tenCongTy = ncc.tenCongTy 
  AND KHACHHANG.tenGiaoDich = ncc.tenGiaoDich;
  select * from KHACHHANG
  select * from NHACUNGCAP
--e) Tăng lương lên gấp rưỡi cho những nhân viên bán được số lượng hàng nhiều hơn 100 trong năm 2022.
update NHANVIEN
set luongCB = 1.5*luongCB
where maNV in (
	SELECT maNV
	From DONDATHANG ddh, CHITIETDATHANG ctdh 
	where ddh.soHD = ctdh.soHD and YEAR(ddh.ngayGiaoHang) = 2024
	group by maNV
	Having sum(soLuong) > 10)
select * from NHANVIEN
--f) Tăng phụ cấp lên bằng 50% lương cho những nhân viên bán được hàng nhiều nhất.
UPDATE NHANVIEN
SET phuCap = 0.5 * luongCB
WHERE maNV IN (
    SELECT TOP 1 WITH TIES nv.maNV
    FROM NHANVIEN nv, DONDATHANG ddh, CHITIETDATHANG ctdh
	WHERE nv.maNV = ddh.maNV and ddh.soHD = ctdh.soHD
    GROUP BY nv.maNV
    ORDER BY SUM(ctdh.soLuong) DESC
);
--g) Giảm 25% lương của những nhân viên trong năm 2023 không lập được bất kỳ đơn đặt hàng nào.
update NHANVIEN 
set luongCB = luongCB * 0.75
where maNV NOT IN (
    select ddh.maNV 
	from DONDATHANG  ddh  
    where YEAR(ddh.ngayDatHang) = 2023
)

select * from NHANVIEN;



-------------------------------------------------BÀI CÁ NHÂN TUẦN 9------------------------------------------------------------------
	------------- 1. Địa chỉ và điện thoại của nhà cung cấp có tên giao dịch [VINAMILK] là gì?
SELECT TENCONGTY, NCC_PXno,soNhaTenDuong , SDT
FROM NHACUNGCAP
WHERE TENGIAODICH = N'Vinamilk'

		-----------2. Loại hàng thực phẩm do những công ty nào cung cấp và địa chỉ của các công ty đó là gì?
SELECT DISTINCT NCC.TENCONGTY, NCC.SONHATENDUONG, PX.TENPX AS 'Phường/Xã', QH.TENQH AS 'Quận/Huyện', TP.tenTT AS 'Tỉnh/Thành Phố',
LH.TENLOAIHANG
FROM NHACUNGCAP NCC, MATHANG MH, LOAIHANG LH, PHUONGXA PX, QUANHUYEN QH, TinhThanh TP
WHERE NCC.MACONGTY = MH.MACONGTY 
    AND MH.MALOAIHANG = LH.MALOAIHANG
    AND NCC.NCC_PXno = PX.maPX
    AND PX.QHno = QH.maQH
    AND QH.TTno = TP.maTT
    AND LH.TENLOAIHANG = N'Thực phẩm';

	------------ 3. Những khách hàng nào (tên giao dịch) đã đặt mua mặt hàng Sữa hộp XYZ của công ty?
SELECT distinct KH.maKH, KH.TENGIAODICH, MH.tenHang
FROM KHACHHANG AS KH, DONDATHANG AS DDH, CHITIETDATHANG AS CTDH, MATHANG MH
WHERE KH.maKH = DDH.maKH AND DDH.soHD = CTDH.soHD AND  
CTDH.maHang = MH.maHang AND MH.tenHang = N'Sữa Hộp XYZ'

------------- 4. Những đơn đặt hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những đơn đó là của công ty nào
	---- Những đơn đặt hàng yêu cầu giao tại công ty
SELECT DDH.*
FROM DONDATHANG AS DDH, KHACHHANG AS KH
WHERE KH.maKH = DDH.maKH AND KH.KH_PXno = DDH.DDH_PXno 
AND KH.SONHATENDUONG = DDH.soNhaTenDuong
	--- Những đơn đó thuộc công ty
SELECT KH.tenCongTy, KH.tenGiaoDich, DDH.soHD
FROM DONDATHANG AS DDH, KHACHHANG AS KH
WHERE KH.maKH = DDH.maKH AND KH.KH_PXno = DDH.DDH_PXno 
AND KH.SONHATENDUONG = DDH.soNhaTenDuong
								
	------------- 5. Tổng số tiền mà khách hàng phải trả cho mỗi đơn đặt hàng là bao nhiêu?

 SELECT  D.soHD,KH.maKH,SUM(GIABAN*soLuong) AS "Tổng tiền phải trả"
 FROM DONDATHANG AS D, CHITIETDATHANG AS CT, KHACHHANG KH
 WHERE D.soHD = CT.soHD and D.maKH = KH.maKH
 GROUP BY  D.soHD,KH.maKH

 	--------------6. Hãy cho biết tổng số tiền lời mà công ty thu được từ mỗi mặt hàng trong năm 2022.
SELECT NCC.TENCONGTY, MH.tenHang,SUM(CD.SOLUONG * CD.GIABAN * (1 - CD.mucGiamGia)) AS [Tiền bán], 
SUM(MH.GIAHANG * CD.SOLUONG) as [Tiền Nhập],
(SUM(CD.SOLUONG * CD.GIABAN * (1 - CD.mucGiamGia)) - SUM(MH.GIAHANG * CD.SOLUONG)) AS [Tiền lời]
FROM NHACUNGCAP NCC, CHITIETDATHANG CD, MATHANG MH, DONDATHANG AS DDH
WHERE DDH.soHD = CD.soHD AND CD.MAHANG = MH.MAHANG 
						 AND MH.MACONGTY = NCC.MACONGTY 
						 AND YEAR(DDH.NGAYGIAOHANG) = 2024
GROUP BY NCC.TENCONGTY, MH.tenHang;

------------------------------------------------------BÀI TẬP TUẦN 10-------------------------------------------------------
--CÂU 1: mã hàng, tên hàng và số lượng của các mặt hàng hiện có trong công ty
select ncc.tenCongTy, mh.maHang,mh.tenHang ,mh.soLuong as [Số lượng nhập], 
sum(ctdh.soLuong) as [Số lượng đã bán], (mh.soLuong - sum(ctdh.soLuong)) as [Số lượng còn]
from MATHANG mh 
join CHITIETDATHANG ctdh 
on  mh.maHang = ctdh.maHang
join NHACUNGCAP ncc
on mh.maCongTy = ncc.maCongTy
group by  ncc.tenCongTy, mh.maHang,mh.tenHang, mh.soLuong


--CÂU 2: cho biết mỗi mặt hàng trong công ty do ai cung cấp

select mh.tenHang, ncc.tenCongTy as [Nhà cung cấp]
from MATHANG mh
join NHACUNGCAP ncc
on mh.maCongTy = ncc.maCongTy

--CÂU 3: hãy cho biết số tiền lương mà công ty phải trả cho mỗi nhân viên là bao nhiêu
-- tính lương của từng nhân viên theo tháng
select maNV, Ho, Ten, (luongCB + phuCap) as [Tiền lương] 
from NHANVIEN

-- tính lương của từng nhân viên từ lúc vào làm
select maNV, Ho, Ten, ngayLamViec, luongCB, phuCap,
DATEDIFF(MONTH, ngayLamViec, GETDATE()) AS soThangLamViec,
    CASE 
        WHEN DATEDIFF(DAY, ngayLamViec, GETDATE()) >= 30 THEN DATEDIFF(MONTH, ngayLamViec, GETDATE()) * (luongCB + phuCap)
        ELSE 0
    END AS tongLuong
from NHANVIEN
update NHANVIEN
set ngayLamViec= '10/11/2024'
where maNV = 'NV01'
--CÂU 4: Những mặt hàng nào chưa từng được khách hàng mua
--except
SELECT maHang
FROM MATHANG
EXCEPT
SELECT maHang
FROM CHITIETDATHANG;
--not in
select *
from MATHANG
where maHang not in(
select maHang from CHITIETDATHANG)

--CÂU 5: hãy cho biết mỗi một khách hàng phải bỏ ra bao nhiêu tiền để đặt mua hàng của công ty
select maKH, ncc.tenCongTy, sum(ct.soLuong*ct.giaBan*(1-mucGiamGia)) as [Số tiền]
from DONDATHANG d
join CHITIETDATHANG ct
on d.soHD = ct.soHD
join MATHANG mh
on mh.maHang = ct.maHang
join NHACUNGCAP ncc
on ncc.maCongTy = mh.maCongTy
group by maKH, ncc.tenCongTy
--Câu 6: Hãy cho biết tổng số tiền lời mà công ty thu được từ mỗi mặt hàng trong năm 2022.
SELECT NCC.TENCONGTY, MH.tenHang,SUM(CD.SOLUONG * CD.GIABAN * (1 - CD.mucGiamGia)) AS [Tiền bán], 
SUM(MH.GIAHANG * CD.SOLUONG) as [Tiền Nhập],
(SUM(CD.SOLUONG * CD.GIABAN * (1 - CD.mucGiamGia)) - SUM(MH.GIAHANG * CD.SOLUONG)) AS [Tiền lời]
FROM NHACUNGCAP NCC, CHITIETDATHANG CD, MATHANG MH, DONDATHANG AS DDH
WHERE DDH.soHD = CD.soHD AND CD.MAHANG = MH.MAHANG 
						 AND MH.MACONGTY = NCC.MACONGTY 
						 AND YEAR(DDH.NGAYGIAOHANG) = 2024
GROUP BY NCC.TENCONGTY, MH.tenHang;
