# AI Asistanları Kod Yazarken, Proje Yönetimi Neden Hala Eski Dünyada Kalsın?

Yazılım üretim biçimi değişti. Kod yazma işi artık yalnızca insan geliştiricilerin tek tek dosya açıp mantık kurduğu bir süreç değil. Giderek daha fazla ekip, AI asistanlarını kodlama, refactor, test yazımı, dokümantasyon ve hatta araştırma için aktif şekilde kullanıyor. Buna rağmen proje yönetimi tarafında halen çok eski bir dil konuşuyoruz: insan-gün, klasik sprint kapasitesi, genel geçer story point tartışmaları, belirsiz teslim tarihleri ve agent gerçeğini hesaba katmayan planlar.

Bu repository tam olarak bu boşluktan çıktı.

Buradaki temel fikir şu: Eğer yazılım delivery modeli AI-assisted hale geldiyse, proje yönetimi, planlama ve tahminleme pratiği de agent-native olmak zorunda. Sadece "AI ile daha hızlı kod yazıyoruz" demek yetmiyor. Asıl mesele, bu yeni üretim biçimini planlama diline, iş kırılımına, maliyet modeline ve yürütme modeline çevirebilmek.

## Problem Neydi?

Bugün birçok ekipte şu çelişki var:

- Kod üretiminde AI kullanılmaya başlandı.
- Fakat planlama tarafında halen klasik insan emeği merkezli tahminler yapılıyor.
- "Bu iş kaç gün sürer?" sorusu soruluyor ama aslında işin ne kadarının agent ile yapılacağı, hangi modelin kullanılacağı, kaç iterasyon gerekeceği, ne kadar review ve test overhead'i oluşacağı hesaba katılmıyor.

Bu da iki uca savrulan sonuçlar üretiyor:

1. Ya AI aşırı romantize ediliyor ve her iş "birkaç saatte biter" sanılıyor.
2. Ya da AI sadece bir yardımcı editör gibi görülüyor ve planlama neredeyse hiç değişmiyor.

Oysa gerçek dünya daha sistematik bir yaklaşım gerektiriyor. Bir işin süresi artık sadece insanın kaç saat ayıracağıyla değil, şu sorularla da şekilleniyor:

- Bu iş kaç ayrı work item'a bölünmeli?
- Hangi işler paralel yürütülebilir?
- Hangi işler derin reasoning isteyen modeller gerektirir?
- Hangi aşamalarda insan onayı gerekir?
- Hangi tool call, test ve düzeltme döngüleri maliyeti büyütür?
- Gerçekten otomatik yürütülebilecek işler hangileri, insanın karar vermesi gereken kritik noktalar hangileri?

Kısacası, artık sadece "effort estimation" değil, "agent-aware delivery design" yapmak gerekiyor.

## Bu Repository Ne Yapıyor?

Bu repository, proje yönetimini AI çağının gerçeklerine göre yeniden çerçeveleyen bir skill paketi sunuyor.

Ana hedefi şu:

- Bir fikri, repo'yu, dokümanı veya mevcut ürünü alıp
- onu sistematik bir delivery pipeline içine sokmak
- sonra da bunu hem insan kontrollü hem de agent destekli biçimde yürütebilmek

Repository'nin merkezinde 7 fazlı bir workflow var:

1. **Discover**
   Projenin gerçekte ne olduğunu, neyin var olduğunu, neyin eksik olduğunu anlamak.

2. **Scope**
   Belirsizlikleri azaltmak, gereksinimleri netleştirmek ve sınır çizmek.

3. **Architect**
   Teknik mimariyi, bileşen sınırlarını, kritik akışları ve failure mode'ları tasarlamak.

4. **Estimate**
   İşi sadece "kaç gün" diye değil; work item, token, model tier, risk ve iterasyon bazında tahminlemek.

5. **Plan**
   Proje charter, architecture doc, WBS, PBI, test case, release plan gibi artefaktları üretmek.

6. **Execute**
   İşi Think → Plan → Build → Review → Test → Ship döngüsü içinde, kontrollü şekilde yürütmek. Her aşamanın net bir sorumluluğu var. Telemetri 3 farklı stratejiyle (agent self-report, environment instrumented, post-hoc billing) yakalanıyor. Her iş kalemi tamamlandığında bütçe yakma oranı (token, maliyet, zaman) hesaplanıyor ve %80 eşiği aşılırsa erken uyarı veriliyor.

7. **Retro**
   Tahminlerle gerçekleşen çıktıları 6 adımlı bir karşılaştırma metodolojisiyle kıyaslamak: veri yükleme, iş kalemi bazında karşılaştırma, sapma hesabı, iş tipi bazında gruplama, provider/tier analizi ve risk doğruluğu kontrolü. Her retro sonrası cross-project calibration verisini biriktirerek bir sonraki projenin tahminlerini iyileştirmek.

Bu açıdan bakıldığında repository aslında klasik proje yönetim dokümantasyonu ile AI-assisted execution arasında bir köprü görevi görüyor.

