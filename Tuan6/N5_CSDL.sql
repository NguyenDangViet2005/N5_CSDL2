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
create table CHITIETDONHANG
(
	soHD char(10) primary key,
	maHang char(10) not null,
	giaBan money not null,
	soLuong int not null,
	mucGiamGia float not null
)
create table MAHANG
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