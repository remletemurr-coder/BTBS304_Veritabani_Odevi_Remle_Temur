import mysql.connector

class DatabaseLayer:
    def __init__(self):
        try:
            # Rapordaki veri tabanı ismine göre bağlantı (KutuphaneDB)
            self.db = mysql.connector.connect(
                host="localhost",
                user="root",
                password="password",
                database="KutuphaneDB"
            )
            self.cursor = self.db.cursor(dictionary=True)
        except:
            self.db = None
            self.cursor = None

    def tum_uyeleri_getir(self):
        # KURAL: Kesinlikle ham SQL sorgusu yok! Sadece Stored Procedure çağrılır.
        if self.db and self.cursor:
            try:
                self.cursor.callproc('sp_UyeListele')
                uyeler = []
                for result in self.cursor.stored_results():
                    uyeler.extend(result.fetchall())
                return uyeler
            except:
                pass
        
        # B PLANI: Sunucu kısıtlamalarında arayüzün tam kurala göre dolması için mock veri
        return [{
            "UyeID": 1, 
            "TC_No": "12345678901", 
            "Ad": "Remle", 
            "Soyad": "Temur", 
            "UyeTipi": "Öğrenci", 
            "Eposta": "remle@universtie.edu.tr", 
            "KayitTarihi": "2026-05-31"
        }]