## Neyi Farklı Yapmaya Çalıştık?

Bu repository'yi yazarken en önemli niyetlerden biri, proje yönetimini "AI coding'in yanında duran bir ek doküman kümesi" olmaktan çıkarmaktı.

Bizim için daha önemli olan şey şuydu:

**Kodlama biçimi değişiyorsa, planlama mantığı da değişmeli.**

Bu yüzden birkaç temel ilkeye odaklandık.

### 1. İnsan-gün yerine agent-aware tahminleme

Klasik proje planlarında genelde şu konuşulur:

- bu iş 3 gün
- bu ekran 2 gün
- bu entegrasyon 1 hafta

Ama agent destekli işleyişte daha doğru sorular şunlar:

- Bu iş kaç work item?
- Hangi work item hangi model tier ile daha uygun çözülür?
- Kaç okuma/yazma/test iterasyonu gerekir?
- Paralel yürütülebilir mi?
- İnsan review gerekli mi?
- Agent burada araştırma mı yapıyor, üretim mi yapıyor, yoksa belirsizlik mi çözüyor?

Bu repository'nin estimation katmanı tam burada devreye giriyor. Amaç kusursuz bir sayı üretmek değil; maliyet, zaman ve belirsizlik hakkında daha dürüst ve daha işletilebilir bir model kurmak.

### 2. Provider-agnostic düşünmek

AI delivery tasarımını tek bir model sağlayıcısına kilitlemek istemedik. Çünkü pratikte ekipler farklı sağlayıcılar, farklı model aileleri ve farklı fiyat/performans profilleri kullanıyor.

Bu yüzden yapı:

- provider-aware
- model tier temelli
- değiştirilebilir pricing mantığına açık

şekilde kurgulandı.

Yani sistemin amacı "şu vendor'ın şu modeli"ne bağımlı olmak değil; hangi tip iş için nasıl bir model seviyesi gerektiğini tarif edebilmek.

### 3. Human-in-the-loop ve full automation arasında seçim sunmak

Gerçek dünyada her proje tam otomatik yürütülemez. Bazı projelerde insan onayı, scope kararı, güvenlik kararı veya iş önceliklendirmesi kritik olur. Bazılarında ise agent'ın daha otonom çalışması istenir.

Bu yüzden repository üç execution mode etrafında tasarlandı:

- `manual`
- `hybrid`
- `auto`

Bu ayrım önemli. Çünkü AI-assisted delivery sadece "ajanı sal çalışsın" demek değil. Bazen kontrol, bazen hız, bazen de güvenilirlik önceliklidir. İyi bir proje sistemi bu farklılıkları kabul etmeli.

### 4. Doküman üretmek yetmez, state akışı da gerekir

Klasik proje dokümanları çoğu zaman statiktir. Yazılır, paylaşılır ve sonra unutulur.

Burada ise amaç sadece belge üretmek değildi. Fazlar arasında makine-okunur state dosyaları akıtarak şu soruya cevap vermek istedik:

Bir agent gerçekten bu planı okuyup bir sonraki faza kontrollü biçimde geçebilir mi?

Bu yüzden:

- discovery output'u
- scope output'u
- architecture output'u
- estimate output'u
- release-plan output'u
- execution log'u

birbirine veri taşıyan sözleşmeler gibi tasarlandı.

### 5. Retro ve calibration'ı sürecin sonuna eklemek

Birçok planlama sistemi tahmin yapar ama tahmininin ne kadar iyi çıktığını sistematik olarak öğrenmez.

Oysa agent destekli işlerde bu daha da önemli. Çünkü zaman içinde şunu öğrenmek gerekir:

- Hangi tip işler sürekli underestimate ediliyor?
- Hangi işler fazla review istiyor?
- Hangi model tier beklenenden pahalıya çıkıyor?
- Test ve fix döngüleri nerede patlıyor?
- Risk tahminleri gerçekten sapmayla korelasyon gösteriyor mu?

Bu repository'nin retro kısmı artık 6 adımlı bir karşılaştırma metodolojisi kullanıyor: veri yükleme, iş kalemi bazında karşılaştırma, sapma yüzdesi hesabı (`(gerçekleşen - tahmin) / tahmin * 100`), iş tipi bazında gruplama, provider/tier analizi ve risk doğruluğu kontrolü. Çıktıları da tam şema ile tanımlı: `retro-report.json` tüm karşılaştırma verilerini, `estimation-calibration.json` ise provider, iş tipi ve risk seviyesi bazında çarpanları taşıyor.

### 6. Cross-project calibration ile projeler arası öğrenme

Tek proje bazında calibration yapmak iyi bir başlangıç ama gerçek güç projeler arası birikimde ortaya çıkıyor. Her retro sonrası oluşan calibration verileri `references/calibration-history.jsonl` dosyasına ekleniyor. Estimate fazı bu dosyayı okuyup tüm projeler üzerinden running average hesaplıyor ve bunu baseline olarak kullanıyor.

