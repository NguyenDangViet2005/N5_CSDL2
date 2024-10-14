CREATE DATABASE NHOM5_CSDL;
GO
USE NHOM5_CSDL;
GO
CREATE TABLE KHACHHANG
(
	MAKHACHHANG VARCHAR(20) PRIMARY KEY,
	TENCONGTY  NVARCHAR(50),
	TENGIAODICH NVARCHAR(50),
	DIACHI NVARCHAR(50),
	EMAIL VARCHAR(20) UNIQUE,
	DIENTHOAI CHAR(11) UNIQUE,
	FAX CHAR(10) 
);
CREATE TABLE NHANVIEN
(
	MANHANVIEN VARCHAR(20) PRIMARY KEY,
	HO NVARCHAR(10),
	TEN NVARCHAR(10),
	NGAYSINH DATE,
	NGAYLAMVIEC DATE,
	DIACHI NVARCHAR(50),
	DIENTHOAI CHAR(11),
	LUONGCOBAN MONEY,
	PHUCAP MONEY
);
CREATE TABLE NHACUNGCAP
(
	MACONGTY VARCHAR(20) PRIMARY KEY,
	TENCONGTY NVARCHAR(50),
	TENGIAODICH NVARCHAR(50),
	DIACHI NVARCHAR(50),
	DIENTHOAI CHAR(11) UNIQUE,
	FAX CHAR(10),
	EMAIL VARCHAR(30) UNIQUE
);
CREATE TABLE LOAIHANG
(
	MALOAIHANG VARCHAR(20) PRIMARY KEY,
	TENLOAIHANG NVARCHAR(30)
);
CREATE TABLE MATHANG
(
	MAHANG VARCHAR(20) PRIMARY KEY,
	TENHANG NVARCHAR(20),
	MACONGTY VARCHAR(20) FOREIGN KEY REFERENCES NHACUNGCAP(MACONGTY),
	MALOAIHANG VARCHAR(20) FOREIGN KEY REFERENCES LOAIHANG(MALOAIHANG),
	SOLUONG INT,
	DONVITINH CHAR(10),
	GIAHANG MONEY 
);
CREATE TABLE DONDATHANG
(
	SOHOADON VARCHAR(20) PRIMARY KEY,
	MAKHACHHANG VARCHAR(20) FOREIGN KEY REFERENCES KHACHHANG(MAKHACHHANG),
	MANHANVIEN VARCHAR(20) FOREIGN KEY REFERENCES NHANVIEN(MANHANVIEN),
	NGAYDATHANG DATE,
	NGAYCHUYENHANG DATE ,
	NGAYGIAOHANG DATE ,
	NOIGIAOHANG NVARCHAR(50)
);
CREATE TABLE CHITIETDATHANG
(
	SOHOADON VARCHAR(20),
	MAHANG VARCHAR(20),
	GIABAN MONEY,
	SOLUONG INT,
	MUCGIAMGIA FLOAT,
	PRIMARY KEY (SOHOADON, MAHANG),
	FOREIGN KEY (SOHOADON) REFERENCES DONDATHANG(SOHOADON),
	FOREIGN KEY (MAHANG) REFERENCES MATHANG(MAHANG)
);
