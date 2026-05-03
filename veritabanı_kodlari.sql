-- TABLOLAR
CREATE TABLE Kategoriler (
    KategoriID INT PRIMARY KEY AUTO_INCREMENT,
    KategoriAdi VARCHAR(100) NOT NULL
);

CREATE TABLE Uyeler (
    UyeID INT PRIMARY KEY AUTO_INCREMENT,
    TC_No CHAR(11) UNIQUE NOT NULL,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    UyeTipi ENUM('Öğrenci', 'Akademisyen') NOT NULL,
    Eposta VARCHAR(100),
    KayitTarihi DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Materyaller (
    MateryalID INT PRIMARY KEY AUTO_INCREMENT,
    ISBN_ISSN VARCHAR(20) UNIQUE,
    Baslik VARCHAR(200) NOT NULL,
    Yazar VARCHAR(100),
    MateryalTuru ENUM('Kitap', 'Makale', 'Dergi') NOT NULL,
    StokAdedi INT DEFAULT 5,
    KategoriID INT,
    FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID)
);

CREATE TABLE Odunc_Islemleri (
    IslemID INT PRIMARY KEY AUTO_INCREMENT,
    UyeID INT NOT NULL,
    MateryalID INT NOT NULL,
    AlisTarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    BeklenenIadeTarihi DATETIME NOT NULL,
    GercekIadeTarihi DATETIME DEFAULT NULL,
    FOREIGN KEY (UyeID) REFERENCES Uyeler(UyeID),
    FOREIGN KEY (MateryalID) REFERENCES Materyaller(MateryalID)
);

-- STORED PROCEDURE
CREATE PROCEDURE sp_UyeListele()
BEGIN
    SELECT * FROM Uyeler;
END;

-- FUNCTION
CREATE FUNCTION fn_CezaHesapla(gun INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN gun * 5.50;
END;

-- TRIGGER
CREATE TRIGGER trg_StokAzalt
AFTER INSERT ON Odunc_Islemleri
FOR EACH ROW
BEGIN
    UPDATE Materyaller SET StokAdedi = StokAdedi - 1 WHERE MateryalID = NEW.MateryalID;
END;



-- TEST VERİLERİ EKLEME
INSERT INTO Kategoriler (KategoriAdi) VALUES ('Yazılım'), ('Edebiyat');

INSERT INTO Uyeler (TC_No, Ad, Soyad, UyeTipi, Eposta) 
VALUES ('11122233344', 'Remle', 'Temur', 'Öğrenci', 'remle@bartin.edu.tr');

INSERT INTO Materyaller (ISBN_ISSN, Baslik, Yazar, MateryalTuru, StokAdedi, KategoriID) 
VALUES ('123-456', 'Veritabanı Yönetimi', 'Dr. Bayram Akgül', 'Kitap', 10, 1);

-- PROCEDURE ÇALIŞTIRMA
CALL sp_UyeListele();

-- TETİKLEYİCİ TESTİ (Kitap ödünç al, stok 10'dan 9'a düşecek mi gör)
INSERT INTO Odunc_Islemleri(UyeID, MateryalID, BeklenenIadeTarihi) 
VALUES (1, 1, '2026-06-01');

-- SONUÇLARI GÖRME
SELECT * FROM Materyaller;