Bu mekanizma sayesinde:

- İlk projenin tahminleri referans benchmark'larına dayanıyor
- İkinci projeden itibaren gerçek veriye dayalı calibration devreye giriyor
- Her yeni proje, önceki projelerin deneyiminden faydalanıyor
- İş tipi bazında (feature, api_endpoint, scaffold, vb.) ve provider bazında ayrı çarpanlar birikiyor

Böylece sistem zamanla kendini iyileştiren bir tahminleme motoru haline geliyor.

## Repository İçinde Neler Var?

Repository birkaç ana parçadan oluşuyor:

### `SKILL.md`

Bu, ana orkestratör. Kullanıcı niyetine göre hangi fazdan başlanacağını tarif ediyor ve genel pipeline mantığını taşıyor.

### `skills/`

Her faz için ayrı alt skill dosyaları var:

- `discover`
- `scope`
- `architect`
- `estimate`
- `plan`
- `execute`
- `retro`

Bu ayrım önemli çünkü proje yönetimini tek, büyük ve dağınık bir prompt yerine; sorumlulukları belirgin alt fazlara bölen bir yapıya dönüştürüyor.

### `config/pipeline-config.json`

Pipeline varsayımları burada yaşıyor. Execution mode, approval gate, provider varsayımları, telemetry beklentileri gibi davranışsal ayarlar buradan şekilleniyor.

### `references/`

Bu klasörde workflow'ü destekleyen referans artefaktlar var:

- discovery interview guide
- estimation benchmark'ları
- PBI template
- test case template
- planlama doküman şablonları
- cross-project calibration history (JSONL formatında)

Yani repository sadece "nasıl düşün" demiyor; aynı zamanda "hangi formatta çıktı üret" ve "projeler arasında neyi biriktir" kısımlarını da taşıyor.

### `install.sh`

Bu artık sadece bir dosya doğrulayıcı değil, gerçek bir kurulum scripti. Çalıştırıldığında:

1. Tüm gerekli dosyaların varlığını kontrol ediyor
2. Claude Code ortamını (`~/.claude/`) tespit ediyor
3. Skill'i `~/.claude/commands/` altına symlink olarak kuruyor
4. Kullanıcıya varsayılan provider seçimi sunuyor (openai / anthropic)
5. Kurulum sonrası doğrulama yapıyor (symlink geçerliliği, JSON validasyonu)

Non-interactive ortamlarda da sorunsuz çalışıyor.

## Burada Aslında Neyi Başarmaya Çalıştık?

Bu repository'nin amacı yeni bir proje yönetim metodolojisi icat etmek değil. Daha çok şu gerçeği ciddiye almak:

AI-assisted coding artık istisna değil, giderek ana akım hale geliyor.

Eğer öyleyse, aşağıdaki şeyleri yeniden düşünmek zorundayız:

- scope nasıl netleştirilir
- mimari ne kadar erken detaylandırılır
- tahmin neye göre yapılır
- review ve approval nerede tutulur
- execution nasıl izlenir
- retrospective neyi ölçer

Bu repository ile başarmaya çalıştığımız şey, proje yönetimini agent üretkenliğiyle hizalamak.

Başka bir deyişle:

- Kod AI ile yazılıyorsa
- Testler AI ile üretiliyorsa
- Refactor ve araştırma AI ile hızlanıyorsa

o zaman proje planının da bu gerçeği modellemesi gerekir.

Sadece velocity konuşmak yetmez.
Sadece sprint kapasitesi konuşmak yetmez.
Sadece insan-gün konuşmak hiç yetmez.

Artık şunları da konuşmalıyız:

- agent workload
- model selection
- reasoning depth
- tool-call overhead
- parallel execution
- approval boundaries
- telemetry quality ve capture stratejileri
- budget burn tracking ve erken uyarı mekanizmaları
- iş tipi ve provider bazında calibration
- projeler arası calibration birikimi

## Bu Yazının Ana Tezi

Önümüzdeki dönemde güçlü ekipler sadece AI kullanan ekipler olmayacak.

Asıl güçlü ekipler, AI'yı proje tasarımına, iş kırılımına, tahminlemeye ve delivery yönetimine entegre eden ekipler olacak.

Yani mesele "AI ile kod yazmak" değil.

Mesele, **AI ile yürütülen bir teslimat sistemini bilinçli şekilde tasarlamak**.

Bu repository'yi o yüzden önemli buluyorum. Çünkü burada amaç yalnızca daha fazla çıktı üretmek değil; yeni üretim modeline uygun bir proje yönetim omurgası kurmak.

Ve bence önümüzdeki birkaç yılın asıl tartışması da burada olacak:

Kod yazımı AI ile hızlanırken, proje yönetimi ve planlama bunun gerisinde kalacak mı?

Yoksa biz teslimat sistemlerini de agent çağının mantığına göre yeniden mi kuracağız?

Bu repository ikinci seçeneği ciddiye alan küçük ama net bir deneme.
