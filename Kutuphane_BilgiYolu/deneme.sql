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

-- PROSEDÜR: Üye Ekleme [cite: 531]
CREATE PROCEDURE sp_UyeEkle(p_tc CHAR(11), p_ad VARCHAR(50), p_soy VARCHAR(50), p_tip VARCHAR(20))
BEGIN
    INSERT INTO Uyeler(TC_No, Ad, Soyad, UyeTipi) VALUES (p_tc, p_ad, p_soy, p_tip);
END;

-- PROSEDÜR: Üye Listeleme [cite: 534]
CREATE PROCEDURE sp_UyeListele()
BEGIN
    SELECT * FROM Uyeler;
END;

-- TETİKLEYİCİ: Stok Azaltma [cite: 539, 585]
CREATE TRIGGER tg_Stok_Azalt 
AFTER INSERT ON Odunc 
FOR EACH ROW 
UPDATE Materyaller SET StokAdedi = StokAdedi - 1 WHERE MateryalID = NEW.MateryalID;

-- TEST İŞLEMLERİ
INSERT INTO Kategoriler (KategoriAdi) VALUES ('Yazılım');
INSERT INTO Materyaller (ISBN_ISSN, Baslik, StokAdedi, KategoriID) VALUES ('111', 'Python Projesi', 5, 1);

-- Prosedürü Çalıştır
CALL sp_UyeEkle('12345678901', 'Remle', 'Temur', 'Öğrenci');
CALL sp_UyeListele();

-- Ödünç Ver (Trigger Testi)
INSERT INTO Odunc (UyeID, MateryalID, AlisTarihi) VALUES (1, 1, '2026-05-09');

-- Sonuç (Stok 4'e düşmeli)
SELECT Baslik, StokAdedi FROM Materyaller;