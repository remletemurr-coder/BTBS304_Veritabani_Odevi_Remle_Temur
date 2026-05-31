-- ========================================================
-- 1. TABLOLARIN OLUŞTURULMASI
-- ========================================================
CREATE TABLE Kategoriler (
    KategoriID INT AUTO_INCREMENT PRIMARY KEY,
    KategoriAdi VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Uyeler (
    UyeID INT AUTO_INCREMENT PRIMARY KEY,
    TC_No CHAR(11) NOT NULL UNIQUE,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    UyeTipi VARCHAR(20) NOT NULL,
    KayitTarihi DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Materyaller (
    MateryalID INT AUTO_INCREMENT PRIMARY KEY,
    ISBN_ISSN VARCHAR(20) UNIQUE,
    Baslik VARCHAR(250) NOT NULL,
    StokAdedi INT DEFAULT 0,
    KategoriID INT,
    FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID)
);

CREATE TABLE Odunc (
    IslemID INT AUTO_INCREMENT PRIMARY KEY,
    UyeID INT NOT NULL,
    MateryalID INT NOT NULL,
    AlisTarihi DATE NOT NULL,
    FOREIGN KEY (UyeID) REFERENCES Uyeler(UyeID),
    FOREIGN KEY (MateryalID) REFERENCES Materyaller(MateryalID)
);

-- ========================================================
-- 2. SAKLI YORDAMLAR (STORED PROCEDURES)
-- ========================================================

-- A. ÜYE EKLEME PROCEDURI
CREATE PROCEDURE sp_UyeEkle(p_tc CHAR(11), p_ad VARCHAR(50), p_soy VARCHAR(50), p_tip VARCHAR(20))
INSERT INTO Uyeler(TC_No, Ad, Soyad, UyeTipi) VALUES (p_tc, p_ad, p_soy, p_tip);

-- B. ÜYE LİSTELEME PROCEDURI
CREATE PROCEDURE sp_UyeListele()
SELECT * FROM Uyeler;

-- C. ÜYE GÜNCELLEME PROCEDURI
CREATE PROCEDURE sp_UyeGuncelle(p_uye_id INT, p_yeni_tip VARCHAR(20))
UPDATE Uyeler SET UyeTipi = p_yeni_tip WHERE UyeID = p_uye_id;

-- D. MATERYAL SİLME PROCEDURI
CREATE PROCEDURE sp_MateryalSil(p_materyal_id INT)
DELETE FROM Materyaller WHERE MateryalID = p_materyal_id;

-- ========================================================
-- 3. SAKLI FONKSİYONLAR (FUNCTIONS)
-- ========================================================
CREATE FUNCTION fn_CezaHesapla(p_gun INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
RETURN p_gun * 5.50;

-- ========================================================
-- 4. TETİKLEYİCİLER (TRIGGERS)
-- ========================================================
CREATE TRIGGER tg_Stok_Azalt 
AFTER INSERT ON Odunc 
FOR EACH ROW 
UPDATE Materyaller SET StokAdedi = StokAdedi - 1 WHERE MateryalID = NEW.MateryalID;
-- ========================================================
-- 5. CANLI TEST VE SİMÜLASYON İŞLEMLERİ
-- ========================================================

-- Temel Verilerin Eklenmesi
INSERT INTO Kategoriler (KategoriAdi) VALUES ('Yazılım');
INSERT INTO Materyaller (ISBN_ISSN, Baslik, StokAdedi, KategoriID) VALUES ('111', 'Python Projesi', 5, 1);

-- 1. Prosedür Testi: Üye Ekleme ve Listeleme
CALL sp_UyeEkle('12345678901', 'Remle', 'Temur', 'Öğrenci');
CALL sp_UyeListele();

-- 2. Prosedür Testi: Üye Güncelleme (Öğrenciyi Akademisyen yapıyoruz)
CALL sp_UyeGuncelle(1, 'Akademisyen');
SELECT * FROM Uyeler;

-- 3. Trigger Testi: Ödünç Verildiğinde Stoğun 5'ten 4'e Düşmesi
INSERT INTO Odunc (UyeID, MateryalID, AlisTarihi) VALUES (1, 1, '2026-05-09');
SELECT Baslik, StokAdedi FROM Materyaller;

-- 4. Fonksiyon Testi: Gecikme Cezası Hesaplama (10 gün için 55.00 TL çıkmalı)
SELECT fn_CezaHesapla(10) AS Hesaplanan_Gecikme_Cezasi;