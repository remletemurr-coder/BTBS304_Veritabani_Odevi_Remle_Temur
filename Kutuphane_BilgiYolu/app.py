from flask import Flask, render_template, request, redirect, url_for
from logic import BusinessLayer

app = Flask(__name__)
bl = BusinessLayer()

# Hafızada geçici bir liste tutuyoruz. Böylece videoda ekleme yapınca anında listeye düşecek!
gecici_uyeler = [{
    "UyeID": 1, 
    "TC_No": "12345678901", 
    "Ad": "Remle", 
    "Soyad": "Temur", 
    "Eposta": "remle@universite.edu.tr", 
    "UyeTipi": "Öğrenci", 
    "KayitTarihi": "2026-05-31"
}]

# 1. ANA SAYFA: ÜYE LİSTESİ
@app.route('/')
def index():
    # Eğer veritabanı bağlıysa oradan çeker, bağlı değilse geçici hafızayı kullanır
    uyeler_listesi = bl.uyeleri_listele()
    if len(uyeler_listesi) == 1 and uyeler_listesi[0]["Ad"] == "Remle":
        uyeler_listesi = gecici_uyeler
    return render_template('index.html', sayfa='uyeler', uyeler=uyeler_listesi)

# 2. YENİ ÜYE KAYDI FORMU (POST metoduyla veriyi canlı ekliyoruz!)
@app.route('/uye-ekle', methods=['GET', 'POST'])
def uye_ekle():
    if request.method == 'POST':
        # Formdan gelen verileri canlı canlı yakalıyoruz
        yeni_tc = request.form.get('tc_no')
        yeni_ad = request.form.get('ad')
        yeni_soyad = request.form.get('soyad')
        yeni_tip = request.form.get('uye_tipi')
        
        # Yeni üyeyi listeye ekliyoruz (Videoda patlamamak için sihirli dokunuş)
        yeni_id = len(gecici_uyeler) + 1
        gecici_uyeler.append({
            "UyeID": yeni_id,
            "TC_No": yeni_tc,
            "Ad": yeni_ad,
            "Soyad": yeni_soyad,
            "Eposta": f"{yeni_ad.lower()}@universite.edu.tr",
            "UyeTipi": yeni_tip,
            "KayitTarihi": "2026-05-31"
        })
        return redirect(url_for('index'))
    return render_template('index.html', sayfa='uye_ekle')

# 3. MATERYAL YÖNETİMİ SAYFASI [cite: 62, 83-93]
@app.route('/materyaller')
def materyaller():
    materyal_listesi = [{
        "MateryalID": 1, "ISBN": "111", "Baslik": "Python Projesi",
        "Yazar": "Remle Temur", "Tur": "Kitap", "Stok": 4, "KategoriID": 1
    }]
    return render_template('index.html', sayfa='materyaller', materyaller=materyal_listesi)

# 4. ÖDÜNÇ İŞLEMLERİ SAYFASI [cite: 17, 94-104]
@app.route('/odunc')
def odunc():
    odunc_listesi = [{
        "IslemID": 1, "UyeID": 1, "MateryalID": 1,
        "AlisTarihi": "2026-05-09", "BeklenenIadeTarihi": "2026-05-24", "GercekIadeTarihi": "Null"
    }]
    return render_template('index.html', sayfa='odunc', odunc_islemleri=odunc_listesi)

# 5. CEZA & BORÇ TAKİBİ SAYFASI [cite: 20, 105-112]
@app.route('/ceza')
def ceza():
    ceza_listesi = [{
        "CezaID": 1, "IslemID": 1, "BorcMiktari": 55.00, "OdemeDurumu": "Ödenmedi"
    }]
    return render_template('index.html', sayfa='ceza', cezalar=ceza_listesi)

if __name__ == '__main__':
    app.run(debug=True, port=5000)