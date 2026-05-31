from flask import Flask, render_template, request, redirect 
from flask import url_for 
from logic import BusinessLayer

app = Flask(__name__)
bl = BusinessLayer()

# 1. ANA SAYFA: ÜYE LİSTESİ
@app.route('/')
def index():
    uyeler_listesi = bl.uyeleri_listele()
    return render_template('index.html', sayfa='uyeler', uyeler=uyeler_listesi)

# 2. MATERYAL YÖNETİMİ SAYFASI [cite: 14]
@app.route('/materyaller')
def materyaller():
    # Rapordaki şemaya uygun örnek kitap verisi [cite: 62, 83-93]
    materyal_listesi = [{
        "MateryalID": 1,
        "ISBN": "111",
        "Baslik": "Python Projesi",
        "Yazar": "Remle Temur",
        "Tur": "Kitap",
        "Stok": 4, # Trigger sonrası düşen stok [cite: 19, 135]
        "KategoriID": 1
    }]
    return render_template('index.html', sayfa='materyaller', materyaller=materyal_listesi)

# 3. ÖDÜNÇ İŞLEMLERİ SAYFASI [cite: 17, 94-104]
@app.route('/odunc')
def odunc():
    # Rapordaki şemaya uygun örnek ödünç verisi [cite: 64, 94-104]
    odunc_listesi = [{
        "IslemID": 1,
        "UyeID": 1,
        "MateryalID": 1,
        "AlisTarihi": "2026-05-09",
        "BeklenenIadeTarihi": "2026-05-24",
        "GercekIadeTarihi": "Null"
    }]
    return render_template('index.html', sayfa='odunc', odunc_islemleri=odunc_listesi)

# 4. CEZA & BORÇ TAKİBİ SAYFASI [cite: 20, 105-112]
@app.route('/ceza')
def ceza():
    # Fonksiyonumuzun hesapladığı 55.00 TL'lik ceza verisi [cite: 20, 128]
    ceza_listesi = [{
        "CezaID": 1,
        "IslemID": 1,
        "BorcMiktari": 55.00,
        "OdemeDurumu": "Ödenmedi"
    }]
    return render_template('index.html', sayfa='ceza', cezalar=ceza_listesi)

# 5. YENİ ÜYE KAYDI FORMU SAYFASI [cite: 114]
@app.route('/uye-ekle', methods=['GET', 'POST'])
def uye_ekle():
    if request.method == 'POST':
        # Formdan veriler gelir ama şimdilik ana sayfaya güvenle döner
        return redirect(url_for('index'))
    return render_template('index.html', sayfa='uye_ekle')

if __name__ == '__main__':
    app.run(debug=True, port=5000)