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
	Email varchar(30) not null,
	SDT char(11) not null,
	Fax char(10) not null
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
	SDT char(11) not null,
	luongCB money not null,
	phuCap money not null
)


create table NHACUNGCAP
(
	maCongTy char(10) primary key,
	tenCongTy nvarchar(50) not null,
	tenGiaoDich nvarchar(50) not null,
	diaChi nvarchar(50) not null,
	SDT char(11) not null,
	Fax char(10) not null,
	Email varchar(30) not null
)
create table CHITIETDATHANG
(
	soHD char(10) primary key,
	maHang char(10) not null,
	giaBan money not null,
	soLuong int not null,
	mucGiamGia float not null
)
create table MATHANG
(
	maHang char(10) primary key,
	tenHang nvarchar(50) not null,
	maCongTy char(10) not null,
	maLoaiHang char(10) not null,
	soLuong int not null,
	donViTinh char(10) not null,
	giaHang money not null
)
create table LOAIHANG
(
	maLoaiHang char(10) primary key,
	tenLoaiHang nvarchar(50) not null
)
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

